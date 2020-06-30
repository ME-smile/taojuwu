import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class DateTag extends StatelessWidget {
  final String date;
  const DateTag({Key key, this.date: '0.00-0.00'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: UIKit.height(20)),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            height: 1,
            color: Colors.black,
          )),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: UIKit.height(10), horizontal: UIKit.width(20)),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Text(date),
          ),
          Expanded(
              child: Container(
            height: 1,
            color: Colors.black,
          )),
        ],
      ),
    );
  }
}
