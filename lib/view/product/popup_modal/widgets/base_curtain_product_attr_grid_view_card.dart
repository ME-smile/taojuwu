/*
 * @Description: 窗帘商品 属性 视图
 * @Author: iamsmiling
 * @Date: 2020-10-28 09:41:14
 * @LastEditTime: 2020-11-05 13:26:17
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/providers/theme_provider.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/edit_product_attr/edit_product_attr_page.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';

class BaseCurtainProductAttrGridViewCard extends StatelessWidget {
  final BaseCurtainProductDetailBean bean;
  final StateSetter setState;
  const BaseCurtainProductAttrGridViewCard(this.bean, this.setState, {Key key})
      : super(key: key);

  List<ProductSkuAttr> get attrList => bean?.attrList ?? [];
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: attrList?.isNotEmpty == true,
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleTip(
                    title: '属性',
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          CupertinoPageRoute(builder: (BuildContext context) {
                        return EditCurtainProductAttrPage(bean);
                      })).whenComplete(() {
                        setState(() {});
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          '修改属性',
                          style: TaojuwuTextStyle.YELLOW_TEXT_STYLE,
                        ),
                        Icon(
                          ZYIcon.next,
                          color: TaojuwuColors.YELLOW_COLOR,
                          size: 14,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 8),
              itemBuilder: (BuildContext context, int index) {
                ProductSkuAttr item = attrList[index];
                return Text(
                  '${item?.name ?? ''}:${item?.selectedAttrName ?? ''}',
                  style: TaojuwuTextStyle.GREY_TEXT_STYLE,
                );
              },
              itemCount: attrList?.length ?? 0,
            )
          ],
        ),
      ),
    );
  }
}
