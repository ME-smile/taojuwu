import 'package:flutter/material.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';

class CancelOrderGoodsButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final Function callback;
  const CancelOrderGoodsButton(
      {Key key, this.text, this.isActive, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZYOutlineButton(
      isActive ? '取消' : '取消待审核',
      () {
        callback();
      },
      isActive: isActive,
    );
  }
}
