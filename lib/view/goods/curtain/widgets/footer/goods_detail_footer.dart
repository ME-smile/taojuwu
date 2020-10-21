/*
 * @Description: 商品底部操作栏 加入购物车 立即购买
 * @Author: iamsmiling
 * @Date: 2020-09-27 15:02:47
 * @LastEditTime: 2020-10-15 14:22:36
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_viewmodel.dart';

import 'purchase_actionbar.dart';

class GoodsDetailFooter extends StatelessWidget {
  final BaseGoodsViewModel baseGoodsViewModel;
  const GoodsDetailFooter(this.baseGoodsViewModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseGoodsViewModel>(
      builder: (BuildContext context, BaseGoodsViewModel viewmodel, _) {
        return PurchaseActionBar(baseGoodsViewModel);
      },
    );
  }
}
