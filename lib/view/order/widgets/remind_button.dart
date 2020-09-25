import 'package:flutter/material.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';

class RemindButton extends StatelessWidget {
  final String text;
  final Function callback;
  final bool isActive;
  const RemindButton(this.text, this.callback, {Key key, this.isActive: true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZYOutlineButton(
      text,
      callback,
      isActive: isActive,
    );
  }
}
