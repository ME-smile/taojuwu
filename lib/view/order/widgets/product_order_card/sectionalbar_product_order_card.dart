/*
 * @Description:  型材
 * @Author: iamsmiling
 * @Date: 2020-12-29 15:47:38
 * @LastEditTime: 2020-12-29 16:12:47
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/end_product/base_end_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/end_product/sectional_product_detail_bean.dart';

import 'common_prodcut_order_card_header.dart';

class SectionalbarProductOrderCard extends StatelessWidget {
  final SectionalProductDetailBean bean;
  const SectionalbarProductOrderCard({Key key, this.bean}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          CommonProductOrderCardHeader(bean),
          Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(right: 16, top: 12, bottom: 12),
            child: Text.rich(TextSpan(
                text: '小计:',
                style: TextStyle(
                    color: const Color(0xFF1B1B1B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                children: [
                  TextSpan(
                    text: '¥${bean?.totalPrice?.toStringAsFixed(2)}',
                  )
                ])),
          )
        ],
      ),
    );
  }
}
