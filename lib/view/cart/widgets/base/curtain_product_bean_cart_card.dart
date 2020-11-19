/*
 * @Description: 购物车窗帘商品视图
 * @Author: iamsmiling
 * @Date: 2020-11-09 09:57:18
 * @LastEditTime: 2020-11-09 10:19:06
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class CurtainProductBeanCartCard extends StatefulWidget {
  final BaseCurtainProductDetailBean bean;
  CurtainProductBeanCartCard({Key key, this.bean}) : super(key: key);

  @override
  _CurtainProductBeanCartCardState createState() =>
      _CurtainProductBeanCartCardState();
}

class _CurtainProductBeanCartCardState
    extends State<CurtainProductBeanCartCard> {
  BaseCurtainProductDetailBean get bean => widget.bean;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      color: themeData.primaryColor,
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                  value: bean?.isChecked,
                  onChanged: (bool flag) {
                    setState(() {
                      bean?.isChecked = flag;
                    });
                  }),
              SizedBox(
                height: 90,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: ZYNetImage(
                    imgPath: bean?.cover,
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Text('${bean?.goodsName}'),
                      Text('¥${bean?.price}')
                    ],
                  )
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }
}
