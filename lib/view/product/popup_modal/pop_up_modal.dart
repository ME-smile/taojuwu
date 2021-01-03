/*
 * @Description: //选择属性
 * @Author: iamsmiling
 * @Date: 2020-10-22 10:36:14
 * @LastEditTime: 2020-12-31 15:54:08
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';

import 'package:taojuwu/repository/shop/product_detail/end_product/base_end_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/view/goods/curtain/widgets/sku_attr_picker.dart';
import 'package:taojuwu/view/product/popup_modal/widgets/common_attr_option_view.dart';
import 'package:taojuwu/view/product/popup_modal/widgets/end_product_detail_modal.dart';

import 'package:taojuwu/view/product/popup_modal/widgets/room_attr_option_view.dart';
import 'package:taojuwu/view/product/popup_modal/widgets/sectionalbar_prodcut_detail_modal.dart';

import 'package:taojuwu/widgets/product_grid_card.dart';

import 'widgets/design_product_detail_modal.dart';

//选择属性的弹窗
Future pickAttr(
    BuildContext ctx, BaseCurtainProductDetailBean bean, ProductSkuAttr attr) {
  return showCupertinoModalPopup(
      context: ctx,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return WillPopScope(
              child: SkuAttrPicker(
                title: attr?.title,
                callback: () {
                  // refresh();
                  // viewModel.refresh();
                  Navigator.of(context).pop();
                },
                child: attr?.type == 1
                    ? RoomAttrOptionView(bean, attr)
                    : CommonAttrOptionView(
                        bean,
                        attr,
                      ),
              ),
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

Future showRelativeProductModalPopup(
    BuildContext context, List<SingleProductDetailBean> goodsList) {
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return SkuAttrPicker(
          title: '搭配精选',
          height: UIKit.height(1000),
          showButton: false,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 8),
                itemCount: goodsList != null && goodsList.isNotEmpty
                    ? goodsList.length
                    : 0,
                itemBuilder: (BuildContext context, int i) {
                  return ProductGridCard(goodsList[i]);
                }),
          ),
        );
      });
}

//软装方案详情
Future showDesignProductDetailModal(BuildContext ctx, int id) {
  return showCupertinoModalPopup(
      context: ctx,
      builder: (BuildContext context) {
        return SkuAttrPicker(
            height: UIKit.height(1000),
            showButton: false,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: DesignProductDetailModal(id),
            ));
      });
}

//成品详情弹窗

typedef FutureCallback = Future Function();
Future showEndProductDetailModalPopup(
    BuildContext ctx, BaseEndProductDetailBean bean,
    {FutureCallback callback}) {
  return showCupertinoModalPopup(
      context: ctx,
      builder: (BuildContext context) {
        return SkuAttrPicker(
          height: UIKit.height(900),
          callback: () {
            if (callback != null) {
              callback().then((value) {
                bean.addToCartRequest(context: ctx);
              });
            } else {
              Navigator.of(context).pop();
            }
          },
          child: EndProductDetailModal(bean),
        );
      });
}

///型材弹窗
Future showSectionalbarProductDetailModalPopup(
    BuildContext ctx, BaseEndProductDetailBean bean,
    {FutureCallback callback}) {
  return showCupertinoModalPopup(
      context: ctx,
      builder: (BuildContext context) {
        return SkuAttrPicker(
          height: UIKit.height(900),
          showButton: true,
          callback: () {
            if (callback != null) {
              callback().then((value) {
                Navigator.of(context).pop();
              });
            } else {
              Navigator.of(context).pop();
            }
          },
          child: SectionalbarProductDetailModal(bean),
        );
      });
}
