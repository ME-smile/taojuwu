import 'package:flutter/material.dart';
import 'package:taojuwu/models/order/order_cart_goods_model.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/goods_attr_card.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

import 'package:taojuwu/widgets/zy_netImage.dart';

class CommitOrderCard extends StatelessWidget {
  final OrderCartGoods goods;
  const CommitOrderCard({Key key, this.goods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return goods?.isEndproduct == true
        ? EndProductOrderCard(
            goods: goods,
          )
        : CustomizedProductOrderCard(
            goods: goods,
          );
  }
}

class EndProductOrderCard extends StatelessWidget {
  final OrderCartGoods goods;
  const EndProductOrderCard({Key key, this.goods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      color: themeData.primaryColor,
      margin: EdgeInsets.only(top: UIKit.height(20)),
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              ZYNetImage(
                imgPath: goods?.img,
                isCache: false,
                width: UIKit.width(180),
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                height: UIKit.height(190),
                // width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          goods?.goodsName ?? '',
                          style: textTheme.headline6.copyWith(
                              fontSize: UIKit.sp(28),
                              fontWeight: FontWeight.bold),
                        ),
                        Text.rich(TextSpan(
                          text: '￥' + '${goods?.price}' ?? '',
                          // children: [TextSpan(text: cartModel?.unit)]
                        )),
                      ],
                    ),
                    Expanded(
                      child: Text(
                        goods?.desc ?? '',
                        softWrap: true,
                        style: textTheme.caption.copyWith(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
            child: Text(
              '小计: ¥${goods?.totalPrice}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomizedProductOrderCard extends StatelessWidget {
  final OrderCartGoods goods;
  const CustomizedProductOrderCard({Key key, this.goods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                        bottom: UIKit.width(20), left: UIKit.width(20)),
                    child: Text(goods?.tag ?? ''),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(
                        UIKit.getNetworkImgPath(goods?.img),
                        width: UIKit.width(200),
                        height: UIKit.width(200),
                      ),
                      Expanded(
                          child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  goods?.goodsName ?? '',
                                ),
                                Text('¥${goods?.price ?? 0.00}'),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: UIKit.height(10),
                                // horizontal: UIKit.width(10)
                              ),
                              child: Text(
                                '${goods?.desc ?? ''}',
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
                  GoodsAttrCard(
                    isInCartPage: false,
                    attrs: goods?.attrs,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '小计: ¥${goods?.totalPrice}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 12,
                              padding: EdgeInsets.only(top: 2, right: 2),
                              alignment: Alignment.center,
                              child: ZYAssetImage('exclamatory_mark.png',
                                  width: 10, height: 10),
                            ),
                            Text(
                              '预估价格',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF999999)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
