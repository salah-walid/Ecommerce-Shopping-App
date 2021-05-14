import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/models/failure.dart';
import 'package:ecom/core/services/apiService.dart';
import 'package:ecom/locator.dart';
import 'package:dartz/dartz.dart';

class TermsAndConditionsViewModel extends BaseModel {

  ApiService _apiService = locator<ApiService>();

  Either<Failure, dynamic> terms;

  void init() async{
    setState(ViewState.Busy);
    
    await Task(
      () => _apiService.getSetting("terms"),
    )
      .attempt()
      .mapLeftToFailure()
      .run()
      .then((value) => terms = value);
    
    setState(ViewState.Idle);
  }
  
}