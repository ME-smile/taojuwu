/*
 * @Description: 软装方案 场景 商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:20:43
 * @LastEditTime: 2020-11-13 09:36:12
 */

import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/multi_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';

abstract class AbstractDesignProductDetailBean extends MultiProductDetailBean {
  int id;
  String name;
  String desc;
  String room;
  String style;
  double totalPrice;
  double get marketPrice;
  String designName;
  String picture;
  String bigPicture;
  int picId;

  //  是否为混合商品 是否包含成品为主要依据
  bool get isMixinProduct {
    int curtainProductNum = 0;
    int endProductNum = 0;
    for (int i = 0; i < goodsList?.length ?? 0; i++) {
      SingleProductDetailBean item = goodsList[i];
      item.productType == ProductType.EndProductType
          ? endProductNum++
          : curtainProductNum++;
    }
    return curtainProductNum > 0 && endProductNum > 0;
  }
}
