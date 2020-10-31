/*
 * @Description: 软装方案 场景 商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:20:43
 * @LastEditTime: 2020-10-30 18:00:32
 */
import 'package:taojuwu/repository/shop/product/abstract/abstract_base_product_bean.dart';
import 'package:taojuwu/repository/shop/product/abstract/multi_product_bean.dart';
import 'package:taojuwu/repository/shop/product/abstract/single_product_bean.dart';

abstract class AbstractDesignProductBean extends MultiProductBean {
  int id;
  String name;
  String desc;
  String room;
  String style;
  double totalPrice;
  double get marketPrice;
  String designName;
  String picture;
  int picId;

  //  是否为混合商品 是否包含成品为主要依据
  bool get isMixinProduct {
    int curtainProductNum = 0;
    int endProductNum = 0;
    for (int i = 0; i < goodsList?.length ?? 0; i++) {
      SingleProductBean item = goodsList[i];
      item.productType == ProductType.EndProductType
          ? endProductNum++
          : curtainProductNum++;
    }
    return curtainProductNum > 0 && endProductNum > 0;
  }
}
