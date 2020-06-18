import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'dart:ui' as ui show PlaceholderAlignment;

import 'package:taojuwu/utils/ui_kit.dart';

class AttrOptionsBar extends StatelessWidget {
  final String title;
  final String trailingText;
  final Function callback; //1 BottomSheet 2 dialog 3 jump
  final bool showNext;
  const AttrOptionsBar(
      {Key key,
      this.title: '',
      this.trailingText: '',
      this.callback,
      this.showNext: true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
        callback();
      },
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
                  showNext
                      ? WidgetSpan(
                          child: Icon(ZYIcon.next),
                          alignment: ui.PlaceholderAlignment.middle,
                        )
                      : TextSpan()
                ],
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
