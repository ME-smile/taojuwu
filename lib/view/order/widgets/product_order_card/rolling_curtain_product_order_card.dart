/*
 * @Description: 提交订单 卷帘视图
 * @Author: iamsmiling
 * @Date: 2020-10-28 13:38:36
 * @LastEditTime: 2020-11-06 15:52:29
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/rolling_curtain_product_detail_bean.dart';
import 'package:taojuwu/view/order/widgets/product_order_card/common_prodcut_order_card_header.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

class RollingCurtainProductOrderCard extends StatelessWidget {
  final RollingCurtainProductDetailBean bean;
  const RollingCurtainProductOrderCard(this.bean, {Key key}) : super(key: key);

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
            padding: EdgeInsets.only(right: 16, top: 12),
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
          ),
          Container(
              padding: EdgeInsets.only(bottom: 16, right: 16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 12,
                      padding: EdgeInsets.only(top: 2, right: 2),
                      alignment: Alignment.center,
                      child: ZYAssetImage('exclamatory_mark.png',
                          width: 10, height: 10),
                    ),
                    Text(
                      '预估价格',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    )
                  ]))
          // CurtainProductAttrsCardView(bean),
        ],
      ),
    );
  }
}
