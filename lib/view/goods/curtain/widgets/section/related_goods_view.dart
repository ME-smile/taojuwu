/*
 * @Description: 同料商品视图
 * @Author: iamsmiling
 * @Date: 2020-10-09 13:05:48
 * @LastEditTime: 2020-10-09 16:29:26
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/view/goods/base/onsale_tag.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/goods/base/trailing_tip.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class RelatedGoodsView extends StatelessWidget {
  final List<RelatedGoodsBean> relatedGoodsList;
  const RelatedGoodsView(this.relatedGoodsList, {Key key}) : super(key: key);

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
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [TitleTip(title: '同料商品'), TrailingTip()]),
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
                          .map((e) => _RelatedGoodsCard(e))
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

class _RelatedGoodsCard extends StatelessWidget {
  final RelatedGoodsBean bean;
  const _RelatedGoodsCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 108,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: ZYNetImage(
                  imgPath: bean.picture,
                ),
              ),
            ),
            Row(
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
                  visible: bean.isOnSale,
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                      text: '¥${bean.price}',
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
