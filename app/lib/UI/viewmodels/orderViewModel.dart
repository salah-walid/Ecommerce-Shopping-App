import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/models/orderData.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/models/orderState.dart';
import 'package:ecom/core/services/apiService.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/core/services/dialog_service.dart';
import 'package:ecom/core/services/navigation_service.dart';
import 'package:ecom/locator.dart';


class OrderViewModel extends BaseModel {
  AuthentificationService _authentificationService = locator<AuthentificationService>();
  ApiService _apiService = locator<ApiService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  List<OrderData> orders;

  bool refunding = false;

  void init(OrderState state) => orders = _authentificationService.user.orders.where((element) {
      if(state == OrderState.completed)
        return element.orderState == OrderState.completed ||
                element.orderState == OrderState.canceledByUser ||
                  element.orderState == OrderState.canceledByAdmin;
      return element.orderState == state;
    }
  ).toList();

  void refund(int id) async{
    if(refunding && !(await _dialogService.showConfirmationDialog(title: "Refunding", description: "Do you really want to refund this order")).confirmed)
      return;

    refunding = true;
    try{
      await _apiService.refundOrder(id);
      _dialogService.showDialog(title: "Success", description: "Order refunded successfully");
      _navigationService.pop();
    }catch (e){
      _dialogService.showDialog(title: "Error", description: e.toString());
    }
    refunding = false;
  }

  void onDetailShow(OrderData order) async{
    _navigationService.navigateTo(RoutesManager.orderViewDetail, arguments: order);
  }

}