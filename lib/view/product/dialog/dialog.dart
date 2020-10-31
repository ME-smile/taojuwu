/*
 * @Description: 卷帘商品修改 宽高
 * @Author: iamsmiling
 * @Date: 2020-10-28 10:19:33
 * @LastEditTime: 2020-10-28 11:11:28
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/providers/theme_provider.dart';
import 'package:taojuwu/repository/shop/product/abstract/base_product_bean.dart';
import 'package:taojuwu/view/product/dialog/widgets/edit_rolling_curtain_size_android_view.dart';

Future setSize(BuildContext ctx, BaseProductBean bean) {
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
