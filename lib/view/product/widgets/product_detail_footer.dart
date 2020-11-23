/*
 * @Description: 商品详情底部
 * @Author: iamsmiling
 * @Date: 2020-10-23 10:15:20
 * @LastEditTime: 2020-11-20 16:23:00
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/view/product/widgets/base/purchase_action_bar.dart';
import 'package:taojuwu/view/product/widgets/base/select_product_action_bar.dart';

class ProductDeatilFooter extends StatelessWidget {
  final BaseProductDetailBean bean;
  final Function callback;
  const ProductDeatilFooter(this.bean, {Key key, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return ((bean is BaseCurtainProductDetailBean) &&
            (bean as BaseCurtainProductDetailBean).isMeasureOrder)
        ? SelectProductActionBar(bean)
        : Container(
            decoration: BoxDecoration(
                color: themeData.primaryColor,
                border:
                    Border(top: BorderSide(color: const Color(0xFFE7E7E7)))),
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(top: 4),
                    child: Text.rich(TextSpan(text: '预计:\n', children: [
                      WidgetSpan(
                        child: Text('¥${bean?.totalPrice?.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                    ])),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: PurchaseActionBar(
                      bean,
                      callback: callback,
                    ))
              ],
            ),
          );
  }
}
