import 'package:flutter/material.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';

class SelectedProductButton extends StatelessWidget {
  final String text;
  final Function callback;
  const SelectedProductButton({this.text: '去选品', this.callback, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZYOutlineButton(text, callback);
  }
}
