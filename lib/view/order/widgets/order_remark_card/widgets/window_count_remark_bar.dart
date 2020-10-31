/*
 * @Description: 上门安装意向时间 订单备注
 * @Author: iamsmiling
 * @Date: 2020-10-29 17:26:56
 * @LastEditTime: 2020-10-30 07:37:33
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/view/order/popup_modal/submit_order_popup_modal.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';

import 'base/order_remark_bar.dart';

class WindowCountRemarkBar extends StatefulWidget {
  final OrderCreator orderCreator;
  WindowCountRemarkBar(this.orderCreator, {Key key}) : super(key: key);

  @override
  _WindowCountRemarkBarState createState() => _WindowCountRemarkBarState();
}

class _WindowCountRemarkBarState extends State<WindowCountRemarkBar> {
  OrderCreator get orderCreator => widget.orderCreator;
  @override
  Widget build(BuildContext context) {
    return OrderRemarkBar(
      title: '需测量窗数:',
      text: '${orderCreator?.windowCount ?? '请选择'}',
      callback: () =>
          showWindowCountPicker(context, orderCreator).whenComplete(() {
        setState(() {});
      }),
    );
  }
}
