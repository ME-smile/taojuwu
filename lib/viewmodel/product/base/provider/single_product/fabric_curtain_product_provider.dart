/*
 * @Description: 布艺帘
 * @Author: iamsmiling
 * @Date: 2020-10-21 10:55:56
 * @LastEditTime: 2020-10-21 16:06:32
 */

import 'package:taojuwu/repository/shop/product/curtain/fabric_curtain_product_bean.dart';
import 'package:taojuwu/viewmodel/product/base/provider/single_product/base_curtain_product_provider.dart';

class FabricCurtainProductProvider extends BaseCurtainProductProvider {
  FabricCurtainProductProvider(FabricCurtainProductBean bean) {
    productBean = bean;
  }
}
