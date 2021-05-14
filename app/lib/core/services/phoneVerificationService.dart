import 'dart:io';

import 'package:ecom/core/models/failure.dart';
import 'package:ecom/core/services/apiService.dart';
import 'package:http/http.dart' as http;


class PhoneVerficationService {

  Future<bool> verifyPhone(String phoneCode, String token) async{
    try{

      http.Response result = await ApiService.client.post(
        "${ApiService.endpoint}/settings/verifyPhoneNumber",
        body: {
          "mobileCode": phoneCode,
        },
        headers: {
          "Authorization" : "TOKEN $token",
        }
      );
      
      if(result.statusCode != HttpStatus.ok)
        throw Failure("Wrong verification code");

      return true;

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

  Future<bool> resendMessage(String token) async{
    try{

      http.Response result = await ApiService.client.post(
        "${ApiService.endpoint}/settings/resendPhoneActivation",
        headers: {
          "Authorization" : "TOKEN $token",
        }
      );
      
      if(result.statusCode != HttpStatus.ok)
        throw Failure("Couldn't send the verification code");

      return true;

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
}