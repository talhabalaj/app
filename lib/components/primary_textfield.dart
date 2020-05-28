import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class PrimaryStyleTextField extends StatelessWidget {
  const PrimaryStyleTextField(
      {Key key,
      this.controller,
      this.onChanged,
      this.suffixIcon,
      this.autofocus = false,
      this.prefixIcon,
      this.hasBorder = false,
      this.hintText = 'Text'})
      : super(key: key);

  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;
  final Widget suffixIcon;
  final bool autofocus;
  final bool hasBorder;
  final Widget prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
              hasBorder ? BorderSide(color: Colors.grey[300]) : BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        fillColor: Color(0xffEBEBEB),
        hintStyle: TextStyle(
          color: Color(0xff878787),
        ),
        focusColor: Colors.red,
      ),
      maxLines: 1,
      expands: false,
    );
  }
}
