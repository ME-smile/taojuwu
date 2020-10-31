/*
 * @Description: 商品描述
 * @Author: iamsmiling
 * @Date: 2020-10-22 09:37:24
 * @LastEditTime: 2020-10-28 17:31:05
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';
import 'package:taojuwu/view/goods/base/onsale_tag.dart';
import 'package:taojuwu/view/product/widgets/base/cart_button.dart';
import 'package:taojuwu/view/product/widgets/base/like_button.dart';

class ProductDetailProfile extends StatelessWidget {
  final SingleProductBean bean;
  const ProductDetailProfile(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return SliverToBoxAdapter(
      child: Container(
        color: themeData.primaryColor,
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(TextSpan(
                    text: bean?.goodsName ?? '',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                          text: bean?.goodsName ?? '', style: textTheme.caption)
                    ])),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.only(right: 20),
                      //   child: LikeButton(),
                      // ),
                      LikeButton(hasLiked: false, goodsId: bean?.goodsId),
                      Container(
                        margin: EdgeInsets.only(left: 24),
                        child: CartButton(),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Text.rich(TextSpan(
                text: '¥${bean?.price ?? 0.00}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                children: [
                  TextSpan(text: bean.unit, style: textTheme.caption),
                  TextSpan(text: ' '),
                  TextSpan(
                      text: bean?.isPromotionalProduct == true
                          ? '¥${bean?.marketPrice}'
                          : '',
                      style: textTheme.caption
                          .copyWith(decoration: TextDecoration.lineThrough)),
                  WidgetSpan(
                      child: Offstage(
                    offstage: bean?.isPromotionalProduct == false,
                    child: OnSaleTag(),
                  ))
                ])),
          ],
        ),
      ),
    );
  }
}
