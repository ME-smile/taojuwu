/*
 * @Description: 商品详情底部
 * @Author: iamsmiling
 * @Date: 2020-10-23 10:15:20
 * @LastEditTime: 2020-10-29 13:36:20
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/abstract/base_product_bean.dart';
import 'package:taojuwu/view/product/widgets/base/purchase_action_bar.dart';

class ProductDeatilFooter extends StatelessWidget {
  final BaseProductBean bean;
  const ProductDeatilFooter(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      color: themeData.primaryColor,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text.rich(TextSpan(text: '预计:\n', children: [
              TextSpan(
                  // text: '0.00',
                  text: '${bean?.totalPrice?.toStringAsFixed(2)}',
                  // text:
                  //     '${baseGoodsViewModel.totalPrice.toStringAsFixed(2) ?? "0.00"}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ])),
          ),
          Expanded(flex: 3, child: PurchaseActionBar(bean))
        ],
      ),
    );
  }
}
