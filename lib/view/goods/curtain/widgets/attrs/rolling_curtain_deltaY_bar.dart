/*
 * @Description: 卷帘详情 离地距离
 * @Author: iamsmiling
 * @Date: 2020-10-31 10:01:31
 * @LastEditTime: 2020-10-31 17:59:55
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/product/curtain/rolling_curtain_product_bean.dart';
import 'package:taojuwu/view/product/dialog/dialog.dart';

class RollingCurtainDeltaYBar extends StatefulWidget {
  final RollingCurtainProductBean bean;
  RollingCurtainDeltaYBar(this.bean, {Key key}) : super(key: key);

  @override
  _RollingCurtainDeltaYBarState createState() =>
      _RollingCurtainDeltaYBarState();
}

class _RollingCurtainDeltaYBarState extends State<RollingCurtainDeltaYBar> {
  RollingCurtainProductBean get bean => widget.bean;

  bool get isDeltaYNull => bean?.measureData?.deltaYCM == null;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // FocusManager.instance.primaryFocus.unfocus();
        // callback();
        // pickAttr(context);
        // setSize(context, bean).whenComplete(() {
        //   print(bean?.measureData?.width);
        //   print(bean?.measureData?.widthM);
        //   print(bean?.measureData?.hasSetSize);
        //   setState(() {});
        // });
        setDeltaY(context, bean).whenComplete(() {
          setState(() {});
        });
      },
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                '离地距离',
                style: TextStyle(color: const Color(0xFF333333), fontSize: 14),
              ),
              flex: 1,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    isDeltaYNull
                        ? '离地距离(cm)'
                        : '${bean?.measureData?.deltaYCM}cm',
                    style: TextStyle(fontSize: 14, color: Color(0xFF1B1B1B)),
                  ),
                  Icon(
                    ZYIcon.next,
                    size: 20,
                  )
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
