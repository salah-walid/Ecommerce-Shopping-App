import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/models/Variations.dart';
import 'package:ecom/core/models/VariationsOptions.dart';
import 'package:ecom/core/models/failure.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:ecom/core/models/productOrderData.dart';
import 'package:ecom/core/models/uomData.dart';
import 'package:ecom/core/services/apiService.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/core/services/dialog_service.dart';
import 'package:ecom/core/services/orderService.dart';
import 'package:ecom/locator.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class ProductDetailViewModel extends BaseModel {
  OrderService _orderService = locator<OrderService>();
  ApiService _apiService = locator<ApiService>();
  AuthentificationService _authentificationService = locator<AuthentificationService>();
  DialogService _dialogService = locator<DialogService>();
  ScrollController _scrollController = ScrollController();
  int _chosenIndex = 0;
  int get chosenIndex => _chosenIndex;

  bool productAreLoading = true;
  int productId;
  Either<Failure, ProductData> product;

  bool reviewsOpen = false;
  ScrollController get scrollcontroller => _scrollController;
  ProductOrderData productOrder = ProductOrderData();
  double get total => productOrder.price;

  void init(int productId, bool isRedeemed) {
    this.productId = productId;
    productOrder.isRedeemed = isRedeemed;
    getProduct();
  }

  void toggleReview(GlobalKey key) {
    reviewsOpen = !reviewsOpen;
    double height = key.currentContext.size.height + 300;
    // print(height);
    if (reviewsOpen) {
      scrollcontroller.animateTo(height, duration: Duration(milliseconds: 900), curve: Curves.ease);
    }
    notifyListeners();
  }

  void setProduct(ProductData productData){
    productOrder.product = productData;
    productOrder.uom = productOrder.uom ?? productData.uoms[0];
    if(productOrder.chosenVariations == null){
      productOrder.chosenVariations = [];
      for(Variations variation in productData.variations)
        productOrder.chosenVariations.add(variation.options[0]);
    }
    productOrder.unitPrice = productData.priceWithDiscount;

    calculateTotal();
  }

  Future getProduct() async{
    
    productAreLoading = true;
    notifyListeners();
    
    await Task(
      () => _apiService.getData<ProductData>(
        urlPath: "backend/get_product/$productId", 
        itemCreation: (item) => ProductData.fromJson(item)
      )
    )
      .attempt()
      .mapLeftToFailure()
      .run()
      .then((value) => product = value);
    
    productAreLoading = false;
    notifyListeners();
  }

  void addItemToWishList(ProductData productData){
    if(_authentificationService.isConnected)
      _orderService.addItemToWishList(productData);
    else
      _dialogService.showDialog(title: "Error", description: "Please login before adding products to the cart");
  }

  void setChosenIndex(int i) {
    _chosenIndex = i;
    productOrder.chosenSubProduct = i;
    notifyListeners();
  }

  void addQuantity(int i) {
    productOrder.quantity += i;
    if(productOrder.quantity < 1)
      productOrder.quantity=1;
    calculateTotal();
    notifyListeners();
  }

  void calculateTotal(){
    productOrder.price = (
      productOrder.unitPrice * 
      productOrder.quantity *
      productOrder.uom.value
    );
  }

  addToCart() {
    if(_authentificationService.isConnected){
      if(productOrder.isRedeemed){
        productOrder.price = 0;
        productOrder.unitPrice = 0;
      }
      _orderService.addItemToOrder(productOrder);
    }else
      _dialogService.showDialog(title: "Error", description: "Please login before adding products to the cart");
  }

  /* void onAddReviewClicked() async{
    if(!_authentificationService.isConnected){
      await _dialogService.showDialog(title: "Error", description: "Please register before adding a review");
      return;
    }

    await _navigationService.navigateTo(RoutesManager.addReview, arguments: productOrder.product);
    getProduct();
  } */

  void uomChanged(UomData value) {
    productOrder.uom = value;
    calculateTotal();
    notifyListeners();
  }

  void variationChanged(VariationOptions value, int index) {
    productOrder.chosenVariations[index] = value;
    notifyListeners();
  }
}