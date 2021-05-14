import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ecom/core/models/orderData.dart';

class UserData {
  int id;
  String username;
  String userPic;
  String email;
  int points;

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

  List<OrderData> orders;

  UserData({
    this.id,
    this.username,
    this.userPic,
    this.email,
    this.points = 0,
    this.billingAdress,
    this.deliveryAdress,
    this.deliveryCity,
    this.deliveryState,
    this.deliveryZipCode,
    this.deliveryCountry,
    this.billingMobileNumber = "",
    this.billingCity,
    this.billingState,
    this.billingZipCode,
    this.billingCountry,
    this.deliveryMobileNumber = "",
    this.orders,
  });

  UserData copyWith({
    int id,
    String username,
    String userPic,
    String email,
    int points,
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
    List<OrderData> orders,
  }) {
    return UserData(
      id: id ?? this.id,
      username: username ?? this.username,
      userPic: userPic ?? this.userPic,
      email: email ?? this.email,
      points: points ?? this.points,
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
      orders: orders ?? this.orders,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'userPic': userPic,
      'email': email,
      'points': points,
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
      'orders': orders?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UserData(
      id: map['id'],
      username: map['username'],
      userPic: map['userPic'],
      email: map['email'],
      points: map['points'],
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
      orders: map['orders'] != null ? List<OrderData>.from(map['orders']?.map((x) => OrderData.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) => UserData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserData(id: $id, username: $username, userPic: $userPic, email: $email, points: $points, billingAdress: $billingAdress, deliveryAdress: $deliveryAdress, deliveryCity: $deliveryCity, deliveryState: $deliveryState, deliveryZipCode: $deliveryZipCode, deliveryCountry: $deliveryCountry, billingMobileNumber: $billingMobileNumber, billingCity: $billingCity, billingState: $billingState, billingZipCode: $billingZipCode, billingCountry: $billingCountry, deliveryMobileNumber: $deliveryMobileNumber, orders: $orders)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UserData &&
      o.id == id &&
      o.username == username &&
      o.userPic == userPic &&
      o.email == email &&
      o.points == points &&
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
      o.deliveryMobileNumber == deliveryMobileNumber &&
      listEquals(o.orders, orders);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      username.hashCode ^
      userPic.hashCode ^
      email.hashCode ^
      points.hashCode ^
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
      deliveryMobileNumber.hashCode ^
      orders.hashCode;
  }
}
