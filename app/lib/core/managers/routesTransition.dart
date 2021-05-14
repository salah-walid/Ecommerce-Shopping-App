import 'package:ecom/core/managers/Routes.dart';
import 'package:flutter/material.dart';

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // if (route.settings.isInitialRoute) {
    //   return child;
    // }
    if(ModalRoute.of(context).settings.name == RoutesManager.imageFullScreen)
      return child;
    else
      return FadeTransition(
        opacity: animation,
        child: child,
      );
  }
}