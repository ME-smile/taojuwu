/*
 * @Description: 同料商品视图
 * @Author: iamsmiling
 * @Date: 2020-10-09 13:05:48
 * @LastEditTime: 2020-11-05 10:48:20
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';

import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/goods/base/trailing_tip.dart';
import 'package:taojuwu/view/product/popup_modal/pop_up_modal.dart';

import 'package:taojuwu/view/product/widgets/base/relative_product_card.dart';

class RelativeProductSectionView extends StatelessWidget {
  final List<SingleProductDetailBean> list;
  const RelativeProductSectionView(this.list, {Key key}) : super(key: key);

  int get len => (list ?? []).length;

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
                      TitleTip(
                        title: '同料商品',
                        tip: '(${list?.length ?? 0})',
                      ),
                      TrailingTip(
                        callback: () =>
                            showRelativeProductModalPopup(context, list),
                      )
                    ]),
              ),
              Container(
                height: 160,
                child: Swiper(
                  itemCount: groupCount,
                  loop: false,
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
                            children: (list.length > 3
                                    ? list?.sublist(i, i + 3)
                                    : list)
                                ?.map((e) => RelativeProductCard(e))
                                ?.toList()));
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
