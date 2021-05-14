import 'dart:io';

import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/models/userData.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/core/services/dialog_service.dart';
import 'package:ecom/core/services/navigation_service.dart';
import 'package:ecom/locator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class RegisterViewModel extends BaseModel {
  AuthentificationService _authentificationService = locator<AuthentificationService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  UserData user = UserData();
  File image;
  String password;

  bool termsAccepted = false;

  final formState = GlobalKey<FormState>();

  final TextEditingController billingCityC = TextEditingController();
  final TextEditingController billingStateC = TextEditingController();
  final TextEditingController billingZipCodeC = TextEditingController();

  final TextEditingController deliveryCityC = TextEditingController();
  final TextEditingController deliveryStateC = TextEditingController();
  final TextEditingController deliveryZipCodeC = TextEditingController();

  void loadImage() async{
    // ignore: deprecated_member_use
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  void register() async{

    if(state == ViewState.Busy)
      return;

    if(!termsAccepted){
      await _dialogService.showDialog(title: "Terms and services", description: "please accept terms and conditions");
      return;
    }

    formState.currentState.save();

    if(!formState.currentState.validate())
      return;

    setState(ViewState.Busy);

    Map<String, dynamic> mapUser = user.toMap();
    mapUser["password"] = password;
    mapUser.remove('id');
    mapUser.remove('userPic');
    mapUser.remove('orders');


    try{
      String token = await _authentificationService.postUser(mapUser, image);
      //await _dialogService.showDialog(title: "Success", description: "Account created successfully, check your email for the confirmation link");
      await _dialogService.showDialog(title: "Success", description: "Account created successfully");
      _navigationService.navigateTo(RoutesManager.phoneVerification, arguments: token);
    }catch (e){
      await _dialogService.showDialog(title: "Error", description: e.toString());
    }

    setState(ViewState.Idle);
  }

  billingAdresseSubmited(String value) async{
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

  void changeTermsAccepted(bool value) {
    termsAccepted = value;
    notifyListeners();
  }
}