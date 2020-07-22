import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class PurchaseActionBar extends StatelessWidget {
  final String totalPrice;
  final Function addToCartFunc;
  final Function purchaseFunc;
  final bool canAddToCart;
  const PurchaseActionBar(
      {Key key,
      this.totalPrice,
      this.addToCartFunc,
      this.purchaseFunc,
      this.canAddToCart = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text.rich(TextSpan(text: '预计:\n', children: [
              TextSpan(
                  text: '¥${totalPrice ?? 0.00}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ])),
          ),
          Expanded(
              flex: 3,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: canAddToCart
                            ? () {
                                if (addToCartFunc != null) {
                                  addToCartFunc();
                                }
                              }
                            : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: UIKit.width(20),
                              vertical: UIKit.height(11)),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: canAddToCart
                                      ? themeData.accentColor
                                      : themeData.disabledColor)),
                          child: Text(
                            '加入购物车',
                            textAlign: TextAlign.center,
                            style: canAddToCart == true
                                ? TextStyle()
                                : TextStyle(color: themeData.disabledColor),
                          ),
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                        child: InkWell(
                          onTap: () {
                            if (purchaseFunc != null) purchaseFunc();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: UIKit.height(11)),
                            decoration: BoxDecoration(
                                color: themeData.accentColor,
                                border:
                                    Border.all(color: themeData.accentColor)),
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
              ))
        ],
      ),
    );
  }
}
