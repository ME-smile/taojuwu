/*
 * @Description: 提交订单 统统商品卡片样式
 * @Author: iamsmiling
 * @Date: 2020-10-28 14:24:58
 * @LastEditTime: 2020-11-06 15:33:53
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class CommonProductOrderCardHeader extends StatelessWidget {
  final SingleProductDetailBean bean;
  const CommonProductOrderCardHeader(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Visibility(
            visible: (bean is BaseCurtainProductDetailBean),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                (bean is BaseCurtainProductDetailBean)
                    ? (bean as BaseCurtainProductDetailBean)
                        ?.roomAttr
                        ?.selectedAttrName
                    : '',
                style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF333333),
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(
                height: 90,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ZYNetImage(
                    imgPath: bean?.cover,
                  ),
                ),
              ),
              Flexible(
                  child: Container(
                margin: EdgeInsets.only(left: 12),
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          bean?.goodsName ?? '',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1B1B1B)),
                        ),
                        Text(
                          '¥${bean?.price}',
                          style: TextStyle(
                              fontSize: 13, color: const Color(0xFF1B1B1B)),
                        )
                      ],
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(top: 6),
                      child: Text(
                        bean?.detailDescription ?? '',
                        style: TextStyle(
                            color: const Color(0xFF6D6D6D), fontSize: 13),
                      ),
                    ))
                  ],
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }
}
