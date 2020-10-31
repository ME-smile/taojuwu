/*
 * @Description: 提交订单 统统商品卡片样式
 * @Author: iamsmiling
 * @Date: 2020-10-28 14:24:58
 * @LastEditTime: 2020-10-29 15:01:51
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class CommonProductOrderCardHeader extends StatelessWidget {
  final SingleProductBean bean;
  const CommonProductOrderCardHeader(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
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
                        Text(bean?.goodsName ?? ''),
                        Text('${bean?.price}')
                      ],
                    ),
                    Expanded(
                        child: Text(
                      bean?.detailDescription ?? '',
                    ))
                  ],
                ),
              ))
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width,
            child: Text.rich(TextSpan(
                text: '小计', children: [TextSpan(text: '${bean?.totalPrice}')])),
          )
        ],
      ),
    );
  }
}
