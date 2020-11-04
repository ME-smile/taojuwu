/*
 * @Description: 场景详情 相关商品视图
 * @Author: iamsmiling
 * @Date: 2020-10-23 11:16:05
 * @LastEditTime: 2020-11-03 17:51:57
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';
import 'package:taojuwu/view/product/popup_modal/pop_up_modal.dart';
import 'package:taojuwu/view/product/widgets/base/cart_button.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/widgets/relative_product_card.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

import 'package:taojuwu/utils/extensions/object_kit.dart';

class SceneDesignRelativeProductSectionView extends StatelessWidget {
  final int id;
  final List<SingleProductBean> goodsList;
  const SceneDesignRelativeProductSectionView(this.id, this.goodsList,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isNullOrEmpty(goodsList),
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
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 8),
              itemBuilder: (BuildContext context, int index) {
                // return Text('12345678');
                return RelativeProductCard(goodsList[index]);
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
                  '立即购买(${goodsList.length})',
                  () {
                    showDesignProductDetailModal(context, id);
                    // showDesignProductDetailModal(context, fromProductBean)
                    // showDesignProductDetailModal(context, bean, fromProductBean)
                  },
                  horizontalPadding: 12,
                  verticalPadding: 7.2,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
