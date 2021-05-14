import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ecom/core/models/productData.dart';
import 'package:ecom/core/models/subCategoryData.dart';

class CategoryData {
  int id;
  String title;
  String image;
  List<SubCategoryData> subCategories;
  List<ProductData> topSales;
  List<ProductData> products;
  
  CategoryData({
    this.id,
    this.title,
    this.image,
    this.subCategories,
    this.topSales,
    this.products,
  });

  CategoryData copyWith({
    int id,
    String title,
    String image,
    List<SubCategoryData> subCategories,
    List<ProductData> topSales,
    List<ProductData> products,
  }) {
    return CategoryData(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      subCategories: subCategories ?? this.subCategories,
      topSales: topSales ?? this.topSales,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'subCategories': subCategories?.map((x) => x?.toMap())?.toList(),
      'topSales': topSales?.map((x) => x?.toMap())?.toList(),
      'products': products?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory CategoryData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CategoryData(
      id: map['id'],
      title: map['title'],
      image: map['image'],
      subCategories: List<SubCategoryData>.from(map['subCategories']?.map((x) => SubCategoryData.fromMap(x))),
      topSales: List<ProductData>.from(map['topSales']?.map((x) => ProductData.fromMap(x))),
      products: List<ProductData>.from(map['products']?.map((x) => ProductData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryData.fromJson(String source) => CategoryData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryData(id: $id, title: $title, image: $image, subCategories: $subCategories, topSales: $topSales, products: $products)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is CategoryData &&
      o.id == id &&
      o.title == title &&
      o.image == image &&
      listEquals(o.subCategories, subCategories) &&
      listEquals(o.topSales, topSales) &&
      listEquals(o.products, products);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      image.hashCode ^
      subCategories.hashCode ^
      topSales.hashCode ^
      products.hashCode;
  }
}
