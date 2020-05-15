import 'package:flutter/material.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';

class CancelOrderButton extends StatelessWidget {
  final String text;
  final Function callback;
  final bool isActive;
  const CancelOrderButton({
    Key key,
    this.text: '取消订单',
    this.callback,
    this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZYOutlineButton(
      text,
      () {
        callback();
      },
      isActive: isActive,
    );
  }
}
