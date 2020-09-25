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
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
        callback();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: UIKit.height(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: const Color(0xFF333333), fontSize: 14),
              ),
              flex: 1,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    trailingText,
                    style: TextStyle(fontSize: 14, color: Color(0xFF1B1B1B)),
                  ),
                  showNext
                      ? Icon(
                          ZYIcon.next,
                          size: 20,
                        )
                      : Container()
                ],
              ),
              flex: 4,
            )
          ],
        ),
      ),
    );
  }
}
