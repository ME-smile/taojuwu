/*
 * @Description: 相关商品卡片
 * @Author: iamsmiling
 * @Date: 2020-10-22 17:09:43
 * @LastEditTime: 2020-11-04 10:22:09
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/relative_product/relative_product_bean.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/view/goods/base/onsale_tag.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class RelativeProductCard extends StatelessWidget {
  final RelativeProductBean bean;
  const RelativeProductCard(this.bean, {Key key}) : super(key: key);

  jump(BuildContext context, int type) {
    if (type == 0) {
      return RouteHandler.goEndProductDetail(context, bean?.goodsId);
    }
    if (type == 1) {
      return RouteHandler.goFabricCurtainProductDetailPage(
          context, bean?.goodsId);
    }
    if (type == 2) {
      return RouteHandler.goRollingCurtainProductDetailPage(
          context, bean?.goodsId);
    }
    if (type == 3) {
      return RouteHandler.goGauzeCurtainProductDetailPage(
          context, bean?.goodsId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => jump(context, bean?.goodsType),
      child: Container(
        alignment: Alignment.center,
        color: Theme.of(context).primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 108,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: ZYNetImage(
                  imgPath: bean?.cover,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bean?.goodsName ?? '',
                  style:
                      TextStyle(fontSize: 12, color: const Color(0xFF555555)),
                ),
                Visibility(
                  child: OnSaleTag(
                    text: '特价',
                    horizontalMargin: 5,
                    horizontalPadding: 2,
                    fontSize: 8,
                  ),
                  visible: bean?.isPromotionalProduct,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                      text: '¥${bean?.marketPrice}',
                      children: [
                        TextSpan(
                            text: '/米',
                            style: TextStyle(
                                color: const Color(0xFF999999), fontSize: 10)),
                      ],
                      style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFF1B1B1B),
                          fontWeight: FontWeight.w400)),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text('¥${bean.marketPrice}',
                      style: TextStyle(
                        fontSize: 8,
                        color: const Color(0xFF999999),
                        decoration: TextDecoration.lineThrough,
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
