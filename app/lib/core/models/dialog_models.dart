class DialogRequest {
  final String title;
  final String description;
  final String buttonTitle;
  final String cancelTitle;

  DialogRequest(
      {this.title = "",
      this.description = "",
      this.buttonTitle = "Ok",
      this.cancelTitle});
}

class DialogPhoneRequest {
  final String title;
  final Function(String) onConfirmed;
  final String buttonTitle;
  final String cancelTitle;

  DialogPhoneRequest(
      {this.title = "",
      this.onConfirmed,
      this.buttonTitle = "Ok",
      this.cancelTitle = "Cancel"});
}

class DialogRequestFields {
  final String title;
  final String field1Title;
  final String field3Title;
  final String field4Title;
  final String field5Title;
  final String field6Title;
  final String field7Title;
  final String buttonTitle;
  final String cancelTitle;
 
  DialogRequestFields( 
      {this.title = "",
      this.field1Title,
      this.field3Title,
      this.field4Title, 
      this.field5Title, 
      this.field6Title, 
      this.field7Title,
      this.buttonTitle = "Ok",
      this.cancelTitle = "Cancel"});
}

class DialogResponsePassword {
  String password;
  String newPassword;
  bool confirmed;

  DialogResponsePassword(
      {
      this.password,
      this.newPassword,
      this.confirmed});
}

class DialogAdressResponse {
  String billingAdress;
  String adress;
  String phoneNumber;
  String city;
  String state;
  String zipCode;
  String country;
  bool confirmed;

  DialogAdressResponse({
    this.billingAdress,
    this.adress,
    this.phoneNumber,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.confirmed,
  });
}

class DialogResponse {
  String adress;
  String phoneNumber;
  String city;
  String state;
  String zipCode;
  String country;
  bool confirmed;

  DialogResponse({
    this.adress,
    this.phoneNumber,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.confirmed,
  });
}
