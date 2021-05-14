import 'dart:convert';
import 'dart:io';

import 'package:ecom/core/models/failure.dart';
import 'package:ecom/core/models/orderData.dart';
import 'package:ecom/core/models/productOrderData.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/locator.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ApiService {
  AuthentificationService _authentificationService = locator<AuthentificationService>();

  //! vedstore.pythonanywhere.com
  //! 10.0.2.2:8000
  static final String endpoint = "http://10.0.2.2:8000";
  //static final String endpoint = "http://192.168.110.148:8000/vedapiservice";
  static http.Client client = http.Client();
  

  Future<List<T>> getDatas<T>({@required String urlPath, @required T Function(dynamic) perItemCreation}) async{
    try{

      List<T> li = List<T>();
      http.Response result = await client.get(
        "$endpoint/$urlPath",
      );

      handleHttpErrors(result.statusCode);

      String body = utf8.decode(result.bodyBytes);
      for (var item in json.decode(body))
        li.add(perItemCreation(item));
      
      return li;

    }on Failure{
      rethrow;
    }on SocketException{
      throw Failure("No internet connection");
    }on FormatException{
      throw Failure("Bad response format");
    }on HttpException{
      throw Failure("Http error");
    }catch(e){
      throw Failure("Unknown error ${e.toString()}");
    }
  }

  Future<T> getData<T>({@required String urlPath, @required T Function(dynamic) itemCreation}) async{
    try{

      http.Response result = await client.get(
        "$endpoint/$urlPath",
      );

      handleHttpErrors(result.statusCode);

      String body = utf8.decode(result.bodyBytes);
      
      return itemCreation(body);

    }on Failure{
      rethrow;
    }on SocketException{
      throw Failure("No internet connection");
    }on FormatException{
      throw Failure("Bad response format");
    }on HttpException{
      throw Failure("Http error");
    }catch(e){
      throw Failure("Unknown error ${e.toString()}");
    }
  }

  Future<List<T>> getDatasWithAuth<T>({@required String urlPath, @required T Function(dynamic) perItemCreation}) async{ 
    try{

      List<T> li = List<T>();
      http.Response result = await client.get(
        "$endpoint/$urlPath",
        headers: {
          "Authorization" : "TOKEN ${_authentificationService.token}",
        }
      );

      handleHttpErrors(result.statusCode);

      String body = utf8.decode(result.bodyBytes);
      for (var item in json.decode(body))
        li.add(perItemCreation(item));
      
      return li;

    }on Failure{
      rethrow;
    }on SocketException{
      throw Failure("No internet connection");
    }on FormatException{
      throw Failure("Bad response format");
    }on HttpException{
      throw Failure("Http error");
    }catch(e){
      throw Failure("Unknown error ${e.toString()}");
    }
  }

  Future<double> getPromoCode(String code) async{
    try{
      http.Response result = await client.post(
        "$endpoint/backend/checkPromoCode",
        body: {
          "code": code
        }
      );

      if(result.statusCode == HttpStatus.ok){
        String body = utf8.decode(result.bodyBytes);
        return json.decode(body)["promo"];
      }else{
        return null;
      }

    }on Failure{
      rethrow;
    }on SocketException{
      throw Failure("No internet connection");
    }on FormatException{
      throw Failure("Bad response format");
    }on HttpException{
      throw Failure("Http error");
    }catch(e){
      throw Failure("Unknown error ${e.toString()}");
    }
  }

  Future<String> postOrder(dynamic order, String paymentId) async{
    try{
      http.Response result = await client.post(
        "$endpoint/backend/postOrders",
        headers: {
          "Authorization" : "TOKEN ${_authentificationService.token}",
          'Content-type': 'application/json',
        },
        body: jsonEncode({
          "order": order,
          "sid" : paymentId,
        })
      );

      handleHttpErrors(result.statusCode);

      return result.body;

    }on Failure{
      rethrow;
    }on SocketException{
      throw Failure("No internet connection");
    }on FormatException{
      throw Failure("Bad response format");
    }on HttpException{
      throw Failure("Http error");
    }catch(e){
      throw Failure("Unknown error ${e.toString()}");
    }
  }

  Future<Map> calculateOrderTotal(OrderData order) async{
    try{
      List listOrder = List();
      for (ProductOrderData productOrder in order.orderList){
        listOrder.add({
          "quantity" : productOrder.quantity,
          "product" : productOrder.product.id,
          "uom" : productOrder.uom.id,
          "isRedeemed" : productOrder.isRedeemed
        });
      }

      http.Response result = await client.post(
        "$endpoint/backend/orderCalculateTotal",
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonEncode({
          "listOrder": listOrder,
          "sameDayDelivery" : order.sameDayDelivery,
          "promo" : order.promoCode
        })
      );

      handleHttpErrors(result.statusCode);

      return jsonDecode(result.body);

    }on Failure{
      rethrow;
    }on SocketException{
      throw Failure("No internet connection");
    }on FormatException{
      throw Failure("Bad response format");
    }on HttpException{
      throw Failure("Http error");
    }catch(e){
      throw Failure("Unknown error ${e.toString()}");
    }
  }

  Future refundOrder(int orderId) async{
    try{
      http.Response result = await client.post(
        "$endpoint/backend/refund_order/$orderId",
        headers: {
          "Authorization" : "TOKEN ${_authentificationService.token}",
        },
      );

      handleHttpErrors(result.statusCode);

    }on Failure{
      rethrow;
    }on SocketException{
      throw Failure("No internet connection");
    }on FormatException{
      throw Failure("Bad response format");
    }on HttpException{
      throw Failure("Http error");
    }catch(e){
      throw Failure("Unknown error ${e.toString()}");
    }
  }

  Future<bool> postReview(Map review) async{
    try{

      http.Response result = await client.post(
        "$endpoint/backend/postReview",
        body: jsonEncode(review),
        headers: {
          "Authorization" : "TOKEN ${_authentificationService.token}",
          'Content-type': 'application/json',
        },
      );

      handleHttpErrors(result.statusCode);

      return result.statusCode == HttpStatus.created;

    }on Failure{
      rethrow;
    }on SocketException{
      throw Failure("No internet connection");
    }on FormatException{
      throw Failure("Bad response format");
    }on HttpException{
      throw Failure("Http error");
    }catch(e){
      throw Failure("Unknown error ${e.toString()}");
    }
  }

  Future markNotifAsRead(int notifId) async{
    try{

      http.Response result = await client.put(
        "$endpoint/settings/markNotifAsRead/$notifId",
        headers: {
          "Authorization" : "TOKEN ${_authentificationService.token}",
          'Content-type': 'application/json',
        },
      );

      handleHttpErrors(result.statusCode);

    }on Failure{
      rethrow;
    }on SocketException{
      throw Failure("No internet connection");
    }on FormatException{
      throw Failure("Bad response format");
    }on HttpException{
      throw Failure("Http error");
    }catch(e){
      throw Failure("Unknown error ${e.toString()}");
    }
  }

  Future deleteNotificcation(int notifId) async{
    try{

      http.Response result = await client.post(
        "$endpoint/settings/deleteNotification/$notifId",
        headers: {
          "Authorization" : "TOKEN ${_authentificationService.token}",
          'Content-type': 'application/json',
        },
      );

      handleHttpErrors(result.statusCode);

    }on Failure{
      rethrow;
    }on SocketException{
      throw Failure("No internet connection");
    }on FormatException{
      throw Failure("Bad response format");
    }on HttpException{
      throw Failure("Http error");
    }catch(e){
      throw Failure("Unknown error ${e.toString()}");
    }
  }

  Future<dynamic> getSetting(String settingName, {Map body=const {}}) async{
    try{

      http.Response result = await client.post(
        "$endpoint/settings/getSettings/$settingName",
        body: body
      );

      handleHttpErrors(result.statusCode);
      
      return jsonDecode(utf8.decode(result.bodyBytes));

    }on Failure{
      rethrow;
    }on SocketException{
      throw Failure("No internet connection");
    }on FormatException{
      throw Failure("Bad response format");
    }on HttpException{
      throw Failure("Http error");
    }catch(e){
      throw Failure("Unknown error ${e.toString()}");
    }
  }
  
  static void handleHttpErrors(int httpCode){

    switch(httpCode){

      case HttpStatus.ok:
        return;
      break;

      case HttpStatus.created:
        return;
      break;

      case HttpStatus.forbidden:
        throw Failure("Access denied");
      break;

      case HttpStatus.badRequest:
        throw Failure("Wrong data");
      break;

      default:
        throw Failure("Unknown http error : $httpCode");
      break;

    }

  }
}