/*
 * @Description: 修改卷帘宽高ios对话框
 * @Author: iamsmiling
 * @Date: 2020-10-28 10:21:26
 * @LastEditTime: 2020-11-05 14:34:28
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/rolling_curtain_product_detail_bean.dart';

class EditRollingCurtainSizeIosView extends StatefulWidget {
  final RollingCurtainProductDetailBean bean;
  const EditRollingCurtainSizeIosView(this.bean, {Key key}) : super(key: key);

  @override
  _EditRollingCurtainSizeIosViewState createState() =>
      _EditRollingCurtainSizeIosViewState();
}

class _EditRollingCurtainSizeIosViewState
    extends State<EditRollingCurtainSizeIosView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('12345'),
    );
  }
}
