/*
 * @Description: //选择属性
 * @Author: iamsmiling
 * @Date: 2020-10-22 10:36:14
 * @LastEditTime: 2020-10-26 10:51:54
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/curtain/base_curtain_product_bean.dart';

import 'package:taojuwu/repository/shop/product/design/base_design_product_bean.dart';
import 'package:taojuwu/repository/shop/product/relative_product/relative_product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/sku_attr_picker.dart';
import 'package:taojuwu/view/product/popup_modal/widgets/common_attr_option_view.dart';

import 'package:taojuwu/view/product/popup_modal/widgets/room_attr_option_view.dart';

import 'package:taojuwu/viewmodel/product/base/provider/base_product_provider.dart';
import 'package:taojuwu/widgets/product_grid_card.dart';

import 'widgets/soft_design_product_detail_modal.dart';

//选择属性的弹窗
Future pickAttr(
    BuildContext ctx, BaseCurtainProductBean bean, ProductSkuAttr attr) {
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
                    : CommonAttrOptionView(bean, attr?.data),
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
    BuildContext context, List<RelativeProductBean> goodsList) {
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return SkuAttrPicker(
          title: '同料商品',
          height: 720,
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
Future showSoftDesignDetailModalPopup(BuildContext ctx,
    BaseDesignProductBean bean, BaseProductProvider provider) {
  return showCupertinoModalPopup(
      context: ctx,
      builder: (BuildContext context) {
        return SkuAttrPicker(
            height: 720,
            showButton: false,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: SoftDesignProductDetailModal(provider),
            ));
      });
}
