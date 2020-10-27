/*
 * @Description: 所有成品商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:17:00
 * @LastEditTime: 2020-10-27 16:23:36
 */
import 'package:taojuwu/repository/shop/product/base/spec/product_spec_bean.dart';
import 'package:taojuwu/repository/shop/product_sku_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'abstract_base_end_product_bean.dart';

abstract class BaseEndProductBean extends AbstractBaseEndProductBean {
  List<ProductSpecBean> specList;
  BaseEndProductBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    specList = CommonKit.parseList(json['spec_list'])
        ?.map((e) => ProductSpecBean.fromJson(e))
        ?.toList();
  }

  ProductSkuBean get currentSkuBean =>
      skuList?.firstWhere((element) => element?.skuName == selectedOptionsName,
          orElse: () => null);

  int get skuId => currentSkuBean?.skuId;

  int get picId => currentSkuBean?.picId;

  String get mainImg => currentSkuBean?.image;

  String get selectedOptionsName =>
      specList?.map((e) => e?.selectedOptionsName)?.toList()?.join(' ');

  void selectSpecOption(ProductSpecBean spec, ProductSpecOptionBean option) {
    spec?.options?.forEach((el) {
      el?.isSelected = el == option;
    });
  }
}
