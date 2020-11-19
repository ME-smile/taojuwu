/*
 * @Description: 确认选品按钮
 * @Author: iamsmiling
 * @Date: 2020-11-18 14:10:16
 * @LastEditTime: 2020-11-18 14:36:04
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class SelectProductActionBar extends StatelessWidget {
  final BaseCurtainProductDetailBean bean;

  const SelectProductActionBar(
    this.bean, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: themeData.primaryColor,
          border: Border(top: BorderSide(color: const Color(0xFFE7E7E7)))),
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text.rich(TextSpan(text: '预计:\n', children: [
            TextSpan(
                // text: '0.00',
                text: '${bean?.totalPrice?.toStringAsFixed(2)}',
                // text:
                //     '${baseGoodsViewModel.totalPrice.toStringAsFixed(2) ?? "0.00"}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ])),
          ZYRaisedButton(
            '确认选品',
            () => bean.selectProduct(context),
            verticalPadding: 8,
          )
        ],
      ),
    );
  }
}
