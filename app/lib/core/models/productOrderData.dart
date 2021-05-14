import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ecom/core/models/VariationsOptions.dart';
import 'package:ecom/core/models/productData.dart';
import 'package:ecom/core/models/uomData.dart';

class ProductOrderData {

  int id;
  ProductData product;

  int chosenSubProduct;
  UomData uom;
  List<VariationOptions> chosenVariations;

  double price;
  double unitPrice;
  int quantity;
  bool reviewed;
  bool isRedeemed;

  ProductOrderData({
    this.id,
    this.product,
    this.chosenSubProduct = 0,
    this.uom,
    this.chosenVariations,
    this.price = 0.0,
    this.unitPrice = 0.0,
    this.quantity = 1,
    this.reviewed = false,
    this.isRedeemed = false,
  });

  ProductOrderData copyWith({
    int id,
    ProductData product,
    int chosenSubProduct,
    UomData uom,
    List<VariationOptions> chosenVariations,
    double price,
    double unitPrice,
    int quantity,
    bool reviewed,
    bool isRedeemed,
  }) {
    return ProductOrderData(
      id: id ?? this.id,
      product: product ?? this.product,
      chosenSubProduct: chosenSubProduct ?? this.chosenSubProduct,
      uom: uom ?? this.uom,
      chosenVariations: chosenVariations ?? this.chosenVariations,
      price: price ?? this.price,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      reviewed: reviewed ?? this.reviewed,
      isRedeemed: isRedeemed ?? this.isRedeemed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product?.toMap(),
      'chosenSubProduct': chosenSubProduct,
      'uom': uom?.toMap(),
      'chosenVariations': chosenVariations?.map((x) => x?.toMap())?.toList(),
      'price': price,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'reviewed': reviewed,
      'isRedeemed': isRedeemed,
    };
  }

  factory ProductOrderData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ProductOrderData(
      id: map['id'],
      product: ProductData.fromMap(map['product']),
      chosenSubProduct: map['chosenSubProduct'],
      uom: UomData.fromMap(map['uom']),
      chosenVariations: List<VariationOptions>.from(map['chosenVariations']?.map((x) => VariationOptions.fromMap(x))),
      price: map['price'],
      unitPrice: map['unitPrice'],
      quantity: map['quantity'],
      reviewed: map['reviewed'],
      isRedeemed: map['isRedeemed'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductOrderData.fromJson(String source) => ProductOrderData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductOrderData(id: $id, product: $product, chosenSubProduct: $chosenSubProduct, uom: $uom, chosenVariations: $chosenVariations, price: $price, unitPrice: $unitPrice, quantity: $quantity, reviewed: $reviewed, isRedeemed: $isRedeemed)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ProductOrderData &&
      o.id == id &&
      o.product == product &&
      o.chosenSubProduct == chosenSubProduct &&
      o.uom == uom &&
      listEquals(o.chosenVariations, chosenVariations) &&
      o.price == price &&
      o.unitPrice == unitPrice &&
      o.quantity == quantity &&
      o.reviewed == reviewed &&
      o.isRedeemed == isRedeemed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      product.hashCode ^
      chosenSubProduct.hashCode ^
      uom.hashCode ^
      chosenVariations.hashCode ^
      price.hashCode ^
      unitPrice.hashCode ^
      quantity.hashCode ^
      reviewed.hashCode ^
      isRedeemed.hashCode;
  }
}
