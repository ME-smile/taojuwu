/*
 * @Description: 成品属性选择栏目
 * @Author: iamsmiling
 * @Date: 2020-10-28 15:41:54
 * @LastEditTime: 2020-11-12 16:14:58
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/product_detail/end_product/base_end_product_detail_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/view/product/popup_modal/pop_up_modal.dart';

class EndProductAttrActionBar extends StatelessWidget {
  final BaseEndProductDetailBean bean;
  final StateSetter setState;
  const EndProductAttrActionBar({Key key, this.bean, this.setState})
      : super(key: key);

  Future selectSpec() {
    List<bool> list = bean?.selectSpec();

    if (CommonKit.isNullOrEmpty(list)) {
      return Future.value(true);
    }
    bool flag = list?.reduce((a, b) => a && b);
    if (flag) {
      bean?.hasSelectedSpec = true;
      return Future.value(true);
    }
    throw Exception('请选择商品规格');
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return SliverToBoxAdapter(
      child: Container(
        color: themeData.primaryColor,
        // margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        // padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                          text: '选择',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                          children: [
                            WidgetSpan(
                                child: SizedBox(
                              width: 10,
                            )),
                            TextSpan(
                              text: bean?.hasSelectedSpec == false
                                  ? '${bean?.specName}'
                                  : '已选${bean?.selectedOptionsName}',
                            )
                          ]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Visibility(
                      visible: bean.colorSpecCount > 1,
                      child: Container(
                        child: Row(
                          children: [
                            Text('选择',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.transparent)),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F9),
                                  borderRadius: BorderRadius.circular(4)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Text('共${bean?.colorSpecCount}种颜色分类可选',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: const Color(0xFF999999))),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showEndProductDetailModalPopup(context, bean,
                        callback: selectSpec)
                    .whenComplete(() {
                  setState(() {});
                });
                // selectAttrOption(provider, () {
                //   Navigator.of(context).pop();
                // }, shouldPop: false);
              },
              child: Icon(
                ZYIcon.three_dot,
                color: Colors.black,
                size: 28,
              ),
            )
          ],
        ),
      ),
    );
  }
}
