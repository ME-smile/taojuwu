import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class ZYRaisedButton extends StatelessWidget {
  final String text;
  final Function callback;
  final bool isActive;

  final double horizontalPadding;
  final double verticalPadding;
  final double fontsize;
  const ZYRaisedButton(this.text, this.callback,
      {Key key,
        this.isActive: true,
        this.horizontalPadding,
        this.verticalPadding,
        this.fontsize = 13})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme accentTextTheme = themeData.accentTextTheme;
    return InkWell(
      onTap: isActive ? callback : null,
      child: Container(
        child: Text(
          text,
          style: isActive
              ? accentTextTheme.button.copyWith(fontSize: fontsize)
              : accentTextTheme.button
              .copyWith(fontSize: fontsize, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
            color: isActive ? themeData.accentColor : themeData.disabledColor,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(
              width: 1,
              color: isActive ? themeData.accentColor : themeData.disabledColor,
            )),
        margin: EdgeInsets.symmetric(vertical: UIKit.height(20)),
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 28,
            vertical: verticalPadding ?? 5),
      ),
    );
  }
}
