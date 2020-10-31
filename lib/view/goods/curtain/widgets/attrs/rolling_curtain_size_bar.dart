/*
 * @Description: 卷帘尺寸信息
 * @Author: iamsmiling
 * @Date: 2020-10-31 09:47:55
 * @LastEditTime: 2020-10-31 09:59:49
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/product/curtain/rolling_curtain_product_bean.dart';
import 'package:taojuwu/view/product/dialog/dialog.dart';

class RollingCurtainSizeBar extends StatefulWidget {
  final RollingCurtainProductBean bean;
  RollingCurtainSizeBar(this.bean, {Key key}) : super(key: key);

  @override
  _RollingCurtainSizeBarState createState() => _RollingCurtainSizeBarState();
}

class _RollingCurtainSizeBarState extends State<RollingCurtainSizeBar> {
  RollingCurtainProductBean get bean => widget.bean;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // FocusManager.instance.primaryFocus.unfocus();
        // callback();
        // pickAttr(context);
        setSize(context, bean).whenComplete(() {
          print(bean?.measureData?.width);
          print(bean?.measureData?.widthM);
          print(bean?.measureData?.hasSetSize);
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
                '尺寸',
                style: TextStyle(color: const Color(0xFF333333), fontSize: 14),
              ),
              flex: 1,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '宽:${bean?.measureData?.width}米;高:${bean?.measureData?.height}米',
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
