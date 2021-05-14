import 'dart:io';

import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/models/dialog_models.dart';
import 'package:ecom/core/models/failure.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:ecom/core/models/userData.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/core/services/dialog_service.dart';
import 'package:ecom/core/services/orderService.dart';
import 'package:ecom/locator.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewModel extends BaseModel {
  AuthentificationService _authentificationService = locator<AuthentificationService>();
  OrderService _orderService = locator<OrderService>();
  DialogService _dialogService = locator<DialogService>();

  UserData get user => _authentificationService.user;
  List<ProductData> get wishList => _orderService.wishList;
  bool get isConnected => _authentificationService.isConnected;

  bool userIsLoading =false;
  Either<Failure, UserData> userRequest;

  init() {
    if(isConnected)
      getUser();
  }

  void getUser() async{
    userIsLoading = true;
    notifyListeners();
    
    await Task(
      () => _authentificationService.getUser()
    )
      .attempt()
      .mapLeftToFailure()
      .run()
      .then((value) => userRequest = value);
    
    userIsLoading = false;
    notifyListeners();
  }

  void logOut() async{
    if((await _dialogService.showConfirmationDialog(title: "Confirmation", description: "Do you really want to log out")).confirmed)
      _authentificationService.logOut();
      notifyListeners();
  }

  void removeProductFromWhichList(ProductData wishList) {
    _orderService.removeItemFromWishList(wishList);
    notifyListeners();
  }


  updateProfile() async{
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      try{
        if(await _authentificationService.updateUser({}, image)){
          await _dialogService.showDialog(title: "Success", description: "Profile image updated");
          getUser();
        }
      }catch (e){
        await _dialogService.showDialog(title: "Error", description: "Error updating adresses : ${e.toString()}");
      }
    }
  }

  updateBillingAddress() async{
    DialogResponse response = await _dialogService.showFieldsDialog(
      title: "Billing", 
      field1: "Billing adress", 
      field2: "Phone number",
      field3: "City",
      field4: "State",
      field5: "Zip / Postal Code",
      field6: "Country",
    );
    if(!response.confirmed)
      return;
    try{
      Map<String, String> body = {
        "billingAdress" : response.adress,  
        "billingMobileNumber" : response.phoneNumber,
        "billingCity" : response.city,
        "billingState" : response.state,
        "billingZipCode" : response.zipCode,
        "billingCountry" : response.country,
      };
      if(await _authentificationService.updateUser(body, null)){
        await _dialogService.showDialog(title: "Success", description: "Adresses updated");
        getUser();
      }
    }catch (e){
      await _dialogService.showDialog(title: "Error", description: "Error updating adresses : ${e.toString()}");
    }
  }

  void updatePassword() async{
    DialogResponsePassword response = await _dialogService.showPasswordDialog(title: "Reset password");
    if(!response.confirmed)
      return;
    
    try{
      if(await _authentificationService.userPasswordReset(response.password, response.newPassword)){
        await _dialogService.showDialog(title: "Success", description: "Password updated");
        getUser();
      }
    }catch (e){
      await _dialogService.showDialog(title: "Error", description: "Error updating adresses : ${e.toString()}");
    }
  }

  updateDeliveryAddress() async{
    DialogResponse response = await _dialogService.showFieldsDialog(
      title: "Delivery", 
      field1: "Delivery adress", 
      field2: "Phone number",
      field3: "City",
      field4: "State",
      field5: "Zip / Postal Code",
      field6: "Country",
    );
    if(!response.confirmed)
      return;
    try{
      Map<String, String> body = {
        "deliveryAdress" : response.adress,  
        "deliveryMobileNumber" : response.phoneNumber,
        "deliveryCity" : response.city,
        "deliveryState" : response.state,
        "deliveryZipCode" : response.zipCode,
        "deliveryCountry" : response.country,
      };
      if(await _authentificationService.updateUser(body, null)){
        await _dialogService.showDialog(title: "Success", description: "Adresses updated");
        getUser();
      }
    }catch (e){
      await _dialogService.showDialog(title: "Error", description: "Error updating adresses : ${e.toString()}");
    }
  }
}