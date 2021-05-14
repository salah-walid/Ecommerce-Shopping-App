import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:flutter/material.dart';

class StartMenu extends StatelessWidget {
  const StartMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 30, left: 30, right: 30),
            child: Container(
              height: MediaQuery.of(context).size.height * .45,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/ecom splash.png"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),

          Text(
            "Get the best deals right here!",
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 30, 
              fontWeight: FontWeight.w400, 
              color: Colors.grey[800]
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    onPressed: () => Navigator.pushNamed(context, RoutesManager.register),
                    child: Text(
                      "Register",
                      style: TextStyle(fontFamily: 'Raleway',color: Colors.white),
                    ),
                    color: SharedColors.defaultColor,
                    shape: StadiumBorder(),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: OutlineButton(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesManager.login);
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(fontFamily: 'Raleway',color: SharedColors.defaultColor),
                    ),
                    borderSide: BorderSide(color: SharedColors.defaultColor),
                    shape: StadiumBorder(),
                  ),
                ),
              ],
            ),
          ),
          
          
        ],
      ),
    );
  

  }
}