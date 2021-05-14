import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/locator.dart';
import 'package:flutter/material.dart';

import 'core/managers/Routes.dart';
import 'core/managers/dialog_manager.dart';
import 'core/managers/routesTransition.dart';
import 'core/services/navigation_service.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This is the main widget who caintains all
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Out',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        secondaryHeaderColor: Colors.orange,
        primaryColor: SharedColors.defaultColor,
        buttonColor: Colors.amber[800],
        
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
            TargetPlatform.android: CustomPageTransitionBuilder(),
          }
        )
      ),

      navigatorKey: locator<NavigationService>().navigationKey,

      //dialog manager
      builder: (context, widget) => Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => DialogManager(
            child: widget,
          )),
      ),

      //routes
      initialRoute: RoutesManager.splashScreen,

      routes: RoutesManager.generateRoutes(),
    );
  }
}
