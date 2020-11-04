/*
 * @Description: 场景详情
 * @Author: iamsmiling
 * @Date: 2020-10-23 11:13:05
 * @LastEditTime: 2020-11-04 10:15:43
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/repository/shop/product/design/scene_design_product_bean.dart';
import 'package:taojuwu/view/product/scene_design/widgets/product_style_tag.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class SceneDesignProductDetailSectionView extends StatelessWidget {
  final SceneDesignProductBean bean;
  const SceneDesignProductDetailSectionView(this.bean, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: ZYNetImage(
              imgPath: bean?.picture,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              bean?.desc ?? '',
              style: TaojuwuTextStyle.SUB_TEXT_STYLE,
              textAlign: TextAlign.left,
            ),
          ),
          Row(
            children: [
              ProductStyleTag(bean?.room),
              ProductStyleTag(bean?.style)
            ],
          )
        ],
      ),
    );
  }
}
