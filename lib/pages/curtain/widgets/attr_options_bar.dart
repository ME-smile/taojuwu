import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'dart:ui' as ui show PlaceholderAlignment;

import 'package:taojuwu/utils/ui_kit.dart';

class AttrOptionsBar extends StatelessWidget {
  final String title;
  final String trailingText;
  final Function callback; //1 BottomSheet 2 dialog 3 jump
  final bool isWindowGauze;
  const AttrOptionsBar(
      {Key key, this.title: '', this.trailingText: '', this.callback,this.isWindowGauze:false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Offstage(
      offstage: isWindowGauze,
      child: InkWell(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: textTheme.caption,
            ),
            Text.rich(
              TextSpan(
                text: trailingText,
                children: [
                  WidgetSpan(
                    child: ZYIcon.next,
                    alignment: ui.PlaceholderAlignment.middle,
                  )
                ],
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    ),
    );
  }
}
