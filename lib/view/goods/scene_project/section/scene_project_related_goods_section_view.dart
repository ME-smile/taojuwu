/*
 * @Description: 相关场景 相关商品视图
 * @Author: iamsmiling
 * @Date: 2020-10-13 13:09:59
 * @LastEditTime: 2020-10-16 11:21:56
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/view/goods/base/cart_button.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/goods/curtain/widgets/section/related_goods_section_view.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class SceneProjectRelatedGoodsSectionView extends StatelessWidget {
  final List<ProjectGoodsBean> goodsList;
  const SceneProjectRelatedGoodsSectionView(this.goodsList, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !CommonKit.isNullOrEmpty(goodsList),
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
                return RelatedGoodsCard(goodsList[index]);
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
