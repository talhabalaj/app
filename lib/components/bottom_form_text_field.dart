import 'dart:async';

import 'package:Moody/components/primary_textfield.dart';
import 'package:Moody/constants.dart';
import 'package:emoji_keyboard/emoji_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomSingleTextFieldForm extends StatefulWidget {
  BottomSingleTextFieldForm({
    Key key,
    this.onSend,
  }) : super(key: key);

  final Function(String) onSend;

  @override
  _BottomSingleTextFieldFormState createState() =>
      _BottomSingleTextFieldFormState();
}

class _BottomSingleTextFieldFormState extends State<BottomSingleTextFieldForm>
    with TickerProviderStateMixin {
  TextEditingController _controller;
  bool _isEmojiPickerOpen;
  String _message;
  FocusNode _focusNode;

  final containerDecoration = BoxDecoration(
    boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black12)],
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _isEmojiPickerOpen = false;
    _focusNode = FocusNode();
    _message = '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(minHeight: 55),
          decoration: containerDecoration,
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: FocusScope(
                  onFocusChange: (hasFocus) {
                    if (hasFocus && _isEmojiPickerOpen) {
                      Timer(Duration(milliseconds: 1), () {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      });
                    }
                  },
                  child: PrimaryStyleTextField(
                    controller: _controller,
                    hintText: 'Message',
                    hasBorder: true,
                    focusNode: _focusNode,
                    onTap: () {
                      if (_isEmojiPickerOpen) {
                        setState(() {
                          _isEmojiPickerOpen = !_isEmojiPickerOpen;
                        });
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        _message = value.trim();
                      });
                    },
                  ),
                ),
              ),
              _buildSideButton(
                _onEmojiPickerToggle,
                iconData:
                    _isEmojiPickerOpen ? Icons.keyboard : Icons.insert_emoticon,
              ),
              _buildSideButton(
                _message != '' ? _onSendPressed : null,
                iconData: Icons.send,
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 100),
          reverseDuration: Duration(milliseconds: 1),
          vsync: this,
          child: EmojiKeyboard(
            emojiFont: 'joypixels',
            height: _isEmojiPickerOpen ? 250 : 0,
            onEmojiPressed: _handleEmojiPressed,
          ),
        ),
      ],
    );
  }

  void _onEmojiPickerToggle() {
    setState(() {
      _isEmojiPickerOpen = !_isEmojiPickerOpen;
      if (_isEmojiPickerOpen) {
        if (!_focusNode.hasFocus) _focusNode.requestFocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      } else
        SystemChannels.textInput.invokeMethod('TextInput.show');
    });
  }

  Expanded _buildSideButton(Function onPressed, {IconData iconData}) {
    return Expanded(
      child: RaisedButton(
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.grey[300],
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(0),
        disabledColor: Colors.grey[100],
        textColor: kPrimaryColor,
        color: Colors.white,
        child: Icon(
          iconData,
          size: 15,
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _onSendPressed() {
    widget.onSend(_message);
    _controller.clear();
    setState(() {
      _message = '';
    });
  }

  _handleEmojiPressed(emoji) {
    final newText = _controller.text + emoji.emoji;
    _controller.value = _controller.value.copyWith(
      text: newText,
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: newText.length,
        ),
      ),
    );
    setState(() {
      _message = newText;
    });
  }
}
