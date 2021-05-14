import 'package:ecom/UI/components/customTextField.dart';
import 'package:ecom/UI/shared/colors.dart';
import 'package:ecom/core/models/dialog_models.dart';
import 'package:ecom/core/services/dialog_service.dart';
//import 'package:ecom/core/services/phoneVerificationService.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';


import '../../locator.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
    _dialogService.registerFieldDialogListener(_showDialogWithFields);
    _dialogService.registerPasswordDialogListener(_showPasswordDialog);
    _dialogService.registerPhoneDialogListener(_showPhoneDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showPasswordDialog(DialogRequest request) {
    final formState = GlobalKey<FormState>();
    DialogResponsePassword dialogResponse = DialogResponsePassword();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.title),
        content: SingleChildScrollView(
          child: Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Text("Old Password", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
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
                  onSaved: (value) => dialogResponse.password = value,
                  validator: (value){
                    if(value.length <= 8)
                      return "Please provide a valid password (minimum 8 caracters)";
                    return null;
                  }
                ),
                SizedBox(height: 10),

                Text("New Password", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
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
                  onSaved: (value) => dialogResponse.newPassword = value,
                  validator: (value){
                    if(value.length <= 8)
                      return "Please provide a valid password (minimum 8 caracters)";
                    return null;
                  }
                ),
                SizedBox(height: 10),

                Text("Confirm New Password", style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
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
                  validator: (value){
                    if(dialogResponse.newPassword != value)
                      return "Please provide the same password";
                    return null;
                  }
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(request.cancelTitle, style: TextStyle(color: Colors.black),),
            onPressed: () {
              _dialogService
                  .passwordDialogComplete(DialogResponsePassword(confirmed: false));
                  Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(request.buttonTitle, style: TextStyle(color: Colors.black),),
            onPressed: () {
              formState.currentState.save();

              if(!formState.currentState.validate())
                return;

              dialogResponse.confirmed = true;

              _dialogService
                  .passwordDialogComplete(dialogResponse);
                  Navigator.pop(context);
            },
          ),
        ],
    ));
  }

  void _showDialogWithFields(DialogRequestFields request) {
    final formState = GlobalKey<FormState>();
    DialogResponse dialogResponse = DialogResponse(phoneNumber: "");

    //PhoneVerficationService _phoneVerficationService = locator<PhoneVerficationService>();

    final TextEditingController cityC = TextEditingController();
    final TextEditingController stateC = TextEditingController();
    final TextEditingController zipCodeC = TextEditingController();

    bool phoneVerified = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.title),
        content: SingleChildScrollView(
          child: Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                if(request.field1Title != null)
                  ...[
                    Text(request.field1Title, style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                    CustomTextField(
                      onSaved: (value) => dialogResponse.adress = value,
                      onSubmited: (value) async{
                        /* Address result = (await Geocoder.local.findAddressesFromQuery(value + ", Malaysia")).first;
    
                        print("done");
                        stateC.text = result.locality;
                        cityC.text = result.subLocality;
                        zipCodeC.text = result.postalCode; */
                      },
                      validator: (value){
                        if(value.isEmpty)
                          return "Please provide a ${request.field1Title}";
                        return null;
                      }
                    ),
                    
                    SizedBox(height: 10),
                  ],

                if(request.field3Title != null)
                  ...[
                    Text(request.field3Title, style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InternationalPhoneNumberInput(
                          onInputChanged: (mn) {
                            dialogResponse.phoneNumber = mn.phoneNumber;
                            if(!phoneVerified)
                              phoneVerified = false;
                          },
                          
                          inputDecoration: const InputDecoration(
                            errorMaxLines: 2
                          ),
                          formatInput: false,
                          selectorButtonOnErrorPadding: 14,
                          initialValue: PhoneNumber(phoneNumber: "", isoCode: "DZ"),
                          countries: ["DZ"],
                          validator: (value){
                            if(value.isEmpty || value.length != 9)
                              return "Please provide a valid phone number";
                            if(!phoneVerified)
                              return "Please verify your mobile number";
                            
                            return null;
                          },
                          //onSaved: (value) => model.orderData.mobileNumber = value,
                        ),

                        SizedBox(width: 8,),

                        /* FlatButton(
                          onPressed: () async{
                            if(dialogResponse.phoneNumber.isNotEmpty && dialogResponse.phoneNumber.length == 9 + 3)
                              phoneVerified  = await _phoneVerficationService.verifyPhone(dialogResponse.phoneNumber);
                            else
                              formState.currentState.validate();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            child: Text(
                              "Verify Phone",
                              style: TextStyle(fontFamily: 'Raleway',color: Colors.white),
                            ),
                          ),
                          color: SharedColors.defaultColor,
                        ), */


                      ],
                    ),
                    SizedBox(height: 10),
                  ],

                if(request.field4Title != null)
                  ...[
                    Text(request.field4Title, style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
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
                      onSaved: (value) => dialogResponse.city = value,
                      controller: cityC,
                      validator: (value){
                        if(value.isEmpty)
                          return "Please provide a ${request.field4Title}";
                        return null;
                      }
                    ),
                    SizedBox(height: 10),
                  ],

                if(request.field5Title != null)
                  ...[
                    Text(request.field5Title, style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
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
                      onSaved: (value) => dialogResponse.state = value,
                      controller: stateC,
                      validator: (value){
                        if(value.isEmpty)
                          return "Please provide a ${request.field5Title}";
                        return null;
                      }
                    ),
                    SizedBox(height: 10),
                  ],

                if(request.field6Title != null)
                  ...[
                    Text(request.field6Title, style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
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
                      onSaved: (value) => dialogResponse.zipCode = value,
                      controller: zipCodeC,
                      validator: (value){
                        if(value.isEmpty || int.tryParse(value) == null || value.length != 5)          
                          return "Please provide valid a ${request.field6Title}";
                        return null;
                      }
                    ),
                    SizedBox(height: 10),
                  ],

                if(request.field7Title != null)
                  ...[
                    Text(request.field7Title, style: TextStyle(fontFamily: 'Raleway',color: Colors.grey.shade600)),
                    TextFormField(
                      initialValue: "Malaysia",
                      enabled: false,
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
                      onSaved: (value) => dialogResponse.country = value,
                      validator: (value){
                        if(value.isEmpty)
                          return "Please provide a ${request.field7Title}";
                        return null;
                      }
                    ),
                    SizedBox(height: 10),
                  ]
              ],
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(request.cancelTitle, style: TextStyle(color: Colors.black),),
            onPressed: () {
              _dialogService
                  .dialogComplete(DialogResponse(confirmed: false));
                  Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(request.buttonTitle, style: TextStyle(color: Colors.black),),
            onPressed: () {
              formState.currentState.save();

              if(!formState.currentState.validate())
                return;

              dialogResponse.confirmed = true;

              _dialogService
                  .dialogComplete(dialogResponse);
                  Navigator.pop(context);
            },
          ),
        ],
    ));
  }

  void _showDialog(DialogRequest request) {
    var isConfirmationDialog = request.cancelTitle != null;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.title),
        content: Text(request.description),
        actions: <Widget>[
          if (isConfirmationDialog)
            FlatButton(
              child: Text(request.cancelTitle, style: TextStyle(color: Colors.black),),
              onPressed: () {
                _dialogService
                    .dialogComplete(DialogResponse(confirmed: false));
                    Navigator.pop(context);
              },
            ),
          FlatButton(
            child: Text(request.buttonTitle, style: TextStyle(color: Colors.black),),
            onPressed: () {
              _dialogService
                  .dialogComplete(DialogResponse(confirmed: true));
                  Navigator.pop(context);
            },
          ),
        ],
    ));
  }

  void _showPhoneDialog(DialogPhoneRequest request) {
    var isConfirmationDialog = request.cancelTitle != null;

    String code = "";
    final formState = GlobalKey<FormState>();

    bool validatedCode = true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.title),
        content: Form(
          key: formState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onSaved: (value) => code = value,
                
                initialValue: "",
                validator: (value){
                  if(value.isEmpty)
                    return "Please provide a valid validation code";
                  if(!validatedCode)
                    return "Wrong validation code";
                  
                  return null;
                },  
                //onSaved: (value) => model.orderData.mobileNumber = value,
              ),

              
            ],
          ),
        ),
        actions: <Widget>[
          if (isConfirmationDialog)
            FlatButton(
              child: Text(request.cancelTitle, style: TextStyle(color: Colors.black),),
              onPressed: () {
                _dialogService
                    .phoneDialogComplete(DialogResponse(confirmed: false));
                    Navigator.pop(context);
              },
            ),
          FlatButton(
            child: Text(request.buttonTitle, style: TextStyle(color: Colors.black),),
            onPressed: () {
              if(!formState.currentState.validate())
                return;
              formState.currentState.save();
              if(!request.onConfirmed(code)){
                validatedCode = false;
                formState.currentState.validate();
                validatedCode = true;
                return;
              }

              _dialogService
                  .phoneDialogComplete(DialogResponse(confirmed: true));
                  Navigator.pop(context);
            },
          ),
        ],
    ));
  }
  
}
