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
      onTap: callback,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: accentTextTheme.button.copyWith(fontSize: 16),
          textAlign: TextAlign.start,
        ),
        decoration: BoxDecoration(
            color: themeData.accentColor,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(
              width: 1,
              color: themeData.accentColor,
            )),
        margin: EdgeInsets.symmetric(vertical: UIKit.height(20)),
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? UIKit.width(36),
            vertical: verticalPadding ?? UIKit.height(8)),
      ),
    );
  }
}
