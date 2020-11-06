/*
 * @Description: 属性选泽
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-10-28 17:52:31
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/view/product/popup_modal/widgets/curtain_product_bean_common_attr_modal.dart';
import 'package:taojuwu/view/product/popup_modal/widgets/curtain_product_bean_room_attr_modal.dart';

import '../sku_attr_picker.dart';

/*
 * @Author: iamsmiling
 * @description: 为什么使用statefulwidget ---> 使用selector必须是不可变类型，不然页面无法刷新
 * @param : 
 * @return {type} 
 * @Date: 2020-09-29 10:13:16
 */
class AttrOptionsBar extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  final int index; // 在skulist中的索引位置
  final ProductSkuAttr skuAttr;
  final Function callback;
  const AttrOptionsBar(this.bean, this.skuAttr,
      {Key key, this.callback, this.index = 0})
      : super(key: key);

  @override
  _AttrOptionsBarState createState() => _AttrOptionsBarState();
}

class _AttrOptionsBarState extends State<AttrOptionsBar> {
  BaseCurtainProductDetailBean get bean => widget.bean;
  bool get isVisible => ![1, 2].contains(skuAttr.type);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // FocusManager.instance.primaryFocus.unfocus();
        // callback();
        pickAttr(context);
      },
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: UIKit.height(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                widget.skuAttr?.name ?? '',
                style: TextStyle(color: const Color(0xFF333333), fontSize: 14),
              ),
              flex: 1,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    widget.skuAttr.selectedAttrName,
                    style: TextStyle(fontSize: 14, color: Color(0xFF1B1B1B)),
                  ),
                  Icon(
                    ZYIcon.next,
                    size: 20,
                  )
                ],
              ),
              flex: 4,
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }

  ProductSkuAttr get skuAttr => widget.skuAttr;

  Future pickAttr(BuildContext ctx) {
    return showCupertinoModalPopup(
        context: ctx,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return WillPopScope(
                child: SkuAttrPicker(
                    title: widget.skuAttr.title,
                    callback: () {
                      refresh();
                      Navigator.of(context).pop();
                    },
                    child: skuAttr.type == 1
                        ? CurtainProductDetailBeanRoomAttrModal(bean)
                        : CurtainProductDetailBeanCommonAttrModal(
                            bean, skuAttr)),
                onWillPop: () {
                  // if (!skuAttr.hasSelectedAttr) {
                  //   (viewModel as CurtainViewModel).resetAttr();
                  // }

                  Navigator.of(context).pop();
                  return Future.value(false);
                });
          });
        });
  }
}
