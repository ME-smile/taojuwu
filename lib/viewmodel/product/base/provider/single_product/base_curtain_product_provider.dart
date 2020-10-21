/*
 * @Description: 布艺帘商品
 * @Author: iamsmiling
 * @Date: 2020-10-21 10:44:24
 * @LastEditTime: 2020-10-21 16:24:15
 */
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/product/curtain/base_curtain_product_bean.dart';
import 'package:taojuwu/viewmodel/product/base/provider/single_product/single_product_provider.dart';

abstract class BaseCurtainProductProvider extends SingleProductProvider {
  OrderGoodsMeasureData measure;

  BaseCurtainProductBean get baseCurtainProductBean =>
      (productBean as BaseCurtainProductBean);
}
