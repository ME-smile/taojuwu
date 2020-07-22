import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class CardSkeleton extends StatelessWidget {
  const CardSkeleton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width / 2,
      margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
      child: Column(
        children: <Widget>[
          Container(
            width: (width - 20) / 2,
            height: (width - 20) / 2,
            color: Colors.grey,
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
