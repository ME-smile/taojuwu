/*
 * @Description: 窗帘属性状态
 * @Author: iamsmiling
 * @Date: 2020-10-31 06:34:24
 * @LastEditTime: 2020-10-31 07:19:29
 */
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';

class ProductAttrHolder {
  static List<ProductSkuAttr> _attrList = []; // 窗纱 工艺方式 型材 里布 幔头 配饰等属性
  static ProductSkuAttr _roomAttr;

  List<ProductSkuAttr> get attrList => _attrList;
  set attrList(List<ProductSkuAttr> list) {
    _attrList = list;
    print(list);
  }

  ProductSkuAttr get roomAttr => _roomAttr;

  set roomAttr(ProductSkuAttr attr) {
    _roomAttr = attr;
    print(attr);
  }

  static List<ProductSkuAttr> copy() {
    return _attrList?.map((e) => ProductSkuAttr.fromJson(e?.toMap()))?.toList();
  }
}
