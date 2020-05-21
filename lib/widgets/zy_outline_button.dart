import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class ZYOutlineButton extends StatelessWidget {
  final String text;
  final Function callback;
  final bool isActive;

  final double horizontalPadding;
  final double verticalPadding;
  const ZYOutlineButton(
    this.text,
    this.callback, {
    this.isActive: true,
    this.horizontalPadding,
    this.verticalPadding,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return InkWell(
      onTap: isActive ? callback : null,
      child: Container(
        child: Text(text,
            style: isActive
                ? TextStyle(fontSize: 16)
                : textTheme.button
                    .copyWith(color: themeData.disabledColor, fontSize: 16)),
        decoration: BoxDecoration(
            color: themeData.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(
                width: 1,
                color: isActive
                    ? themeData.accentColor
                    : themeData.disabledColor)),
        margin: EdgeInsets.symmetric(vertical: UIKit.height(20)),
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? UIKit.width(36),
            vertical: verticalPadding ?? UIKit.height(8)),
      ),
    );
  }
}
