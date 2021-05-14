import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ecom/core/models/orderState.dart';
import 'package:ecom/core/models/productOrderData.dart';

class OrderData {
  int id;
  int user;
  List<ProductOrderData> orderList;
  String promoCode;
  bool sameDayDelivery;
  DateTime creationDate;
  OrderState orderState;
  String refundId;
  
  double subTotal;
  double promo;
  double shipping;
  double estimatedTax;
  double total;

  String billingAdress;
  String deliveryAdress;

  String deliveryCity;
  String deliveryState;
  String deliveryZipCode;
  String deliveryCountry;
  String billingMobileNumber;

  String billingCity;
  String billingState;
  String billingZipCode;
  String billingCountry;
  String deliveryMobileNumber;
  
  OrderData({
    this.id,
    this.user = 0,
    this.orderList,
    this.promoCode = "",
    this.sameDayDelivery =false,
    this.creationDate,
    this.orderState = OrderState.accepted,
    this.refundId = "",
    this.subTotal = 0,
    this.promo = 0,
    this.shipping = 0,
    this.estimatedTax = 0,
    this.total = 0,
    this.billingAdress = "",
    this.deliveryAdress = "",
    this.deliveryCity = "",
    this.deliveryState = "",
    this.deliveryZipCode = "",
    this.deliveryCountry = "",
    this.billingMobileNumber = "",
    this.billingCity = "",
    this.billingState = "",
    this.billingZipCode = "",
    this.billingCountry = "",
    this.deliveryMobileNumber = "",
  });

  OrderData copyWith({
    int id,
    int user,
    List<ProductOrderData> orderList,
    String promoCode,
    bool sameDayDelivery,
    DateTime creationDate,
    OrderState orderState,
    String refundId,
    double subTotal,
    double promo,
    double shipping,
    double estimatedTax,
    double total,
    String billingAdress,
    String deliveryAdress,
    String deliveryCity,
    String deliveryState,
    String deliveryZipCode,
    String deliveryCountry,
    String billingMobileNumber,
    String billingCity,
    String billingState,
    String billingZipCode,
    String billingCountry,
    String deliveryMobileNumber,
  }) {
    return OrderData(
      id: id ?? this.id,
      user: user ?? this.user,
      orderList: orderList ?? this.orderList,
      promoCode: promoCode ?? this.promoCode,
      sameDayDelivery: sameDayDelivery ?? this.sameDayDelivery,
      creationDate: creationDate ?? this.creationDate,
      orderState: orderState ?? this.orderState,
      refundId: refundId ?? this.refundId,
      subTotal: subTotal ?? this.subTotal,
      promo: promo ?? this.promo,
      shipping: shipping ?? this.shipping,
      estimatedTax: estimatedTax ?? this.estimatedTax,
      total: total ?? this.total,
      billingAdress: billingAdress ?? this.billingAdress,
      deliveryAdress: deliveryAdress ?? this.deliveryAdress,
      deliveryCity: deliveryCity ?? this.deliveryCity,
      deliveryState: deliveryState ?? this.deliveryState,
      deliveryZipCode: deliveryZipCode ?? this.deliveryZipCode,
      deliveryCountry: deliveryCountry ?? this.deliveryCountry,
      billingMobileNumber: billingMobileNumber ?? this.billingMobileNumber,
      billingCity: billingCity ?? this.billingCity,
      billingState: billingState ?? this.billingState,
      billingZipCode: billingZipCode ?? this.billingZipCode,
      billingCountry: billingCountry ?? this.billingCountry,
      deliveryMobileNumber: deliveryMobileNumber ?? this.deliveryMobileNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'orderList': orderList?.map((x) => x?.toMap())?.toList(),
      'promoCode': promoCode,
      'sameDayDelivery': sameDayDelivery,
      'orderState': orderState?.value,
      'refundId': refundId,
      'subTotal': subTotal,
      'promo': promo,
      'shipping': shipping,
      'estimatedTax': estimatedTax,
      'total': total,
      'billingAdress': billingAdress,
      'deliveryAdress': deliveryAdress,
      'deliveryCity': deliveryCity,
      'deliveryState': deliveryState,
      'deliveryZipCode': deliveryZipCode,
      'deliveryCountry': deliveryCountry,
      'billingMobileNumber': billingMobileNumber,
      'billingCity': billingCity,
      'billingState': billingState,
      'billingZipCode': billingZipCode,
      'billingCountry': billingCountry,
      'deliveryMobileNumber': deliveryMobileNumber,
    };
  }

  factory OrderData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return OrderData(
      id: map['id'],
      user: map['user'],
      orderList: List<ProductOrderData>.from(map['orderList']?.map((x) => ProductOrderData.fromMap(x))),
      promoCode: map['promoCode'],
      sameDayDelivery: map['sameDayDelivery'],
      creationDate: map['creationDate'] != null ? DateTime.parse(map['creationDate']) : null,
      orderState: OrderStateExtension.fromValue(map['orderState']),
      refundId: map['refundId'],
      subTotal: map['subTotal'],
      promo: map['promo'],
      shipping: map['shipping'],
      estimatedTax: map['estimatedTax'],
      total: map['total'],
      billingAdress: map['billingAdress'],
      deliveryAdress: map['deliveryAdress'],
      deliveryCity: map['deliveryCity'],
      deliveryState: map['deliveryState'],
      deliveryZipCode: map['deliveryZipCode'],
      deliveryCountry: map['deliveryCountry'],
      billingMobileNumber: map['billingMobileNumber'],
      billingCity: map['billingCity'],
      billingState: map['billingState'],
      billingZipCode: map['billingZipCode'],
      billingCountry: map['billingCountry'],
      deliveryMobileNumber: map['deliveryMobileNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderData.fromJson(String source) => OrderData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderData(id: $id, user: $user, orderList: $orderList, promoCode: $promoCode, sameDayDelivery: $sameDayDelivery, creationDate: $creationDate, orderState: $orderState, refundId: $refundId, subTotal: $subTotal, promo: $promo, shipping: $shipping, estimatedTax: $estimatedTax, total: $total, billingAdress: $billingAdress, deliveryAdress: $deliveryAdress, deliveryCity: $deliveryCity, deliveryState: $deliveryState, deliveryZipCode: $deliveryZipCode, deliveryCountry: $deliveryCountry, billingMobileNumber: $billingMobileNumber, billingCity: $billingCity, billingState: $billingState, billingZipCode: $billingZipCode, billingCountry: $billingCountry, deliveryMobileNumber: $deliveryMobileNumber)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is OrderData &&
      o.id == id &&
      o.user == user &&
      listEquals(o.orderList, orderList) &&
      o.promoCode == promoCode &&
      o.sameDayDelivery == sameDayDelivery &&
      o.creationDate == creationDate &&
      o.orderState == orderState &&
      o.refundId == refundId &&
      o.subTotal == subTotal &&
      o.promo == promo &&
      o.shipping == shipping &&
      o.estimatedTax == estimatedTax &&
      o.total == total &&
      o.billingAdress == billingAdress &&
      o.deliveryAdress == deliveryAdress &&
      o.deliveryCity == deliveryCity &&
      o.deliveryState == deliveryState &&
      o.deliveryZipCode == deliveryZipCode &&
      o.deliveryCountry == deliveryCountry &&
      o.billingMobileNumber == billingMobileNumber &&
      o.billingCity == billingCity &&
      o.billingState == billingState &&
      o.billingZipCode == billingZipCode &&
      o.billingCountry == billingCountry &&
      o.deliveryMobileNumber == deliveryMobileNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user.hashCode ^
      orderList.hashCode ^
      promoCode.hashCode ^
      sameDayDelivery.hashCode ^
      creationDate.hashCode ^
      orderState.hashCode ^
      refundId.hashCode ^
      subTotal.hashCode ^
      promo.hashCode ^
      shipping.hashCode ^
      estimatedTax.hashCode ^
      total.hashCode ^
      billingAdress.hashCode ^
      deliveryAdress.hashCode ^
      deliveryCity.hashCode ^
      deliveryState.hashCode ^
      deliveryZipCode.hashCode ^
      deliveryCountry.hashCode ^
      billingMobileNumber.hashCode ^
      billingCity.hashCode ^
      billingState.hashCode ^
      billingZipCode.hashCode ^
      billingCountry.hashCode ^
      deliveryMobileNumber.hashCode;
  }
}
