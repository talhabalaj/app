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

class _BottomSingleTextFieldFormState extends State<BottomSingleTextFieldForm> {
  TextEditingController _controller;
  bool _isEmojiPickerOpen;
  String _message;

  final containerDecoration = BoxDecoration(
    boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black12)],
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _isEmojiPickerOpen = false;
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
          height: 55,
          decoration: containerDecoration,
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: PrimaryStyleTextField(
                  controller: _controller,
                  hintText: 'Message',
                  hasBorder: true,
                  onTap: () {
                    if (_isEmojiPickerOpen) {
                      setState(() {
                        _isEmojiPickerOpen = !_isEmojiPickerOpen;
                      });
                    }
                  },
                  onChanged: (value) {
                    _message = value.trim();
                  },
                ),
              ),
              _buildSideButton(_onEmojiPickerToggle),
              _buildSideButton(_onSendPressed)
            ],
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: _isEmojiPickerOpen ? 250 : 0,
          child: EmojiKeyboard(
            emojiFont: 'joypixels',
            onEmojiPressed: _handleEmojiPressed,
          ),
        )
      ],
    );
  }

  void _onEmojiPickerToggle() {
    if (!_isEmojiPickerOpen) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    } else
      SystemChannels.textInput.invokeMethod('TextInput.show');
    setState(() {
      _isEmojiPickerOpen = !_isEmojiPickerOpen;
    });
  }

  Expanded _buildSideButton(Function onPressed) {
    return Expanded(
      flex: 1,
      child: RaisedButton(
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.grey[300],
            width: 1,
          ),
        ),
        disabledColor: Colors.grey[100],
        textColor: Colors.white,
        color: kPrimaryColor,
        child: Icon(
          Icons.send,
          size: 15,
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _onSendPressed() {
    widget.onSend(_message);
    setState(() {
      _controller.clear();
      _message = '';
    });
  }

  _handleEmojiPressed(emoji) {
    final selection = _controller.value.selection;
    final oldText = _controller.value.text;

    final newText =
        '${oldText.substring(0, selection.extent.offset)}${emoji.emoji}${oldText.substring(selection.extent.offset)}';
    _controller.value = _controller.value.copyWith(
      text: newText,
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: selection.extent.offset + emoji.emoji.length,
        ),
      ),
    );
    setState(() {
      _message = newText;
    });
  }
}
