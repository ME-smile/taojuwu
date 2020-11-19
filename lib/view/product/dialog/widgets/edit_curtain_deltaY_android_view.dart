/*
 * @Description: 修改窗帘离地距离对话框视图
 * @Author: iamsmiling
 * @Date: 2020-10-31 17:46:52
 * @LastEditTime: 2020-11-19 13:35:48
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class EditCurtainDeltaYAndroidView extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  EditCurtainDeltaYAndroidView(this.bean, {Key key}) : super(key: key);

  @override
  _EditCurtainDeltaYAndroidViewState createState() =>
      _EditCurtainDeltaYAndroidViewState();
}

class _EditCurtainDeltaYAndroidViewState
    extends State<EditCurtainDeltaYAndroidView> {
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
    return AlertDialog(
      title: Text(
        '离地距离',
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
                autofocus: true,
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    filled: true,
                    hintText: '请输入离地距离（cm）',
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
                // saveSize(goodsProvider);
                print(controller?.text);
                measureData?.deltaYCM = CommonKit.parseDouble(controller?.text);

                // goodsProvider?.dy = tmp;
                Navigator.of(context).pop();
              })
            ],
          )
        ],
      ),
    );
  }
}
