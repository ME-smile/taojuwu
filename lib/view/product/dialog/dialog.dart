/*
 * @Description: 卷帘商品修改 宽高
 * @Author: iamsmiling
 * @Date: 2020-10-28 10:19:33
 * @LastEditTime: 2020-11-12 17:37:54
 */
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/providers/theme_provider.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/design/base_design_product_detail_bean.dart';
import 'package:taojuwu/view/product/dialog/widgets/edit_curtain_deltaY_android_view.dart';
import 'package:taojuwu/view/product/dialog/widgets/edit_rolling_curtain_size_android_view.dart';

import 'widgets/cofirm_curtain_measure_data_view.dart';
import 'widgets/edit_curtain_deltaY_ios_view.dart';

Future setSize(BuildContext ctx, BaseProductDetailBean bean) {
  return showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          title: Text.rich(
            TextSpan(text: '请输入尺寸（cm)\n', children: [
              TextSpan(
                  text: '不足1㎡按1㎡计算',
                  style:
                      TextStyle(color: TaojuwuColors.GREY_COLOR, fontSize: 15)),
            ]),
            textAlign: TextAlign.center,
          ),
          content: EditRollingCurtainSizeAndroidView(bean),
        );
      });
  // if (Platform.isAndroid) {
  //   return showDialog(
  //       context: ctx,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(8))),
  //           title: Text.rich(
  //             TextSpan(text: '请输入尺寸（cm)\n', children: [
  //               TextSpan(
  //                   text: '不足1㎡按1㎡计算',
  //                   style: Theme.of(context).textTheme.bodyText2),
  //             ]),
  //             textAlign: TextAlign.center,
  //           ),
  //           content: EditRollingCurtainSizeAndroidView(bean),
  //         );
  //       });
  // } else {
  //   return showCupertinoDialog(
  //       context: ctx,
  //       builder: (BuildContext context) {
  //         return CupertinoAlertDialog(
  //           title: Text.rich(TextSpan(text: '请输入尺寸（cm)\n', children: [
  //             TextSpan(
  //                 text: '不足1㎡按1㎡计算',
  //                 style: Theme.of(context).textTheme.bodyText2),
  //           ])),
  //           content: EditRollingCurtainSizeIosView(bean),
  //           actions: <Widget>[
  //             CupertinoDialogAction(
  //               child: Text('取消'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             CupertinoDialogAction(
  //               child: Text('确定'),
  //               onPressed: () {
  //                 // saveSize(goodsProvider);
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }
}

Future setDeltaY(BuildContext context, BaseCurtainProductDetailBean bean) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return EditCurtainDeltaYAndroidView(bean);
        });
  }
  return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return EditCurtainDeltaYIosView(bean);
      });
}

Future confirmCurtainMeasureData(
    BuildContext context, BaseDesignProductDetailBean bean,
    {FutureCallback callback}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: CorfirmCurtainMeasureDataView(
            count: bean?.useDefaultSizeCurtainCount,
            callback: callback,
          ),
        );
      });
}
