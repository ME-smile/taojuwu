/*
 * @Description: 所有窗帘类的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:11:06
 * @LastEditTime: 2020-10-21 15:43:48
 */
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';

import 'abstract_curtain_product_bean.dart';

class BaseCurtainProductBean extends AbstractCurtainProductBean {
  double width; //宽度
  double height; // 高度
  double deltaY; // 离地距离

  List<ProductSkuAttr> attrList; // 窗纱 工艺方式 型材 里布 幔头 配饰等属性
  ProductSkuAttr roomAttr;

  BaseCurtainProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json); //空间属性
}
