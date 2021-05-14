import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ecom/core/models/Variations.dart';
import 'package:ecom/core/models/imagesData.dart';
import 'package:ecom/core/models/reviewData.dart';
import 'package:ecom/core/models/uomData.dart';

class ProductData {
  int id;
  String title;
  List<ImageData> images;
  double price;
  double discount;
  int quantity;
  double priceWithDiscount;
  int stars;
  int reviewsCount;
  String description;
  bool newProduct;
  int redeemPoints;

  List<UomData> uoms;
  List<Variations> variations; 

  List<ReviewData> reviewList;

  ProductData({
    this.id,
    this.title,
    this.images,
    this.price,
    this.discount,
    this.quantity,
    this.priceWithDiscount,
    this.stars,
    this.reviewsCount,
    this.description,
    this.newProduct,
    this.redeemPoints,
    this.uoms,
    this.variations,
    this.reviewList,
  });

  ProductData copyWith({
    int id,
    String title,
    List<ImageData> images,
    double price,
    double discount,
    int quantity,
    double priceWithDiscount,
    int stars,
    int reviewsCount,
    String description,
    bool newProduct,
    int redeemPoints,
    List<UomData> uoms,
    List<Variations> variations,
    List<ReviewData> reviewList,
  }) {
    return ProductData(
      id: id ?? this.id,
      title: title ?? this.title,
      images: images ?? this.images,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      quantity: quantity ?? this.quantity,
      priceWithDiscount: priceWithDiscount ?? this.priceWithDiscount,
      stars: stars ?? this.stars,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      description: description ?? this.description,
      newProduct: newProduct ?? this.newProduct,
      redeemPoints: redeemPoints ?? this.redeemPoints,
      uoms: uoms ?? this.uoms,
      variations: variations ?? this.variations,
      reviewList: reviewList ?? this.reviewList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'images': images?.map((x) => x?.toMap())?.toList(),
      'price': price,
      'discount': discount,
      'quantity': quantity,
      'priceWithDiscount': priceWithDiscount,
      'stars': stars,
      'reviewsCount': reviewsCount,
      'description': description,
      'newProduct': newProduct,
      'redeemPoints': redeemPoints,
      'uoms': uoms?.map((x) => x?.toMap())?.toList(),
      'variations': variations?.map((x) => x?.toMap())?.toList(),
      'reviewList': reviewList?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory ProductData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ProductData(
      id: map['id'],
      title: map['title'],
      images: List<ImageData>.from(map['images']?.map((x) => ImageData.fromMap(x))),
      price: map['price'],
      discount: map['discount'],
      quantity: map['quantity'],
      priceWithDiscount: map['priceWithDiscount'],
      stars: map['stars'],
      reviewsCount: map['reviewsCount'],
      description: map['description'],
      newProduct: map['newProduct'],
      redeemPoints: map['redeemPoints'],
      uoms: List<UomData>.from(map['uoms']?.map((x) => UomData.fromMap(x))),
      variations: List<Variations>.from(map['variations']?.map((x) => Variations.fromMap(x))),
      reviewList: List<ReviewData>.from(map['reviewList']?.map((x) => ReviewData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductData.fromJson(String source) => ProductData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductData(id: $id, title: $title, images: $images, price: $price, discount: $discount, quantity: $quantity, priceWithDiscount: $priceWithDiscount, stars: $stars, reviewsCount: $reviewsCount, description: $description, newProduct: $newProduct, redeemPoints: $redeemPoints, uoms: $uoms, variations: $variations, reviewList: $reviewList)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ProductData &&
      o.id == id &&
      o.title == title &&
      listEquals(o.images, images) &&
      o.price == price &&
      o.discount == discount &&
      o.quantity == quantity &&
      o.priceWithDiscount == priceWithDiscount &&
      o.stars == stars &&
      o.reviewsCount == reviewsCount &&
      o.description == description &&
      o.newProduct == newProduct &&
      o.redeemPoints == redeemPoints &&
      listEquals(o.uoms, uoms) &&
      listEquals(o.variations, variations) &&
      listEquals(o.reviewList, reviewList);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      images.hashCode ^
      price.hashCode ^
      discount.hashCode ^
      quantity.hashCode ^
      priceWithDiscount.hashCode ^
      stars.hashCode ^
      reviewsCount.hashCode ^
      description.hashCode ^
      newProduct.hashCode ^
      redeemPoints.hashCode ^
      uoms.hashCode ^
      variations.hashCode ^
      reviewList.hashCode;
  }
}
