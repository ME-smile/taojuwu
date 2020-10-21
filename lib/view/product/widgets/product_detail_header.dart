/*
 * @Description: //商品详情顶部appbar
 * @Author: iamsmiling
 * @Date: 2020-10-21 16:10:17
 * @LastEditTime: 2020-10-21 17:17:57
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';
import 'package:taojuwu/widgets/user_choose_button.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class ProductDetailHeader extends StatelessWidget {
  final SingleProductBean bean;
  const ProductDetailHeader(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: [
        UserChooseButton(),
      ],
      expandedHeight: 320,
      elevation: .5,
      floating: false,
      pinned: true,
      // flexibleSpace: ,
    );
  }

  FlexibleSpaceBar _buildBanner() {
    return FlexibleSpaceBar(
      background: Container(
          margin: EdgeInsets.only(top: 80),
          child: ZYNetImage(
            imgPath: bean?.picCoverMicro,
            width: 300,
            height: 240,
            needAnimation: false,
          )),
    );
  }
}
