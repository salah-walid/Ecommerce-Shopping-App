import 'package:ecom/UI/components/customTextField.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/UI/viewmodels/base_model.dart';
import 'package:ecom/UI/viewmodels/registerViewModel.dart';
import 'package:ecom/core/managers/Routes.dart';
import 'package:ecom/UI/views/base_view.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterViewModel>(
      viewModel: RegisterViewModel(),
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
              "Register",
              style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade800),
            ),
            centerTitle: true,
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 70,
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  
                  SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Welcome!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 30, 
                        fontWeight: FontWeight.w400, 
                        color: Colors.grey[800]
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: model.loadImage,
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey,
                      child: model.image == null
                        ? Center(
                            child: Icon(
                              Icons.add_a_photo,
                              size: 20,
                            ),
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                model.image,
                                fit: BoxFit.fitHeight,
                              ),

                              Positioned(
                                right: 5,
                                bottom: 5,
                                child: Icon(
                                  Icons.add_a_photo_sharp,
                                  size: 30,
                                  color: SharedColors.defaultColor,
                                ),
                              )
                            ],
                          ),
                    ),
                  ),

                  SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: model.formState,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Email", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                          CustomTextField(
                            onSaved: (value) => model.user.email = value,
                            validator: (value){
                              if(value.isEmpty || !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value))
                                return "Please provide a valid email";
                               return null;
                            }
                          ),
                          SizedBox(height: 30),

                          Text("Username", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                          CustomTextField(
                            onSaved: (value) => model.user.username = value,
                            validator: (value){
                              if(value.isEmpty)
                                return "Please provide a user name";
                              return null;
                            }
                          ),
                          SizedBox(height: 30),

                          Text("Password", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                          CustomTextField(
                            obscureText: true,
                            onSaved: (value) => model.password = value,
                            validator: (value){
                              if(value.isEmpty)
                                return "Please provide a password";
                              else if(value.length <= 8)
                                return "Please provide a password with a length bigger or equal to 8";
                              return null;
                            }
                          ),
                          SizedBox(height: 30),

                          Text("Confirm password", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                          CustomTextField(
                            obscureText: true,
                            validator: (value){
                              if(value.isEmpty)
                                return "Please provide a user name";
                              else if(model.password != value)
                                return "Please provide the same password as the password field";
                              return null;
                            }
                          ),
                          
                          SizedBox(height: 30),

                          ExpandablePanel(
                            header: Text("Billing address", style: TextStyle(fontFamily: 'Raleway', fontSize: 20,color: Colors.grey.shade700)),
                            collapsed: Text("(Click to expand)", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade500)),
                            expanded: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Text("Billing address", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.user.billingAdress = value,
                                  onSubmited: model.billingAdresseSubmited,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a billing address";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("City", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.user.billingCity = value,
                                  controller: model.billingCityC,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a city";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("State", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.user.billingState = value,
                                  controller: model.billingStateC,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a state";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("Zip / Postal Code", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.user.billingZipCode = value,
                                  controller: model.billingZipCodeC,
                                  validator: (value){
                                    if(value.isEmpty || int.tryParse(value) == null || value.length != 5)
                                      return "Please provide a valid zip code";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("Country", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  initialValue: "Malaysia",
                                  enabled: false,
                                  onSaved: (value) => model.user.billingCountry = value,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a country";
                                    return null;
                                  }
                                ),

                                
                              ],
                            ),
                            // ignore: deprecated_member_use
                            tapHeaderToExpand: true,
                          ),
                          SizedBox(height: 30),

                          ExpandablePanel(
                            header: Text("Delivery address", style: TextStyle(fontFamily: 'Raleway', fontSize: 20,color: Colors.grey.shade700)),
                            collapsed: Text("(Click to expand)", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade500)),
                            expanded: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Text("Billing address", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.user.deliveryAdress = value,
                                  onSubmited: model.deliveryAdresseSubmited,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a delivery address";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("City", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.user.deliveryCity = value,
                                  controller: model.deliveryCityC,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a city";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("State", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.user.deliveryState = value,
                                  controller: model.deliveryStateC,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a state";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("Zip / Postal Code", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  onSaved: (value) => model.user.deliveryZipCode = value,
                                  controller: model.deliveryZipCodeC,
                                  validator: (value){
                                    if(value.isEmpty || int.tryParse(value) == null || value.length != 5)
                                      return "Please provide a valid zip code";
                                    return null;
                                  }
                                ),
                                SizedBox(height: 30),

                                Text("Country", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                                CustomTextField(
                                  initialValue: "Malaysia",
                                  enabled: false,
                                  onSaved: (value) => model.user.deliveryCountry = value,
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "Please provide a country";
                                    return null;
                                  }
                                ),

                                
                              ],
                            ),
                            // ignore: deprecated_member_use
                            tapHeaderToExpand: true,
                          ),

                          Divider(
                            height: 50,
                            color: Colors.grey.shade400,
                            thickness: 1,
                          ),                   

                          Text("Mobile Number", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                          InternationalPhoneNumberInput(
                            onInputChanged: (mn) {
                              model.user.deliveryMobileNumber = mn.phoneNumber;
                              model.user.billingMobileNumber = mn.phoneNumber;
                            },
                            
                            formatInput: false,
                            initialValue: PhoneNumber(phoneNumber: "", isoCode: "DZ"),
                            countries: ["DZ"],
                            validator: (value){
                              if(value.isEmpty || value.length != 9)
                                return "Please provide a valid phone number";
                              
                              return null;
                            },                    //onSaved: (value) => model.orderData.mobileNumber = value,
                          ),

                          SizedBox(height: 50),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              Checkbox(
                                value: model.termsAccepted,
                                onChanged: model.changeTermsAccepted,
                                activeColor: SharedColors.defaultColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),

                              Text(
                                "I accept the ",
                                style: TextStyle(
                                    
                                    letterSpacing: 2,
                                    fontFamily: 'Raleway',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),

                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(RoutesManager.termsAndConditions),
                                child: Text(
                                  "Term & Conditions",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: SharedColors.defaultColor,
                                      letterSpacing: 2,
                                      fontFamily: 'Raleway',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: FlatButton(
                                  padding: EdgeInsets.fromLTRB(55, 15, 55, 15),
                                  onPressed: model.register,
                                  child: model.state == ViewState.Idle
                                    ? Text(
                                        "Register",
                                        style: TextStyle(fontFamily: 'Raleway',color: Colors.white),
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: SharedColors.defaultColor,
                                        ),
                                      ),
                                  color: SharedColors.defaultColor,
                                )
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          
                        ],
                      ),
                    ),
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