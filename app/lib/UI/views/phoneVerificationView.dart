import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/UI/viewmodels/phoneVerificationViewModel.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneVerificationView extends StatelessWidget {

  final String token;

  const PhoneVerificationView({Key key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<PhoneVerificationViewModel>(
      viewModel: PhoneVerificationViewModel(),
      onModelReady: (model) => model.init(token),
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
              "Phone verification",
              style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade800),
            ),
            centerTitle: true,
          ),

          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Text(
                      "Please enter the 6 digits verification code sent by SMS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22
                      ),
                    ),

                    SizedBox(height: 20,),

                    PinCodeTextField(
                      appContext: context, 
                      length: 6,
                      onChanged: model.otpChanged,
                      keyboardType: TextInputType.number,
                    ),

                    SizedBox(height: 30,),

                    GestureDetector(
                      onTap: model.resendMessage,
                      child: model.state == ViewState.Busy
                        ? Container(width: 15, height: 15, child: CircularProgressIndicator(backgroundColor: SharedColors.defaultColor))
                        :Text(
                          "Resend",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue.shade600
                          ),
                        ),
                    ),

                    SizedBox(height: 30,),
                  
                    ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: FlatButton(
                          padding: EdgeInsets.fromLTRB(55, 15, 55, 15),
                          onPressed: model.verify,
                          child: model.state == ViewState.Busy
                            ? Container(width: 15, height: 15, child: CircularProgressIndicator(backgroundColor: SharedColors.defaultColor))
                            : Text(
                                "Confirm",
                                style: TextStyle(fontFamily: 'Raleway',color: Colors.white),
                              ),
                          color: SharedColors.defaultColor,
                        )),
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