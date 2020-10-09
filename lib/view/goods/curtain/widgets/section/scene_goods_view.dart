/*
 * @Description: 场景推荐
 * @Author: iamsmiling
 * @Date: 2020-10-09 14:27:32
 * @LastEditTime: 2020-10-09 14:28:52
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';

class SceneGoodsView extends StatelessWidget {
  const SceneGoodsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        child: TitleTip(
          title: '场景推荐',
        ),
      ),
    );
  }
}
