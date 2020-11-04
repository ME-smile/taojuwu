/*
 * @Description: 场景推荐视图
 * @Author: iamsmiling
 * @Date: 2020-10-13 09:36:11
 * @LastEditTime: 2020-10-16 13:23:14
 */
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:taojuwu/providers/theme_provider.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/goods/scene_project/widgets/scene_project_goods_card.dart';

class SoftProjectRecommendationSectionView extends StatelessWidget {
  final List<SceneProjectBean> list;
  const SoftProjectRecommendationSectionView(this.list, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: TaojuwuColors.LIGHT_GREY_COLOR,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: TitleTip(
                title: '场景推荐',
              ),
            ),
            StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: list.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) =>
                  SceneProjectGoodsCard(
                imgFlex: index.isEven ? 5 : 1,
                bean: list[index],
              ),
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 2.5 : 3.5),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12.0,
            )
          ],
        ),
      ),
    );
  }
}
