/*
 * @Description: 搭配精选视图
 * @Author: iamsmiling
 * @Date: 2020-10-09 13:05:48
 * @LastEditTime: 2020-10-16 09:17:55
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:taojuwu/repository/shop/curtain_product_list_model.dart';

import 'package:taojuwu/view/goods/base/onsale_tag.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/goods/base/trailing_tip.dart';
import 'package:taojuwu/view/goods/curtain/widgets/popup_window/related_goods_popup_window.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class RelatedGoodsSectionView extends StatelessWidget {
  final List<GoodsItemBean> relatedGoodsList;
  const RelatedGoodsSectionView(this.relatedGoodsList, {Key key})
      : super(key: key);

  int get len => (relatedGoodsList ?? []).length;

  // 每三个一组--->

  //共有多少组
  int get groupCount {
    int mod = len % 3;
    int div = len ~/ 3;
    return mod > 0 ? div + 1 : div;
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Visibility(
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          padding: EdgeInsets.only(bottom: 16),
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleTip(title: '搭配精选'),
                      TrailingTip(
                        callback: () => showRelateGoodsPopupWindow(
                            context, relatedGoodsList),
                      )
                    ]),
              ),
              Container(
                height: 160,
                child: Swiper(
                  itemCount: groupCount,
                  pagination: new SwiperPagination(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      builder: DotSwiperPaginationBuilder(
                          size: 6.0,
                          activeSize: 6.0,
                          activeColor: Colors.black,
                          color: Colors.black.withOpacity(.3))),
                  itemBuilder: (BuildContext context, int i) {
                    return Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: relatedGoodsList
                          .sublist(i, i + 3)
                          .map((e) => RelatedGoodsCard(e))
                          ?.toList(),
                    ));
                  },
                ),
              )
            ],
          ),
        ),
        visible: len > 0,
      ),
    );
  }
}

class RelatedGoodsCard extends StatelessWidget {
  final GoodsItemBean bean;
  const RelatedGoodsCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  imgPath: bean.picCoverMid,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bean.goodsName,
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
                  visible: bean.isPromotionGoods,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                      text: '¥${bean.displayPrice}',
                      children: [
                        TextSpan(
                            text: '/米',
                            style: TextStyle(
                                color: const Color(0xFF999999), fontSize: 10)),
                      ],
                      style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFF1B1B1B),
                          fontWeight: FontWeight.bold)),
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
