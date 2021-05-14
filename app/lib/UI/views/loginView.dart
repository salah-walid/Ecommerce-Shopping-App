import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/UI/viewmodels/loginViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      viewModel: LoginViewModel(),
      builder: (context, model, _) => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.brown,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.white,
            title: Text(
              "Login",
              style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade800),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: model.formKey,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        "assets/images/login-splash.png",
                        height: MediaQuery.of(context).size.height/3,
                        width: MediaQuery.of(context).size.width / 1.5,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Welcome back!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 30, 
                          fontWeight: FontWeight.w400, 
                          color: Colors.grey[800]
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Username or Email", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                          TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade400),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: SharedColors.textColor),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: SharedColors.textColor),
                              ),
                            ),
                            cursorColor: SharedColors.textColor,
                            validator: (value) {
                              if(value.isEmpty)
                                return "Please enter a valid email or username";
                              return null;
                            },
                            onSaved: (value) => model.auth = value,
                          ),
                          SizedBox(height: 50),
                          Text("Password", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                          TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade400),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: SharedColors.textColor),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: SharedColors.textColor),
                              ),
                            ),
                            cursorColor: SharedColors.textColor,
                            obscureText: true,
                            validator: (value) {
                              if(value.isEmpty)
                                return "Please enter a password";
                              return null;
                            },
                            onSaved: (value) => model.password = value,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(RoutesManager.forgotPassword),
                                child: Text(
                                  "Forgot password?",
                                  style: TextStyle(fontFamily: 'Raleway',color: SharedColors.textColor, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: FlatButton(
                                    padding: EdgeInsets.fromLTRB(55, 15, 55, 15),
                                    onPressed: model.login,
                                    child: model.state == ViewState.Busy
                                      ? Container(width: 15, height: 15, child: CircularProgressIndicator(backgroundColor: SharedColors.defaultColor))
                                      : Text(
                                          "Log In",
                                          style: TextStyle(fontFamily: 'Raleway',color: Colors.white),
                                        ),
                                    color: SharedColors.defaultColor,
                                  )),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don\'t have an account?", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                              GestureDetector(
                                child: Text(
                                  " Register",
                                  style: TextStyle(fontFamily: 'Raleway',color: SharedColors.textColor, fontWeight: FontWeight.w500),
                                ),
                                onTap: () => Navigator.pushNamed(context, RoutesManager.register),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
 
  }
}