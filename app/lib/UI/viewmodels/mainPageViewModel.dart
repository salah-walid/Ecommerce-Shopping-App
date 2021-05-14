import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/core/services/authentificationService.dart';
import 'package:ecom/core/services/notificationService.dart';
import 'package:ecom/locator.dart';
import 'package:flutter/material.dart';

class MainPageViewModel extends BaseModel{
  NotificationService _notificationService = locator<NotificationService>();
  AuthentificationService _authentificationService = locator<AuthentificationService>();

  bool get unreadNotifications => _notificationService.notifications?.where((element) => !element.isRead)?.isNotEmpty;
  bool get isConnected => _authentificationService.isConnected;
  String get userName =>_authentificationService.user.username;

  int _currentBottomNavigationIndex = 0;
  int get currentBottomNavigationIndex => _currentBottomNavigationIndex;

  PageController _bottomNavigationPageController = PageController(initialPage: 0);
  PageController get bottomNavigationPageController => _bottomNavigationPageController;

  void bottomNavigationChanged(int index) {
    _currentBottomNavigationIndex = index;
    _bottomNavigationPageController.animateToPage(_currentBottomNavigationIndex, duration: Duration(milliseconds: 300), curve: Curves.linear);
    _notificationService.getNotification();
    notifyListeners();
  }
}