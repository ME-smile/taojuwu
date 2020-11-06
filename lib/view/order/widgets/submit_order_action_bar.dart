/*
 * @Description:  提交订单页面 底部提交
 * @Author: iamsmiling
 * @Date: 2020-10-29 15:31:28
 * @LastEditTime: 2020-10-30 10:21:37
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_prodcut_detail_bean.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class SubmitOrderActionBar extends StatelessWidget {
  final OrderCreator orderCreator;
  const SubmitOrderActionBar(this.orderCreator, {Key key}) : super(key: key);

  AbstractProductDetailBean get bean => orderCreator.productDetailBean;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: themeData.primaryColor,
          border: Border(top: BorderSide(color: Colors.grey, width: .3))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text.rich(TextSpan(
              text: '共1件\n',
              style: textTheme.caption
                  .copyWith(fontSize: 12, fontWeight: FontWeight.w400),
              children: [
                TextSpan(
                    text: '${bean?.totalPrice?.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Color(0xFFFF6161),
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                TextSpan(
                    text: ' (具体金额以门店)',
                    style: textTheme.caption.copyWith(fontSize: 10))
              ])),
          ZYRaisedButton(
            '提交订单',
            () => orderCreator?.createOrder(context),
            verticalPadding: 6,
            horizontalPadding: 18,
          ),
        ],
      ),
    );
  }
}
