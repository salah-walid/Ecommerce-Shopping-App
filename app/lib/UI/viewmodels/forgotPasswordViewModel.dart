import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/core/services/dialog_service.dart';
import 'package:ecom/core/services/navigation_service.dart';
import 'package:ecom/locator.dart';
import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends BaseModel {
  AuthentificationService _authentificationService = locator<AuthentificationService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  String email;
  String token;
  String password;

  final emailFormState = GlobalKey<FormState>();
  final tokenFormState = GlobalKey<FormState>();
  final passwordFormState = GlobalKey<FormState>();

  PageController pageController = PageController(initialPage: 0);

  void advanceForm() {
    if(pageController.page == 0)
      handleEmailForm();
    else if(pageController.page == 1)
      handleTokenForm();
    else if(pageController.page == 2)
      handlePasswordForm();
    else
      print("out of bounds");
  }

  void handleEmailForm() async{
    emailFormState.currentState.save();

    if(!emailFormState.currentState.validate())
      return;

    setState(ViewState.Busy);

    try{
      if(await _authentificationService.passwordReset({"email" : email}, "generateResetToken")){
        await _dialogService.showDialog(title: "Success", description: "An email has been sent to you, containing the code to reset your password");
        pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
      }
    }catch (e){
      await _dialogService.showDialog(title: "Error", description: e.toString());
    }

    setState(ViewState.Idle);
  }

  void handleTokenForm() async{
    tokenFormState.currentState.save();

    if(!tokenFormState.currentState.validate())
      return;

    setState(ViewState.Busy);

    try{
      if(await _authentificationService.passwordReset({"email" : email, "token" : token}, "checkResetToken")){
        await _dialogService.showDialog(title: "Success", description: "Your password reset token is valid");
        pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
      }
    }catch (e){
      await _dialogService.showDialog(title: "Error", description: e.toString());
    }

    setState(ViewState.Idle);
  }

  void handlePasswordForm() async{
    passwordFormState.currentState.save();

    if(!passwordFormState.currentState.validate())
      return;

    setState(ViewState.Busy);

    try{
      if(await _authentificationService.passwordReset({"email" : email, "token" : token, "password" : password}, "updatePassWord")){
        await _dialogService.showDialog(title: "Success", description: "Your password has been changed successfully");
        _navigationService.pop();
      }
    }catch (e){
      await _dialogService.showDialog(title: "Error", description: e.toString());
    }

    setState(ViewState.Idle);
  }
}