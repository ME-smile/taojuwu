import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';

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
              style: textTheme.caption.copyWith(
                  color: const Color(0xFF6D6D6D), fontSize: UIKit.sp(24)),
            ),
            Row(
              children: <Widget>[
                Text(
                  trailingText,
                  style: TextStyle(fontSize: UIKit.sp(24)),
                ),
                showNext
                    ? Icon(
                        ZYIcon.next,
                        size: 20,
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
