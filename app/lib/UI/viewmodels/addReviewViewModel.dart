import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/models/productOrderData.dart';
import 'package:ecom/core/models/reviewData.dart';
import 'package:ecom/core/services/apiService.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/core/services/dialog_service.dart';
import 'package:ecom/core/services/navigation_service.dart';
import 'package:ecom/locator.dart';
import 'package:flutter/material.dart';

class AddReviewViewModel extends BaseModel {
  ApiService _apiService = locator<ApiService>();
  AuthentificationService _authentificationService = locator<AuthentificationService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();

  ReviewData reviewData = ReviewData();
  ProductOrderData productData;

  final formState = GlobalKey<FormState>();

  void init(ProductOrderData p){
    productData = p;
    reviewData.user = _authentificationService.user;
  }

  void updateRating(double rating){
    reviewData.stars = rating.toInt();
    notifyListeners();
  }


  void submit() async{

    formState.currentState.save();
    if(!formState.currentState.validate())
      return;

    setState(ViewState.Busy);

    var review = reviewData.toMap();
    review.remove("user");
    review.remove("id");
    review["product"] = productData.product.id.toString();
    review["productOrder"] = productData.id.toString();

    try{
      if(await _apiService.postReview(review)){
        await _dialogService.showDialog(title: "Success", description: "Review submited");
        
        _navigationService.pop();
        _navigationService.pop();
        _navigationService.pop();
      }else{
        await _dialogService.showDialog(title: "Error", description: "Couldn't submit review");
      }
    }catch (e){
      await _dialogService.showDialog(title: "Error", description: "Error : ${e.toString()}");
    }

    setState(ViewState.Idle);
  }
}