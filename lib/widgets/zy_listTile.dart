import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/icon/ZYIcon.dart';

class ZYListTile extends StatelessWidget {
  final String title;
  final bool showDivider;
  final Widget trailing;
  final Function callback;
  const ZYListTile(
      {Key key,
      this.title,
      this.trailing,
      this.showDivider: true,
      this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: callback ?? () {},
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: UIKit.width(15), vertical: UIKit.height(20)),
        decoration: BoxDecoration(
            color: themeData.primaryColor,
            border: Border(
                bottom: BorderSide(
                    color: showDivider
                        ? themeData.dividerColor
                        : Colors.transparent,
                    width: UIKit.height(1)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(title ?? ''), trailing ?? Icon(ZYIcon.next)],
        ),
      ),
    );
  }
}
