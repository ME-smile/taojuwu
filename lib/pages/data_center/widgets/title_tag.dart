import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class TitleTag extends StatelessWidget {
  final String title;
  const TitleTag(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.caption,
      ),
      margin: EdgeInsets.symmetric(vertical: UIKit.height(20)),
      padding: EdgeInsets.symmetric(
          vertical: UIKit.height(5), horizontal: UIKit.width(10)),
      color: const Color(0xFFFFF0F0F0),
    );
  }
}
