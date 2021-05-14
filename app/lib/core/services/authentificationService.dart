import 'dart:convert';
import 'dart:io';

import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/core/models/failure.dart';
import 'package:ecom/core/models/userData.dart';
import 'package:ecom/core/models/userState.dart';
import 'package:ecom/core/services/apiService.dart';
import 'package:ecom/core/services/localDatabaseService.dart';
import 'package:ecom/core/services/navigation_service.dart';
import 'package:ecom/locator.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as mime;

class AuthentificationService {

  LocalDatabaseService _localDatabaseService = locator<LocalDatabaseService>();
  NavigationService _navigationService = locator<NavigationService>();

  UserData _user;
  String _token;

  UserData get user => _user;
  // ignore: unnecessary_getters_setters
  String get token => _token;

  // ignore: unnecessary_getters_setters
  set token(String t) => _token = t;

  bool get isConnected{
    if(_token == null){
      String localToken = _localDatabaseService.getAuthToken();
      if(localToken != null){
        _token = localToken;
        return true;
      }
      return false;
    }
    return true;
  }

  Future<UserData> getUser() async{
    try{

      http.Response result = await ApiService.client.get(
        "${ApiService.endpoint}/settings/getUser",
        headers: {
          "Authorization" : "TOKEN $_token",
        }
      );

      ApiService.handleHttpErrors(result.statusCode);

      var body = json.decode(utf8.decode(result.bodyBytes));

      _user = UserData.fromMap(body);

      return _user;

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

  Future<bool> connect(String auth, String password) async{
    try{

      http.Response result = await ApiService.client.post(
        "${ApiService.endpoint}/settings/auth",
        body: {
          "auth": auth,
          "password" : password,
        }
      );

      var body = json.decode(utf8.decode(result.bodyBytes));
      
      if(result.statusCode != HttpStatus.ok){
        UserState userState = UserStateExtention.fromValue(body["status"]);
        switch(userState){
          
          case UserState.needActivation:
            _navigationService.navigateTo(RoutesManager.phoneVerification, arguments: body["token"]);
            throw Failure("Need phone verification");
            break;
          case UserState.userOrPasswordDoesNotExist:
            throw Failure("Username or password not correct");
            break;
          case UserState.wrongData:
            throw Failure("Wrong http data");
            break;
          default:
            return false;
            break;
        }
      }else{
        _token = body["token"];
        _user = UserData.fromMap(body["user"]);
        _localDatabaseService.setAuthToken(_token);
      }

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

  Future<String> postUser(Map<String, dynamic> user, File image) async{
    try{
      var request = http.MultipartRequest('POST', Uri.parse("${ApiService.endpoint}/settings/registerUser"));

      if(image != null)  
        request.files.add(
          http.MultipartFile(
            'userPic',
            image.readAsBytes().asStream(),
            image.lengthSync(),
            filename: image.path.split("/").last,
            contentType: mime.MediaType("image", image.path.split(".").last),
          )
        );
      
      user.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      http.StreamedResponse result = await request.send();
      var body = json.decode(await result.stream.bytesToString());

      if(result.statusCode != HttpStatus.created)
        throw Failure("Coudn't register the account, email or username already exists");
      else
        return body["token"];

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

  Future<bool> passwordReset(Map<String, String> body, String url) async{
    try{
      http.Response result = await ApiService.client.post(
        "${ApiService.endpoint}/settings/$url",
        body: body
      );

      ApiService.handleHttpErrors(result.statusCode);

      return result.statusCode == HttpStatus.ok;

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

  Future<bool> userPasswordReset(String password, String newPassword) async{
    try{
      http.Response result = await ApiService.client.post(
        "${ApiService.endpoint}/settings/updateUserPassword",
        body: {
          "password": password,
          "newPassword": newPassword
        },
        headers: {
          "Authorization" : "TOKEN $_token",
        }
      );

      ApiService.handleHttpErrors(result.statusCode);

      return result.statusCode == HttpStatus.ok;

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

  Future<bool> updateUser(Map<String, String> user, File image) async{
    try{
      var request = http.MultipartRequest('PATCH', Uri.parse("${ApiService.endpoint}/settings/updateUser"));

      request.headers.addAll({"Authorization" : "TOKEN $_token",});

      if(image != null)  
        request.files.add(
          http.MultipartFile(
            'userPic',
            image.readAsBytes().asStream(),
            image.lengthSync(),
            filename: image.path.split("/").last,
            contentType: mime.MediaType("image", image.path.split(".").last),
          )
        );
      
      user.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      http.StreamedResponse result = await request.send();

      ApiService.handleHttpErrors(result.statusCode);

      return result.statusCode == HttpStatus.ok;

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
  
  void logOut(){
    _user = null;
    _token = null;

    _localDatabaseService.resetUser();
  }
  
}