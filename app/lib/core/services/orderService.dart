import 'package:ecom/core/models/orderData.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:ecom/core/models/productOrderData.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/core/services/dialog_service.dart';
import 'package:ecom/core/services/localDatabaseService.dart';
import 'package:ecom/locator.dart';

class OrderService {
  LocalDatabaseService _localDatabaseService = locator<LocalDatabaseService>();
  DialogService _dialogService = locator<DialogService>();
  AuthentificationService _authentificationService = locator<AuthentificationService>();

  OrderData _cartData;
  OrderData get cartData => _cartData;

  List<ProductData> _wishList;
  List<ProductData> get wishList => _wishList;

  List<OrderData> _userOrders;
  List<OrderData> get userOrders => _userOrders;

  bool checkIfRedeemExceed(ProductOrderData product){
    int points = 0;
    for(ProductOrderData orderData in _cartData.orderList){
      if(orderData.isRedeemed)
        points += orderData.product.redeemPoints * orderData.quantity * orderData.uom.value;
    }
    
    points += product.product.redeemPoints;

    return points > _authentificationService.user.points;
  }

  void loadData(){
    _cartData = _localDatabaseService.getCart();
    if(_cartData.orderList == null)
      _cartData.orderList = List<ProductOrderData>();
    
    _wishList = _localDatabaseService.getWishList();
    if(_wishList == null)
      _wishList = List<ProductData>();
  }

  //! cart order
  void changeCart(Function(OrderData) action) {
    action(_cartData);
    _localDatabaseService.setCart(_cartData);
  }

  void resetCart(){
    _cartData = OrderData();
    _cartData.orderList = List<ProductOrderData>();
    _localDatabaseService.setCart(_cartData);

    _wishList = List<ProductData>();
    _localDatabaseService.setWishList(_wishList);
  }
  
  void addItemToOrder(ProductOrderData product){

    //! for redeemed products
    if(product.isRedeemed && checkIfRedeemExceed(product)){
      _dialogService.showDialog(title: "Cart", description: "Not enough points to redeem this product");
      return;
    }

    //! check if available
    if(product.product.quantity < product.quantity){
      _dialogService.showDialog(title: "Cart", description: "Product is not available");
      return;
    }

    //! check if already in cart
    if(_cartData.orderList.indexWhere((element) {
      return element.product.id == product.product.id && element.uom.id == product.uom.id;
    }) == -1){
      _cartData.orderList.add(product.copyWith());
      _localDatabaseService.setCart(_cartData);
      _dialogService.showDialog(title: "Cart", description: "Item added to cart");
    }else
      _dialogService.showDialog(title: "Cart", description: "Item already in cart");

  }

  void updateCartProduct(int index, ProductOrderData productOrderData){
    if(_cartData.orderList[index] != productOrderData){
      _cartData.orderList[index] = productOrderData;
      _localDatabaseService.setCart(_cartData);
    }
  }

  //!wish list
 
  void addItemToWishList(ProductData product){
    if(!_wishList.contains(product)){
      _wishList.add(product);
      _localDatabaseService.setWishList(_wishList);
      _dialogService.showDialog(title: "Wish list", description: "Wish list item added");
    }
  }

  void removeItemFromWishList(ProductData product){
    _wishList.remove(product);
    _localDatabaseService.setWishList(_wishList);
  }

}