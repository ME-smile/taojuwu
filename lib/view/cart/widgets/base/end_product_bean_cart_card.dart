/*
 * @Description: 成品购物车卡片
 * @Author: iamsmiling
 * @Date: 2020-11-09 10:11:26
 * @LastEditTime: 2020-11-09 10:13:24
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/end_product/base_end_product_detail_bean.dart';

class EndProductBeanCartCard extends StatefulWidget {
  final BaseEndProductDetailBean bean;
  EndProductBeanCartCard({Key key, this.bean}) : super(key: key);

  @override
  _EndProductBeanCartCardState createState() => _EndProductBeanCartCardState();
}

class _EndProductBeanCartCardState extends State<EndProductBeanCartCard> {
  BaseEndProductDetailBean get bean => widget.bean;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [Text(bean?.goodsName)],
      ),
    );
  }
}
