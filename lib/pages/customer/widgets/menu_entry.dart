import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

class MenuEntry extends StatelessWidget {
  final String iconPath;
  final String title;
  final int number;
  final bool showBorder;
  final Function callback;
  const MenuEntry(
      {Key key,
      this.iconPath,
      this.title,
      this.number,
      this.callback,
      this.showBorder: true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return InkWell(
        onTap: callback,
        child: Container(
          height: 50.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: showBorder
                          ? themeData.dividerColor
                          : Colors.transparent,
                      width: .5))),
          padding: EdgeInsets.symmetric(
            horizontal: UIKit.width(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text.rich(TextSpan(text: '', children: [
                WidgetSpan(
                  child: ZYAssetImage(iconPath),
                ),
                TextSpan(text: '   '),
                TextSpan(
                    text: title ?? '',
                    style: TextStyle(fontSize: UIKit.sp(32))),
                TextSpan(text: ''),
                TextSpan(
                    text: number == null ? '（0）' : '($number)',
                    style: textTheme.caption.copyWith(fontSize: UIKit.sp(32)))
              ])),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
        ));
  }
}
