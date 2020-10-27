/*
 * @Description: 场景详情 相关商品视图
 * @Author: iamsmiling
 * @Date: 2020-10-23 11:16:05
 * @LastEditTime: 2020-10-23 13:18:57
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';

import 'package:taojuwu/view/goods/base/cart_button.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

import 'package:taojuwu/utils/extensions/object_kit.dart';

class SceneDesignRelativeProductSectionView extends StatelessWidget {
  final List<SingleProductBean> goodsList;
  const SceneDesignRelativeProductSectionView(this.goodsList, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isNullOrEmpty(goodsList),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: TitleTip(
                title: '相关商品',
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 8),
              itemBuilder: (BuildContext context, int index) {
                return Text('12345678');
                // return RelativeProductCard(goodsList[index]);
              },
              itemCount: goodsList.length,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CartButton(),
                SizedBox(
                  width: 16,
                ),
                ZYRaisedButton(
                  '立即购买',
                  () {},
                  horizontalPadding: 12,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
