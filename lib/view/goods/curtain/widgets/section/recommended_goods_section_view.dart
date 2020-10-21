/*
 * @Description: 为你推荐商品
 * @Author: iamsmiling
 * @Date: 2020-10-12 14:04:03
 * @LastEditTime: 2020-10-16 10:27:30
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';

import '../curtain_grid_view.dart';

class RecommendGoodsSectionView extends StatelessWidget {
  final List<RecommendGoodsBean> goodsList;
  const RecommendGoodsSectionView(this.goodsList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Visibility(
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleTip(title: '为你推荐'),
                    ]),
              ),
              GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 8),
                  itemCount: goodsList != null && goodsList.isNotEmpty
                      ? goodsList.length
                      : 0,
                  itemBuilder: (BuildContext context, int i) {
                    return GridCard(goodsList[i]);
                  })

              // Flexible(child: )
            ],
          ),
        ),
        visible: !CommonKit.isNullOrEmpty(goodsList),
      ),
    );
  }
}
