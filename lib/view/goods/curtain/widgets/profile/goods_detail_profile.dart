/*
 * @Description: //商品图片下方的简介
 * @Author: iamsmiling
 * @Date: 2020-09-27 13:54:32
 * @LastEditTime: 2020-11-02 10:23:05
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/view/goods/base/onsale_tag.dart';

class GoodsDetailProfile extends StatelessWidget {
  final ProductDetailBean bean;
  final int goodsNumInCart; // 商品购物车的数量
  const GoodsDetailProfile(this.bean, {Key key, this.goodsNumInCart = 0})
      : super(key: key);

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
                    style: TextStyle(
                        fontSize: UIKit.sp(28), fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                          text: bean?.goodsName ?? '', style: textTheme.caption)
                    ])),
                // Container(
                //   padding: EdgeInsets.only(bottom: 10),
                //   child: Row(
                //     children: [
                //       Padding(
                //         padding: EdgeInsets.only(right: 20),
                //         child: LikeButton(),
                //       ),
                //       CartButton()
                //     ],
                //   ),
                // ),
              ],
            ),
            Text.rich(TextSpan(
                text: '¥${bean?.price ?? 0.00}',
                style: TextStyle(
                    fontSize: UIKit.sp(32), fontWeight: FontWeight.w500),
                children: [
                  TextSpan(text: bean.unit, style: textTheme.caption),
                  TextSpan(text: ' '),
                  TextSpan(
                      text: bean?.isPromotionGoods == true
                          ? '¥${bean?.marketPrice}'
                          : '',
                      style: textTheme.caption
                          .copyWith(decoration: TextDecoration.lineThrough)),
                  WidgetSpan(
                      child: Offstage(
                    offstage: bean?.isPromotionGoods == false,
                    child: OnSaleTag(),
                  ))
                ])),
          ],
        ),
      ),
    );
  }
}
