/*
 * @Description: 软装方案弹窗详情头部
 * @Author: iamsmiling
 * @Date: 2020-10-23 15:30:27
 * @LastEditTime: 2020-11-04 12:18:51
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/repository/shop/product_detail/design/soft_design_product_detail_bean.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_photo_view.dart';

class SoftDesignModalHeader extends StatelessWidget {
  final SoftDesignProductDetailBean bean;
  const SoftDesignModalHeader(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: AspectRatio(
              aspectRatio: 1,
              child: ZYPhotoView(
                UIKit.getNetworkImgPath(bean?.picture),
                tag: bean?.picture,
              ),
            ),
          ),
          Container(
              height: 90,
              padding: EdgeInsets.only(left: 12.0),
              child: AspectRatio(
                aspectRatio: 2.8,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text.rich(TextSpan(
                            text: '${bean?.designName}\n',
                            style: TaojuwuTextStyle.TITLE_TEXT_STYLE,
                            children: [
                              TextSpan(
                                  text: '${bean?.name}',
                                  style: TaojuwuTextStyle.SUB_TITLE_TEXT_STYLE)
                            ])),
                      ),
                      Row(
                        children: [
                          Text(
                            '¥${bean?.totalPrice}',
                            style: TaojuwuTextStyle.RED_TEXT_STYLE,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '¥${bean?.marketPrice}',
                              style: TaojuwuTextStyle.GREY_TEXT_STYLE.copyWith(
                                  decoration: TextDecoration.lineThrough),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
