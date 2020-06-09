import 'package:flutter/material.dart';
import 'package:taojuwu/models/order/order_cart_goods_model.dart';
import 'package:taojuwu/models/order/order_model.dart';

import 'package:taojuwu/utils/ui_kit.dart';

class CommitOrderCard extends StatelessWidget {
  final OrderCartGoods goods;
  const CommitOrderCard({Key key, this.goods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String attrsText = '';
    List<OrderProductAttrWrapper> attrs = goods.wcAttr;
    attrs.forEach((OrderProductAttrWrapper item) {
      attrsText +=
          '${item.attrName}: ${item.attrs.map((item) => item.name).toList().join('')} ';
    });

    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: UIKit.height(15)),
            child: Text(
              goods?.tag ?? '',
              style: TextStyle(fontSize: UIKit.sp(24)),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Image.network(
                  UIKit.getNetworkImgPath(goods?.img),
                  width: UIKit.width(200),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text.rich(TextSpan(
                            text: goods?.goodsName ?? '',
                            children: [
                              TextSpan(text: '  型号', style: textTheme.caption)
                            ],
                            style: textTheme.title.copyWith(
                              fontSize: UIKit.sp(24),
                            ),
                          )),
                          Text.rich(TextSpan(
                              text: '${goods?.price ?? 0.00}',
                              children: [TextSpan(text: goods?.unitPrice)]))
                        ],
                      ),
                      Container(
                        color: const Color(0xFFFAFAFA),
                        padding: EdgeInsets.symmetric(
                            vertical: UIKit.height(10),
                            horizontal: UIKit.width(10)),
                        child: Text(
                          '$attrsText ' ?? '',
                          style: textTheme.caption,
                        ),
                      ),
                      // Flexible(
                      //     child: Container(
                      //   color: const Color(0xFFFAFAFA),
                      //   padding: EdgeInsets.symmetric(
                      //       vertical: UIKit.height(10),
                      //       horizontal: UIKit.width(10)),
                      //   child: Text(
                      //     attrsText ?? '',
                      //     style: textTheme.caption,
                      //   ),
                      // ))
                    ],
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
