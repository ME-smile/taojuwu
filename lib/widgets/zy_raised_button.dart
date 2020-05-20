import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class ZYRaisedButton extends StatelessWidget {
  final String text;
  final Function callback;
  final bool isActive;
  const ZYRaisedButton(this.text, this.callback, {Key key, this.isActive: true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme accentTextTheme = themeData.accentTextTheme;
    return InkWell(
      onTap: callback,
      child: Container(
        child: Text(text, style: accentTextTheme.button.copyWith(fontSize: 16)),
        decoration: BoxDecoration(
            color: themeData.accentColor,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(
              width: 1,
              color: themeData.accentColor,
            )),
        margin: EdgeInsets.symmetric(vertical: UIKit.height(20)),
        padding: EdgeInsets.symmetric(
            horizontal: UIKit.width(36), vertical: UIKit.height(8)),
      ),
    );
  }
}
