/*
 * @Description: 瀑布流视图
 * @Author: iamsmiling
 * @Date: 2020-10-23 11:23:34
 * @LastEditTime: 2021-01-10 14:35:11
 */
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:taojuwu/providers/theme_provider.dart';
import 'package:taojuwu/repository/shop/product_detail/design/scene_design_product_detail_bean.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/product/scene_design/widgets/scene_design_product_card.dart';

class RecommendSceneDesignProductSectionView extends StatelessWidget {
  final List<SceneDesignProductDetailBean> list;
  const RecommendSceneDesignProductSectionView(this.list, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TaojuwuColors.LIGHT_GREY_COLOR,
      padding: EdgeInsets.symmetric(horizontal: 16),
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
            itemCount: list?.length ?? 0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) =>
                SceneProjectGoodsCard(
              imgFlex: index.isEven ? 3 : 1,
              bean: list[index],
            ),
            staggeredTileBuilder: (int index) =>
                new StaggeredTile.count(2, index == 0 ? 2.4 : 3.0),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12.0,
          )
        ],
      ),
    );
  }
}
