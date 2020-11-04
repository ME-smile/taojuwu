/*
 * @Description: //加入购物车 立即购买按钮
 * @Author: iamsmiling
 * @Date: 2020-10-23 10:17:00
 * @LastEditTime: 2020-11-03 16:29:57
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/abstract/abstract_base_product_bean.dart';

class PurchaseActionBar extends StatelessWidget {
  final AbstractBaseProductBean bean;
  final Function callback;
  const PurchaseActionBar(this.bean, {Key key, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Builder(
              builder: (BuildContext ctx) {
                return GestureDetector(
                  onTap: () =>
                      bean?.addToCartAction(context, callback: callback),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: themeData.accentColor)),
                    // color: canAddToCart
                    //     ? themeData.accentColor
                    //     : themeData.disabledColor)),
                    child: Text(
                      '加入购物车',
                      textAlign: TextAlign.center,
                      // style: true
                      //     ? TextStyle()
                      //     : TextStyle(color: themeData.disabledColor),
                    ),
                  ),
                );
              },
            ),
            flex: 1,
          ),
          Expanded(
              child: GestureDetector(
                onTap: () => bean?.buyAction(context, callback: callback),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: themeData.accentColor,
                      border: Border.all(color: themeData.accentColor)),
                  child: Text(
                    '立即购买',
                    style: themeData.accentTextTheme.button,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              flex: 1),
        ],
      ),
    );
  }
}
