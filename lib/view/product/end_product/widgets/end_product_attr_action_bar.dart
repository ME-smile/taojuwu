/*
 * @Description: 成品属性选择栏目
 * @Author: iamsmiling
 * @Date: 2020-10-28 15:41:54
 * @LastEditTime: 2020-11-04 11:13:20
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/product_detail/end_product/base_end_product_detail_bean.dart';
import 'package:taojuwu/view/product/popup_modal/pop_up_modal.dart';

class EndProductAttrActionBar extends StatelessWidget {
  final BaseEndProductDetailBean bean;
  final StateSetter setState;
  const EndProductAttrActionBar({Key key, this.bean, this.setState})
      : super(key: key);

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
              child: Text.rich(
                TextSpan(
                    text: '已选',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    children: [
                      WidgetSpan(
                          child: SizedBox(
                        width: 10,
                      )),
                      TextSpan(
                        text: bean?.selectedOptionsName ?? '请选择商品规格',
                      )
                    ]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () {
                showEndProductDetailModalPopup(
                  context,
                  bean,
                ).whenComplete(() {
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
