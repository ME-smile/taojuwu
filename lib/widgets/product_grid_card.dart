/*
 * @Description: 商品列表片
 * @Author: iamsmiling
 * @Date: 2020-10-23 10:10:18
 * @LastEditTime: 2020-10-31 08:14:53
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/abstract/base_product_bean.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/view/goods/base/onsale_tag.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class ProductGridCard extends StatelessWidget {
  final BaseProductBean bean;
  const ProductGridCard(this.bean, {Key key}) : super(key: key);

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
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        jump(context, bean?.goodsType);
      },
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ZYNetImage(
              imgPath: bean?.cover ?? '',
              width: (width - 20) / 2,
              height: (width - 20) / 2,
              fit: BoxFit.cover,
              callback: () {
                jump(context, bean?.goodsType);
              },
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Text(bean?.goodsName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15)),
                  Offstage(
                    offstage: bean?.isPromotionalProduct == false,
                    child: OnSaleTag(),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Text.rich(TextSpan(
                    text: '￥${bean.price ?? "0.00"}',
                    style: TextStyle(fontSize: 16),
                    children: [
                  TextSpan(
                    text: '起',
                    style: themeData.textTheme.caption.copyWith(fontSize: 12),
                  ),
                  TextSpan(
                    text: ' ',
                  ),
                  TextSpan(
                      text: bean?.isPromotionalProduct == true
                          ? '￥${bean?.marketPrice}起'
                          : '',
                      style: themeData.textTheme.caption
                          .copyWith(decoration: TextDecoration.lineThrough)),
                  // TextSpan(text: '\n'),
                  // TextSpan(text: '11324'),
                ]))),
            // VSpacing(20),
          ],
        ),
      ),
    );
  }
}
