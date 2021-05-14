import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:ecom/core/models/productOrderData.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/core/services/dialog_service.dart';
import 'package:ecom/core/services/orderService.dart';
import 'package:ecom/locator.dart';

class ProductCardViewModel extends BaseModel {
  
  OrderService _orderService = locator<OrderService>();
  DialogService _dialogService = locator<DialogService>();
  AuthentificationService _authentificationService = locator<AuthentificationService>();

  void addToWishList(ProductData productData) {
    if(_authentificationService.isConnected)
      _orderService.addItemToWishList(productData);
    else
      _dialogService.showDialog(title: "Error", description: "Please login before adding products to the cart");
  }

  void addToCart(ProductData productData, bool forRedeeming) {
    if(_authentificationService.isConnected){

      ProductOrderData order = ProductOrderData(
        chosenSubProduct: 0,
        product: productData,
        price: forRedeeming ? 0.0 : productData.priceWithDiscount * productData.uoms[0].value,
        unitPrice: productData.priceWithDiscount,
        quantity: 1,
        isRedeemed: forRedeeming,
        chosenVariations: [],
        uom: productData.uoms[0],
      );
      _orderService.addItemToOrder(order);

    }else{
      _dialogService.showDialog(title: "Error", description: "Please login before adding products to the cart");
    }
  }
}