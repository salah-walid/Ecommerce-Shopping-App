import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/core/services/dialog_service.dart';
import 'package:ecom/core/services/localDatabaseService.dart';
import 'package:ecom/core/services/navigation_service.dart';
import 'package:ecom/core/services/phoneVerificationService.dart';
import 'package:ecom/locator.dart';

class PhoneVerificationViewModel extends BaseModel {
  
  PhoneVerficationService _phoneVerficationService = locator<PhoneVerficationService>();
  AuthentificationService _authentificationService = locator<AuthentificationService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  LocalDatabaseService _localDatabaseService = locator<LocalDatabaseService>();

  String token;
  String code;

  void init(String token){
    this.token = token;
  }


  void otpChanged(String value) {
    print(value);
    code = value;
  }

  void verify() async{
    if(state == ViewState.Busy)
     return;

    setState(ViewState.Busy);

    try{
      if(await _phoneVerficationService.verifyPhone(code, token)){
        _dialogService.showDialog(title: "Success", description: "Acoount phone confirmed");
        _authentificationService.token = token;
        _localDatabaseService.setAuthToken(token);
        await _authentificationService.getUser();
        _navigationService.navigateToAndErasePrevious(RoutesManager.homePage);
      }
    }catch (e){
      await _dialogService.showDialog(title: "error", description: e.toString());
    }

    setState(ViewState.Idle);
  }

  void resendMessage() async{
    if(state == ViewState.Busy)
     return;

    setState(ViewState.Busy);

    try{
      if(await _phoneVerficationService.resendMessage(token)){
        _dialogService.showDialog(title: "Success", description: "Message resent");
      }
    }catch (e){
      await _dialogService.showDialog(title: "error", description: e.toString());
    }

    setState(ViewState.Idle);
  }
}