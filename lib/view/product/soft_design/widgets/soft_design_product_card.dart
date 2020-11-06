/*
 * @Description: 软装方案卡片布局
 * @Author: iamsmiling
 * @Date: 2020-10-23 10:37:53
 * @LastEditTime: 2020-11-06 10:54:13
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/repository/shop/product_detail/design/soft_design_product_detail_bean.dart';
import 'package:taojuwu/view/product/popup_modal/pop_up_modal.dart';
import 'package:taojuwu/widgets/relative_product_card.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

import 'package:taojuwu/utils/extensions/object_kit.dart';

class SoftDesignProductCard extends StatelessWidget {
  final SoftDesignProductDetailBean bean;
  const SoftDesignProductCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDesignProductDetailModal(context, bean?.id),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            ZYNetImage(
              imgPath: bean.picture,
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    bean?.designName ?? '',
                    style: TaojuwuTextStyle.EMPHASIS_TEXT_STYLE_BOLD,
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        bean?.name ?? '',
                        style: TaojuwuTextStyle.EMPHASIS_TEXT_STYLE,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                bean?.desc ?? '',
                textAlign: TextAlign.left,
                style: TaojuwuTextStyle.SUB_TEXT_STYLE,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '¥${bean?.totalPrice}',
                  style: TaojuwuTextStyle.RED_TEXT_STYLE,
                ),
                ZYRaisedButton(
                  '立即购买',
                  () {
                    return showDesignProductDetailModal(context, bean?.id);
                    // showSoftProjectPopupWindow(context,
                    //     Provider.of(context, listen: false), bean.scenesId);
                  },
                  horizontalPadding: 16,
                  verticalPadding: 7.2,
                )
              ],
            ),
            Divider(
              thickness: 1,
              color: const Color(0xFFF1F1F1),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                '包含商品',
                textAlign: TextAlign.left,
              ),
            ),
            Visibility(
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (BuildContext context, int i) {
                      return RelativeProductCard(bean?.goodsList[i]);
                    },
                    itemCount: bean.goodsList.length,
                  ),
                ),
                visible: !isNullOrEmpty(bean?.goodsList))
          ],
        ),
      ),
    );
  }
}
