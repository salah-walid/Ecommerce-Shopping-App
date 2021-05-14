import 'dart:async';

import 'package:ecom/core/models/dialog_models.dart';


class DialogService {
  Function(DialogRequest) _showDialogListener;
  Function(DialogPhoneRequest) _showPhoneDialogListener;
  Function(DialogRequestFields) _showDialogFieldsListener;
  Function(DialogRequest) _showPasswordDialogListener;
  Completer<DialogResponse> _dialogCompleter;
  Completer<DialogResponse> _phoneDialogCompleter;
  Completer<DialogResponsePassword> _passwordDialogCompleter;

  /// Registers a callback function. Typically to show the dialog
  void registerDialogListener(Function(DialogRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  void registerPhoneDialogListener(Function(DialogPhoneRequest) showDialogListener) {
    _showPhoneDialogListener = showDialogListener;
  }

  void registerFieldDialogListener(Function(DialogRequestFields) showDialogListener) {
    _showDialogFieldsListener = showDialogListener;
  }

  void registerPasswordDialogListener(Function(DialogRequest) showDialogListener) {
    _showPasswordDialogListener = showDialogListener;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future<DialogResponse> showDialog({
    String title,
    String description,
    String buttonTitle = 'Ok',
  }) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(DialogRequest(
      title: title,
      description: description,
      buttonTitle: buttonTitle,
    ));
    return _dialogCompleter.future;
  }

  Future<DialogResponse> showPhoneDialog({
    String title,
    Function(String) onConfirmed,
    String buttonTitle = 'Ok',
  }) {
    _phoneDialogCompleter = Completer<DialogResponse>();
    _showPhoneDialogListener(DialogPhoneRequest(
      title: title,
      onConfirmed: onConfirmed,
      buttonTitle: buttonTitle,
    ));
    return _phoneDialogCompleter.future;
  }

  /// Shows a confirmation dialog
  Future<DialogResponse> showConfirmationDialog(
      {String title,
      String description,
      String confirmationTitle = 'Ok',
      String cancelTitle = 'Cancel'}) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(DialogRequest(
        title: title,
        description: description,
        buttonTitle: confirmationTitle,
        cancelTitle: cancelTitle));
    return _dialogCompleter.future;
  }

  Future<DialogResponsePassword> showPasswordDialog(
      {String title,
      String confirmationTitle = 'Ok',
      String cancelTitle = 'Cancel'}) {

    _passwordDialogCompleter = Completer<DialogResponsePassword>();
    _showPasswordDialogListener(DialogRequest(
        title: title,
        buttonTitle: confirmationTitle,
        cancelTitle: cancelTitle));
    return _passwordDialogCompleter.future;
  }


  Future<DialogResponse> showFieldsDialog(
      {String title,
      String field1,
      String field2,
      String field3,
      String field4,
      String field5,
      String field6,
      String confirmationTitle = 'Ok',
      String cancelTitle = 'Cancel'}) {

    _dialogCompleter = Completer<DialogResponse>();
    _showDialogFieldsListener(
      DialogRequestFields(
        title: title,
        buttonTitle: confirmationTitle,
        cancelTitle: cancelTitle,
        field1Title: field1,
        field3Title: field2,
        field4Title: field3,
        field5Title: field4,
        field6Title: field5,
        field7Title: field6,
      )
    );
    return _dialogCompleter.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete(DialogResponse response) {
    _dialogCompleter.complete(response);
    _dialogCompleter = null;
  }

  void phoneDialogComplete(DialogResponse response) {
    _phoneDialogCompleter.complete(response);
    _phoneDialogCompleter = null;
  }

  void passwordDialogComplete(DialogResponsePassword response) {
    _passwordDialogCompleter.complete(response);
    _passwordDialogCompleter = null;
  }
}
