import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class OnSaleTag extends StatelessWidget {
  const OnSaleTag({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: UIKit.width(5)),
      margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
      child: Text('限时特价',
          style: TextStyle(color: Colors.white, fontSize: UIKit.sp(20))),
      decoration: BoxDecoration(color: const Color(0xFFEB8181)),
    );
  }
}

class DummyTag extends StatelessWidget {
  const DummyTag({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: UIKit.width(5)),
      child: Text('',
          style: TextStyle(color: Colors.white, fontSize: UIKit.sp(20))),
    );
  }
}
