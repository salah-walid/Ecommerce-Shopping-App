import 'dart:convert';
import 'dart:io';

import 'package:ecom/core/models/orderData.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabaseService {
  Directory appDocumentDirectory;
  final String cartTable = "cart";
  final String wishListTable = "wishList";
  final String tokenTable = "token";
  
  Box _appBox;

  Future initDB() async{
    await Hive.initFlutter();
    
    _appBox = await Hive.openBox("app");

  }

  OrderData getCart(){
    String body = _appBox.get(cartTable) as String;
    if(body != null)
      return OrderData.fromJson(body);
    return OrderData();
  }

  List<ProductData> getWishList(){
    String body = _appBox.get(wishListTable) as String;
    if(body != null){
      List<ProductData> list = List<ProductData>();
      for (var item in json.decode(body))
        list.add(ProductData.fromMap(item));
      return list;
    }
    return List<ProductData>();
  }

  String getAuthToken(){
    return _appBox.get(tokenTable) as String;
  }

  void setCart(OrderData cart) async{
    await _appBox.put(cartTable, cart.toJson());
  }

  void setWishList(List<ProductData> wishList) async{
    var wishes = wishList?.map((x) => x?.toMap())?.toList();

    await _appBox.put(wishListTable, json.encode(wishes));
  }

  void setAuthToken(String token) async{
    await _appBox.put(tokenTable, token);
  }

  void resetUser() {
    _appBox.delete(tokenTable);
  }
}