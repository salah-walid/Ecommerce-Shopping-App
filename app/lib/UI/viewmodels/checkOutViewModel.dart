import 'dart:convert';

import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/models/orderData.dart';
import 'package:ecom/core/services/apiService.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/core/services/dialog_service.dart';
import 'package:ecom/core/services/navigation_service.dart';
import 'package:ecom/core/services/orderService.dart';
import 'package:ecom/core/services/paymentService.dart';
import 'package:ecom/locator.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:stripe_payment/stripe_payment.dart';

class CheckOutViewModel extends BaseModel {
  AuthentificationService _authentificationService = locator<AuthentificationService>();
  OrderService _orderService = locator<OrderService>();
  PaymentService _paymentService = locator<PaymentService>();
  DialogService _dialogService = locator<DialogService>();
  ApiService _apiService = locator<ApiService>();
  NavigationService _navigationService = locator<NavigationService>();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  bool checkingOut = false;

  void formChanged(CreditCardModel creditCardModel){
    cardNumber = creditCardModel.cardNumber;
    expiryDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;
    notifyListeners();
  }

  void proceed() async{

    if(_orderService.cartData.orderList.length == 0 || checkingOut)
      return;

    OrderData order = _orderService.cartData;

    CreditCard creditCard = CreditCard(
      number: cardNumber,
      expMonth: int.tryParse(expiryDate.split("/")[0]),
      expYear: int.tryParse(expiryDate.split("/")[1]),
      cvc: cvvCode,
      name: cardHolderName
    );

    checkingOut = true;
    notifyListeners();

    String sid = await _paymentService.proceedPayment(creditCard);
    if(sid == null){
      _dialogService.showDialog(title: "Error", description: "Credit card information error");
      return;
    }

    order.user = _authentificationService.user.id;

    dynamic serialised = order.toMap();
    for(int i=0; i < serialised["orderList"].length; i++){
      serialised["orderList"][i]["product"] = serialised["orderList"][i]["product"]["id"];
      serialised["orderList"][i]["uom"] = serialised["orderList"][i]["uom"]["id"];
      serialised["orderList"][i]["color"] = serialised["orderList"][i]["color"]["id"];
      serialised["orderList"][i]["size"] = serialised["orderList"][i]["size"]["id"];
    }

    try{
      String orderNumber = await _apiService.postOrder(jsonEncode(serialised), sid);
      _dialogService.showDialog(title: "success", description: "Your order #ORD$orderNumber was finished successfully");
      _orderService.resetCart();
      _navigationService.pop();
      _navigationService.pop();
    }catch (e){
      _dialogService.showDialog(title: "Error", description: "Your order coudn't be proceeded\n error : ${e.toString()}");
    }

    checkingOut = false;
    notifyListeners();
  }
}