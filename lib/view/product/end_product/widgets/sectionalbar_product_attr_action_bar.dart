/*
 * @Description: 型材属性选择
 * @Author: iamsmiling
 * @Date: 2020-12-28 11:16:52
 * @LastEditTime: 2020-12-29 15:36:44
 */

import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/product_detail/end_product/sectional_product_detail_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/view/product/popup_modal/pop_up_modal.dart';

class SectionalbarProductAttrBar extends StatefulWidget {
  final SectionalProductDetailBean bean;
  const SectionalbarProductAttrBar({Key key, this.bean}) : super(key: key);

  @override
  _SectionalbarProductAttrBarState createState() =>
      _SectionalbarProductAttrBarState();
}

class _SectionalbarProductAttrBarState
    extends State<SectionalbarProductAttrBar> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          showSectionalbarProductDetailModalPopup(context, widget.bean,
              callback: () => widget.bean.addToCart(context)).whenComplete(() {
            setState(() {});
          });
          // selectAttrOption(provider, () {
          //   Navigator.of(context).pop();
          // }, shouldPop: false);
        },
        child: Container(
          color: Theme.of(context).primaryColor,
          // margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                    text: '选择',
                    style:
                        TextStyle(color: const Color(0xFF999999), fontSize: 14),
                    children: [
                      WidgetSpan(
                          child: SizedBox(
                        width: 10,
                      )),
                      TextSpan(
                          text: CommonKit.isNumNullOrZero(widget.bean.width)
                              ? ''
                              : '已选:${widget.bean.selectedOptionsName}米',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF333333),
                          ))
                    ]),
              ),
              Icon(
                ZYIcon.three_dot,
                color: Colors.black,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
