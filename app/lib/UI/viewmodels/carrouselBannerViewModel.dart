import 'dart:async';

import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/models/carrouselData.dart';
import 'package:ecom/core/models/failure.dart';
import 'package:ecom/core/services/apiService.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class CarrouselBannerViewModel extends BaseModel {

  ApiService _apiService = locator<ApiService>();

  bool carrouselsAreLoading =false;
  Either<Failure, List<CarrouselData>> carrousels;

  PageController _pageController;
  int pageCount = 0;

  PageController get pageController => _pageController;

  init() {
    _pageController = PageController(initialPage: 0);

    Timer.periodic(
      Duration(seconds: 4),
      animateToNextPage,
    );

    getCarrousels();

  }

  void getCarrousels() async{
    pageCount = 0;
    carrouselsAreLoading = true;
    notifyListeners();
    
    await Task(
      () => _apiService.getDatas<CarrouselData>(
        urlPath: "backend/getCarrouselPromo", 
        perItemCreation: (item) => CarrouselData.fromMap(item)
      )
    )
      .attempt()
      .mapLeftToFailure()
      .run()
      .then((value) => carrousels = value);
    
    carrouselsAreLoading = false;
    notifyListeners();
  }
      
  void animateToNextPage(Timer timer) {
    if(pageCount==0)
      return;
    if(_pageController.page != pageCount - 1)
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
    else
      _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.linear);
  }
}