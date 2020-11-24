/*
 * @Description: 场景详情
 * @Author: iamsmiling
 * @Date: 2020-10-23 11:13:05
 * @LastEditTime: 2020-11-19 15:21:02
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/design/scene_design_product_detail_bean.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/view/product/scene_design/widgets/product_style_tag.dart';
import 'package:taojuwu/widgets/zy_photo_view.dart';

class SceneDesignProductDetailSectionView extends StatelessWidget {
  final SceneDesignProductDetailBean bean;
  const SceneDesignProductDetailSectionView(this.bean, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            child: ZYPhotoView(
              UIKit.getNetworkImgPath(bean?.picture),
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
              bigImageUrl: UIKit.getNetworkImgPath(bean?.bigPicture),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              bean?.desc ?? '',
              style: TextStyle(
                  color: const Color(0xFF333333),
                  letterSpacing: 1,
                  height: 1.5),
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
