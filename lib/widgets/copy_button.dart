import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class CopyButton extends StatelessWidget {
  final String copyStr;
  const CopyButton(
    this.copyStr, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border.all(color: Color(0xFFC5C5C5))),
        margin: EdgeInsets.only(
          left: UIKit.width(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: Text(
          '复制',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(fontSize: UIKit.sp(18)),
        ),
      ),
      onTap: () {
        Clipboard.setData(ClipboardData(text: copyStr ?? ''));
        CommonKit.showToast('已复制到剪切板');
      },
    );
  }
}
