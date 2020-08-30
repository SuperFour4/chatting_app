import 'package:flutter/material.dart';
import 'package:chatting_app/constants.dart';
class InputTextField extends StatelessWidget {
  final String hintString;
  final bool obsecure ;
  final TextEditingController controller;
  final Function validator;
  const InputTextField({
    Key key,
    this.hintString,
    this.controller,
    this.validator,
    this.obsecure= false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecure,
      validator: validator,
      controller: controller,
      style: kSimpleTextStyle,
      decoration: InputDecoration(
        hintText: hintString.toString(),
        hintStyle: TextStyle(
          color: Colors.white54,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
