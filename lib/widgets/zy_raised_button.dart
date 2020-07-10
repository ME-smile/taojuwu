import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class ZYRaisedButton extends StatelessWidget {
  final String text;
  final Function callback;
  final bool isActive;

  final double horizontalPadding;
  final double verticalPadding;
  const ZYRaisedButton(this.text, this.callback,
      {Key key,
      this.isActive: true,
      this.horizontalPadding,
      this.verticalPadding})
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
              ? accentTextTheme.button.copyWith(fontSize: 16)
              : accentTextTheme.button
                  .copyWith(fontSize: 16, color: Colors.white70),
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
            horizontal: horizontalPadding ?? UIKit.width(36),
            vertical: verticalPadding ?? UIKit.height(8)),
      ),
    );
  }
}
