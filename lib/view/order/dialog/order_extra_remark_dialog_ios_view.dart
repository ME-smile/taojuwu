/*
 * @Description: 订单备注对话框
 * @Author: iamsmiling
 * @Date: 2020-10-29 18:08:16
 * @LastEditTime: 2020-10-30 07:55:16
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class OrderExtraRemarkDialogIosView extends StatefulWidget {
  final OrderCreator orderCreator;
  OrderExtraRemarkDialogIosView(this.orderCreator, {Key key}) : super(key: key);

  @override
  _OrderExtraRemarkDialogIosViewState createState() =>
      _OrderExtraRemarkDialogIosViewState();
}

class _OrderExtraRemarkDialogIosViewState
    extends State<OrderExtraRemarkDialogIosView> {
  OrderCreator get orderCreator => widget.orderCreator;
  TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: orderCreator?.extraRemark);
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      title: Text(
        '备注',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: TextStyle(fontSize: 16, color: Color(0xFF333333)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 36,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: TextField(
                controller: controller,
                autofocus: true,
                // keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    filled: true,
                    hintText: '请填写备注',
                    fillColor: const Color(0xFFF2F2F2),
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ZYOutlineButton('取消', () {
                Navigator.of(context).pop();
              }),
              SizedBox(
                width: 40,
              ),
              ZYRaisedButton('确定', () {
                orderCreator?.extraRemark = controller?.text;
                // provider?.orderMark = markInput?.text;
                Navigator.of(context).pop();
              })
            ],
          )
        ],
      ),
    );
  }
}
