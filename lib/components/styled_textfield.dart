import 'package:Moody/constants.dart';
import 'package:flutter/material.dart';

class StyledTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Function(String) onChanged;
  final void Function(String) onSaved;
  final bool password;
  final String Function(String) validator;
  final bool enabled;

  const StyledTextField({
    Key key,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.password = false,
    this.validator,
    this.onSaved,
    this.enabled,
  }) : super(key: key);

  @override
  _StyledTextFieldState createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            widget.labelText,
            textAlign: TextAlign.left,
            style: kTextStyle.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: widget.password && passwordVisible,
            onChanged: widget.onChanged,
            textAlign: TextAlign.left,
            onSaved: widget.onSaved,
            enabled: widget.enabled,
            style: kTextStyle,
            validator: widget.validator ??
                (value) =>
                    value.isEmpty ? '${widget.labelText} is required.' : null,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffEFEFF4),
              contentPadding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Color(0xffB4B2B3),
              ),
              errorStyle: kTextStyle.copyWith(
                color: Colors.red,
                fontSize: 17,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              suffixIcon: widget.password
                  ? IconButton(
                      padding: EdgeInsets.only(right: 10),
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(0xffB4B2B3),
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
