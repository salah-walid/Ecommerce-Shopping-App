import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ecom/core/models/productData.dart';

class SubCategoryData {
  int id;
  String title;
  String image;
  List<ProductData> topSales;
  List<ProductData> products;
  
  SubCategoryData({
    this.id,
    this.title,
    this.image,
    this.topSales,
    this.products,
  });

  SubCategoryData copyWith({
    int id,
    String title,
    String image,
    List<ProductData> topSales,
    List<ProductData> products,
  }) {
    return SubCategoryData(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      topSales: topSales ?? this.topSales,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'topSales': topSales?.map((x) => x?.toMap())?.toList(),
      'products': products?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory SubCategoryData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SubCategoryData(
      id: map['id'],
      title: map['title'],
      image: map['image'],
      topSales: List<ProductData>.from(map['topSales']?.map((x) => ProductData.fromMap(x))),
      products: List<ProductData>.from(map['products']?.map((x) => ProductData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubCategoryData.fromJson(String source) => SubCategoryData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubCategoryData(id: $id, title: $title, image: $image, topSales: $topSales, products: $products)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is SubCategoryData &&
      o.id == id &&
      o.title == title &&
      o.image == image &&
      listEquals(o.topSales, topSales) &&
      listEquals(o.products, products);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      image.hashCode ^
      topSales.hashCode ^
      products.hashCode;
  }
}
