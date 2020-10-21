/*
 * @Description: 窗帘单价格计算
 * @Author: iamsmiling
 * @Date: 2020-10-21 11:11:48
 * @LastEditTime: 2020-10-21 14:48:02
 */
import 'package:taojuwu/repository/shop/product/curtain/fabric_curtain_product_bean.dart';

import 'curtain_product_price_caculate_delegator.dart';

class FabricCurtainProductPriceCaculator
    extends CurtainProductPriceCaculateDelegator {
  FabricCurtainProductPriceCaculator(FabricCurtainProductBean bean) {
    productBean = bean;
  }

  @override
  // TODO: implement totalPrice
  double get totalPrice => throw UnimplementedError();
}
