/*
 * @Description: 软装方案卡片
 * @Author: iamsmiling
 * @Date: 2020-10-10 15:19:46
 * @LastEditTime: 2020-11-04 11:03:31
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/view/goods/curtain/widgets/popup_window/soft_project_popup_window.dart';
import 'package:taojuwu/view/goods/curtain/widgets/section/related_goods_section_view.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class SoftProjectCard extends StatelessWidget {
  final SoftProjectBean bean;
  const SoftProjectCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  bean?.scenesName ?? '',
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
              bean?.goodsDetail ?? '',
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
                  showSoftProjectPopupWindow(context,
                      Provider.of(context, listen: false), bean.scenesId);
                },
                horizontalPadding: 12,
                verticalPadding: 7.2,
              )
            ],
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
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (BuildContext context, int i) {
                    return RelatedGoodsCard(bean.goodsList[i]);
                  },
                  itemCount: bean.goodsList.length,
                ),
              ),
              visible: !CommonKit.isNullOrEmpty(bean.goodsList))
        ],
      ),
    );
  }
}
