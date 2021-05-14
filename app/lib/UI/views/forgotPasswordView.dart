import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/UI/viewmodels/forgotPasswordViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ForgotPasswordViewModel>(
      viewModel: ForgotPasswordViewModel(),
      builder: (context, model, _) => SafeArea(
        child: Scaffold(
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
              "Password recovery",
              style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade800),
            ),
            centerTitle: true,
          ),

          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40,),

                FaIcon(
                  FontAwesomeIcons.userLock,
                  color: SharedColors.defaultColor,
                  size: 120,
                ),

                SizedBox(height: 40,),

                Container(
                  height: 200,
                  child: PageView(
                    controller: model.pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Form(
                            key: model.emailFormState,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Email", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
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
                                    if(value.isEmpty || !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value))
                                      return "Please provide a valid email";
                                    return null;
                                  },
                                  onSaved: (value) => model.email = value,
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                    
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Form(
                            key: model.tokenFormState,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Token", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
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
                                    if(value.isEmpty || value.length != 6)
                                      return "Please provide a valid token";
                                    return null;
                                  },
                                  onSaved: (value) => model.token = value,
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                    
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Form(
                            key: model.passwordFormState,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                    if(value.isEmpty || value.length < 8)
                                      return "Please provide a valid password";
                                    return null;
                                  },
                                  onSaved: (value) => model.password = value,
                                ),

                                SizedBox(height: 40,),
                                Text("Confirm Password", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
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
                                    if(value.isEmpty || value != model.password)
                                      return "Please provide the same password as the password field";
                                    return null;
                                  },
                                ),
                              ],
                            )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              
                SizedBox(height: 10,),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: FlatButton(
                            padding: EdgeInsets.fromLTRB(55, 15, 55, 15),
                            onPressed: model.advanceForm,
                            child: model.state == ViewState.Busy
                              ? Container(width: 15, height: 15, child: CircularProgressIndicator(backgroundColor: SharedColors.defaultColor))
                              : Text(
                                  "Next",
                                  style: TextStyle(fontFamily: 'Raleway',color: Colors.white),
                                ),
                            color: SharedColors.defaultColor,
                          )),
                    ],
                  ),
                ),

                SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}