import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryStyleTextField extends StatelessWidget {
  const PrimaryStyleTextField(
      {Key key,
      this.controller,
      this.onChanged,
      this.suffixIcon,
      this.autofocus = false,
      this.prefixIcon,
      this.hasBorder = false,
      this.onTap,
      this.maxLines,
      this.hintText = 'Text'})
      : super(key: key);

  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;
  final Widget suffixIcon;
  final bool autofocus;
  final bool hasBorder;
  final Function onTap;
  final Widget prefixIcon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      onTap: onTap,
      style: TextStyle(fontFamily: 'joypixels'),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
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
      maxLines: maxLines,
      expands: false,
    );
  }
}
