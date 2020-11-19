/*
 * @Description: 为你推荐商品列表视图
 * @Author: iamsmiling
 * @Date: 2020-10-23 09:59:48
 * @LastEditTime: 2020-11-16 18:10:07
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/base_product_detail_bean.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';

import 'package:taojuwu/utils/extensions/object_kit.dart';
import 'package:taojuwu/widgets/product_grid_card.dart';

class RecommendedProductSectionView extends StatelessWidget {
  final List<BaseProductDetailBean> list;
  const RecommendedProductSectionView(this.list, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(list);
    return Visibility(
      child: Container(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleTip(title: '为你推荐'),
                  ]),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 8),
                  itemCount: list?.length ?? 0,
                  itemBuilder: (BuildContext context, int i) {
                    // return GridCard(goodsList[i]);

                    return ProductGridCard(list[i]);
                  }),
            )

            // Flexible(child: )
          ],
        ),
      ),
      visible: !isNullOrEmpty(list),
    );
  }
}
