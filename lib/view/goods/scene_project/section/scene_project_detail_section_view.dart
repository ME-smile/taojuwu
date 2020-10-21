/*
 * @Description:场景详情视图
 * @Author: iamsmiling
 * @Date: 2020-10-12 16:39:51
 * @LastEditTime: 2020-10-16 11:19:34
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/view/goods/scene_project/widgets/style_tag.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class SceneProjectDetailSectionView extends StatelessWidget {
  final SceneProjectBean bean;
  const SceneProjectDetailSectionView(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.7,
            child: ZYNetImage(
              imgPath: 'https://i.loli.net/2020/10/10/ri4RfE1kgqh8GXc.jpg',
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              bean?.goodsDetail ?? '',
              style: TaojuwuTextStyle.SUB_TEXT_STYLE,
              textAlign: TextAlign.left,
            ),
          ),
          Row(
            children: [StyleTag(bean?.space), StyleTag(bean?.style)],
          )
        ],
      ),
    );
  }
}
