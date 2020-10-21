/*
 * @Description: 商品列表 网格视图
 * @Author: iamsmiling
 * @Date: 2020-10-10 13:45:39
 * @LastEditTime: 2020-10-10 13:49:58
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/curtain_product_list_model.dart';
import 'package:taojuwu/view/goods/curtain/widgets/curtain_grid_view.dart';

class GoodsGridView extends StatelessWidget {
  final List<GoodsItemBean> goodsList;
  const GoodsGridView(this.goodsList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        // physics: NeverScrollableScrollPhysics(),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .75,
          crossAxisSpacing: 10,
        ),
        itemCount: goodsList.length,
        itemBuilder: (BuildContext context, int i) {
          return GridCard(goodsList[i]);
        });
  }
}
