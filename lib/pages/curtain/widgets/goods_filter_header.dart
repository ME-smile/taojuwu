import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class GoodsFilterHeader extends StatelessWidget {
  final Widget filter1;
  final Widget filter2;
  final Widget filter3;
  final Widget filter4;

  const GoodsFilterHeader({Key key,this.filter1,this.filter2,this.filter3,this.filter4}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
              Container(
                        padding: EdgeInsets.symmetric(
                            vertical: UIKit.height(15),
                            horizontal: UIKit.width(20)),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIKit.width(10)),
                              child:  filter1,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIKit.width(10)),
                              child: filter2,
                            ),
                          ],
                        ),
                      ),
                   Container(
                        padding: EdgeInsets.symmetric(
                            vertical: UIKit.height(15),
                            horizontal: UIKit.width(20)),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIKit.width(10)),
                              child:filter3,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIKit.width(10)),
                              child: filter4,
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      );
  }
}