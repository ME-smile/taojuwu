/*
 * @Description: 订单押金对话框
 * @Author: iamsmiling
 * @Date: 2020-10-29 17:52:09
 * @LastEditTime: 2020-11-20 17:35:38
 */
import 'package:flutter/material.dart';

import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class OrderDepositRemarkDialogAndroidView extends StatefulWidget {
  final OrderCreator orderCreator;
  OrderDepositRemarkDialogAndroidView(this.orderCreator, {Key key})
      : super(key: key);

  @override
  _OrderDepositRemarkDialogAndroidViewState createState() =>
      _OrderDepositRemarkDialogAndroidViewState();
}

class _OrderDepositRemarkDialogAndroidViewState
    extends State<OrderDepositRemarkDialogAndroidView> {
  OrderCreator get ordercreator => widget.orderCreator;
  TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: ordercreator?.depositAmount);
    super.initState();
  }

  bool get isValidDeposit {
    String text = controller?.text;
    if (text == null || text.isEmpty) {
      ToastKit.showInfo('定金不能为空哦');
      return false;
    }
    // if (CommonKit.parseDouble(text) == 0) {
    //   ToastKit.showInfo('定金不能为0哦');
    //   return false;
    // }
    return true;
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
          '定金',
          textAlign: TextAlign.center,
        ),
        titleTextStyle: TextStyle(fontSize: 16, color: Color(0xFF333333)),
        content: Container(
          child: Column(
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
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: '元',
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
                    if (isValidDeposit) {
                      ordercreator?.depositAmount = controller?.text;
                      // provider?.deposit = depositInput?.text;
                      Navigator.of(context).pop();
                    }
                  })
                ],
              )
            ],
          ),
        ));
  }
}
