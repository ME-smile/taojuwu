/*
 * @Description: 订单备注 
 * @Author: iamsmiling
 * @Date: 2020-10-29 16:58:09
 * @LastEditTime: 2020-10-29 17:41:26
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';

typedef FutureCallback = Future Function();

class OrderRemarkBar extends StatefulWidget {
  final String title;
  final String text;
  final FutureCallback callback;
  OrderRemarkBar({Key key, this.title, this.text, this.callback})
      : super(key: key);

  @override
  _OrderRemarkBarState createState() => _OrderRemarkBarState();
}

class _OrderRemarkBarState extends State<OrderRemarkBar> {
  String get title => widget.title;
  String get text => widget.text;
  FutureCallback get callback => widget.callback;

  // 执行回调
  void executeCallback() {
    if (callback == null) return;
    callback().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return GestureDetector(
      onTap: executeCallback,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(title ?? ''),
                )),
            Expanded(
                flex: 3,
                child: Text(
                  text ?? '',
                  style: textTheme.caption,
                )),
            Icon(
              ZYIcon.next,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}
