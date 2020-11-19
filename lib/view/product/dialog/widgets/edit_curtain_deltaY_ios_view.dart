/*
 * @Description: 修改窗帘离地距离对话框视图ios
 * @Author: iamsmiling
 * @Date: 2020-10-31 17:52:46
 * @LastEditTime: 2020-11-19 13:35:33
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';

class EditCurtainDeltaYIosView extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  EditCurtainDeltaYIosView(this.bean, {Key key}) : super(key: key);

  @override
  _EditCurtainDeltaYIosViewState createState() =>
      _EditCurtainDeltaYIosViewState();
}

class _EditCurtainDeltaYIosViewState extends State<EditCurtainDeltaYIosView> {
  BaseCurtainProductDetailBean get bean => widget.bean;
  OrderGoodsMeasureData get measureData => bean?.measureData;

  TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController(
        text: CommonKit.isNullOrEmpty(measureData?.deltaYCM)
            ? null
            : '${measureData?.deltaYCM}');

    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('离地距离(cm)'),
      content: Column(
        children: <Widget>[
          CupertinoTextField(
            controller: controller,
            placeholder: '请输入离地距离(cm)',
            keyboardType: TextInputType.number,
            autofocus: true,
          ),
        ],
      ),
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
            print(controller?.text);
            measureData?.deltaYCM = CommonKit.parseDouble(controller?.text);
            // goodsProvider?.dy = tmp;
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
