import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/models/failure.dart';
import 'package:ecom/core/models/orderData.dart';
import 'package:ecom/core/models/productOrderData.dart';
import 'package:ecom/core/models/userData.dart';
import 'package:ecom/core/services/apiService.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/core/services/dialog_service.dart';
import 'package:ecom/core/services/navigation_service.dart';
import 'package:ecom/core/services/orderService.dart';
import 'package:ecom/locator.dart';
import 'package:flutter/material.dart';

enum BillingAdressUsage{sameAdress, newAdress}

class CartViewModel extends BaseModel {
  OrderService _orderService = locator<OrderService>();
  ApiService _apiService = locator<ApiService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  AuthentificationService _authentificationService = locator<AuthentificationService>();

  TextEditingController promoCodeFieldController = TextEditingController();
  bool sameDeliveryLoading = false;

  final TextEditingController typeAheadController = TextEditingController();

  OrderData get orderData => _orderService.cartData;

  BillingAdressUsage currentAdressType = BillingAdressUsage.sameAdress;
  bool showSameDayDelivery = true;

  bool totalCalculated = false;
  bool calculatingTotal = false;

  final formState = GlobalKey<FormState>();

  final TextEditingController deliveryAdressC = TextEditingController();
  final TextEditingController deliveryCityC = TextEditingController();
  final TextEditingController deliveryStateC = TextEditingController();
  final TextEditingController deliveryZipCodeC = TextEditingController();
  final TextEditingController deliveryCountryC = TextEditingController();

  init() async{
    calculateSummary();
    showSameDayDelivery = (await checkDistance());
    _orderService.changeCart((order) => order.sameDayDelivery = showSameDayDelivery);
    notifyListeners();
  }

  Future<bool> checkDistance() async{
    String adress = "";

    if(currentAdressType == BillingAdressUsage.sameAdress){
      UserData user = _authentificationService.user;
      adress = "${user.deliveryAdress}, ${user.deliveryCity}, ${user.deliveryState} ${user.deliveryZipCode}, ${user.deliveryCountry}";
    }else{
      adress = "${deliveryAdressC.text}, ${deliveryCityC.text}, ${deliveryStateC.text} ${deliveryZipCodeC.text}, ${deliveryCountryC.text}";
    }

    return await _apiService.getSetting("home_position", body: {"adress" : adress});
  }

  void radioChanged(BillingAdressUsage t){
    currentAdressType = t;
    _orderService.changeCart((order) => order.sameDayDelivery = false);
    notifyListeners();
  }

  void sameDayDeliveryChanged(bool value) async{
    sameDeliveryLoading = true;
    notifyListeners();

    try{
      if(value){
        if(!await checkDistance())
          throw Failure("Your position is too far from the company position");
      }
    }catch(e){
      await _dialogService.showDialog(title: "Error", description: e.toString());
      return;
    }finally{
      sameDeliveryLoading = false;
      notifyListeners();
    }

    _orderService.changeCart((order) => order.sameDayDelivery = value);
    calculateSummary();
    notifyListeners();
  }

  onCartProductDelete(ProductOrderData product) {
    orderData.orderList.remove(product);
    calculateSummary();
    notifyListeners();
  }

  onProductQuantityChanged(int index, int value) {
    orderData.orderList[index].quantity += value;
    if(orderData.orderList[index].quantity < 1)
      orderData.orderList[index].quantity = 1;
    
    orderData.orderList[index].price =(
      orderData.orderList[index].unitPrice *
      orderData.orderList[index].uom.value *
      orderData.orderList[index].quantity
    );
    calculateSummary();
    notifyListeners();
  }

  void calculateSummary() async{

    calculatingTotal = true;
    notifyListeners();

    try{
      Map response = await _apiService.calculateOrderTotal(_orderService.cartData);

      if(response.containsKey("total")){
        _orderService.changeCart((order) {
          order.subTotal = response["subTotal"].toDouble();
          order.shipping = response["shipping"].toDouble();
          order.estimatedTax = response["tax"].toDouble();
          order.total = response["total"].toDouble();
        });
        totalCalculated = true;
      }else{
        throw Failure("Wrong results returned from the server");
      }

    }catch (e){
      totalCalculated = false;
      _dialogService.showDialog(title: "Error", description: e.toString());
    }

    calculatingTotal = false;
    notifyListeners();
  }

  void onPromoCodeClicked() async{
    setState(ViewState.Busy);
    String code = promoCodeFieldController.text;
    double promo = await _apiService.getPromoCode(code);

    if(promo != null){
      _orderService.changeCart((order) {order.promo = promo; order.promoCode = code;});
      calculateSummary();
    }else{
      _dialogService.showDialog(title: "promo code", description: "Couldn't retrive promo code or promo code inexisting");
    }
    
    setState(ViewState.Idle);
  }

  void checkOut() async{

    if(!_authentificationService.isConnected){
      await _dialogService.showDialog(title: "Error", description: "Please register before confirming the order");
      return;
    }else if(_orderService.cartData.orderList.length == 0){
      await _dialogService.showDialog(title: "Error", description: "Please add products to the cart");
      return;
    }

    
    if(currentAdressType == BillingAdressUsage.newAdress){
      if(!formState.currentState.validate()){
        await _dialogService.showDialog(title: "Missing infos", description: "Please fill the adresses");
        return;
      }
      formState.currentState.save();
    }else{
      orderData.billingAdress = _authentificationService.user.billingAdress;
      orderData.deliveryAdress = _authentificationService.user.deliveryAdress;
      orderData.deliveryMobileNumber = _authentificationService.user.deliveryMobileNumber;
      orderData.billingMobileNumber = _authentificationService.user.billingMobileNumber;

      orderData.deliveryCity = _authentificationService.user.deliveryCity;
      orderData.deliveryState = _authentificationService.user.deliveryState;
      orderData.deliveryZipCode = _authentificationService.user.deliveryZipCode;
      orderData.deliveryCountry = _authentificationService.user.deliveryCountry;

      orderData.billingCity = _authentificationService.user.billingCity;
      orderData.billingState = _authentificationService.user.billingState;
      orderData.billingZipCode = _authentificationService.user.billingZipCode;
      orderData.billingCountry = _authentificationService.user.billingCountry;
    }

    _navigationService.navigateTo(RoutesManager.checkOut);
  }

  void billingAdressSubmited(String value) async{

    /* Address result = (await Geocoder.local.findAddressesFromQuery(value + ", Malaysia")).first;
    
    billingStateC.text = result.locality;
    billingCityC.text = result.subLocality;
    billingZipCodeC.text = result.postalCode;
    
    notifyListeners(); */
  }

  deliveryAdresseSubmited(String value) async{

    /* Address result = (await Geocoder.local.findAddressesFromQuery(value + ", Malaysia")).first;
    
    deliveryStateC.text = result.locality;
    deliveryCityC.text = result.subLocality;
    deliveryZipCodeC.text = result.postalCode;
    
    notifyListeners(); */
  }
}