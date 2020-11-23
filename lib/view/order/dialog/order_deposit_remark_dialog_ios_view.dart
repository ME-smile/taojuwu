/*
 * @Description: 订单押金对话框 ios
 * @Author: iamsmiling
 * @Date: 2020-10-29 18:04:01
 * @LastEditTime: 2020-11-20 17:37:18
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';

class OrderDepositRemarkDialogIosView extends StatefulWidget {
  final OrderCreator orderCreator;
  OrderDepositRemarkDialogIosView(this.orderCreator, {Key key})
      : super(key: key);

  @override
  _OrderDepositRemarkDialogIosViewState createState() =>
      _OrderDepositRemarkDialogIosViewState();
}

class _OrderDepositRemarkDialogIosViewState
    extends State<OrderDepositRemarkDialogIosView> {
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
    return CupertinoAlertDialog(
      title: Text('定金'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoDialogAction(
          child: Text('确定'),
          onPressed: () {
            if (isValidDeposit) {
              ordercreator?.depositAmount = controller?.text;
              Navigator.of(context).pop();
            }
          },
        )
      ],
      content: Container(
        child: Column(
          children: <Widget>[
            CupertinoTextField(
              controller: controller,
              keyboardType: TextInputType.number,
              placeholder: '元',
              autofocus: true,
            ),
          ],
        ),
      ),
    );
  }
}
