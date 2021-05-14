import 'package:ecom/UI/viewmodels/splashScreenViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:flutter/material.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashScreenViewModel>(
      viewModel: SplashScreenViewModel(),
      onModelReady: (model) => model.initApp(),
      builder: (context, model, _) => SafeArea(
        child: Scaffold(
          body: Container(
            color: SharedColors.defaultColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //logo
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 45),
                    child: Image(
                      image: AssetImage("assets/images/ecom splash.png"),
                      width: 220,
                    ),
                  ),

                  RichText(
                    text: TextSpan(
                      text: "All what you need shopping place",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
