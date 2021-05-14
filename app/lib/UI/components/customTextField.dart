import 'package:ecom/UI/shared/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {

  final Function(String) onSaved;
  final Function(String) validator;
  final Function(String) onSubmited;
  final TextEditingController controller;
  final bool obscureText;
  final bool enabled;
  final String initialValue;

  const CustomTextField({
    Key key,
    this.onSaved,
    this.validator, 
    this.obscureText = false, 
    this.enabled = true, 
    this.initialValue = "", 
    this.onSubmited, 
    this.controller,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final _focusNode = FocusNode();
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.text = widget.initialValue;
    
    _focusNode.addListener(() {
      if(!_focusNode.hasFocus && widget.onSubmited != null)
        widget.onSubmited(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      focusNode: _focusNode,
      controller: _controller,
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
      obscureText: widget.obscureText,
      cursorColor: SharedColors.textColor,
      onSaved: widget.onSaved,
      validator: widget.validator
    );
  }
}
