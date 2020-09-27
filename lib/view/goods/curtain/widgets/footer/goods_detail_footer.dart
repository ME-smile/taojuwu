/*
 * @Description: 商品底部操作栏 加入购物车 立即购买
 * @Author: iamsmiling
 * @Date: 2020-09-27 15:02:47
 * @LastEditTime: 2020-09-27 15:30:14
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/viewmodel/goods/binding/base_goods_binding.dart';

import 'package:taojuwu/viewmodel/goods/curtain_viewmodel.dart';

import 'purchase_actionbar.dart';

class GoodsDetailFooter extends StatelessWidget {
  final BaseGoodsBinding baseGoodsBinding;
  const GoodsDetailFooter(this.baseGoodsBinding, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CurtainViewModel>(
      builder: (BuildContext context, CurtainViewModel viewmodel, _) {
        return PurchaseActionBar(baseGoodsBinding);
      },
    );
  }
}
