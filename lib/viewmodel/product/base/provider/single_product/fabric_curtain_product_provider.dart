/*
 * @Description: 布艺帘
 * @Author: iamsmiling
 * @Date: 2020-10-21 10:55:56
 * @LastEditTime: 2020-10-27 14:01:34
 */

import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/product/curtain/fabric_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/viewmodel/product/base/provider/single_product/base_curtain_product_provider.dart';

class FabricCurtainProductProvider extends BaseCurtainProductProvider {
  FabricCurtainProductBean get fabricCurtainProductBean =>
      (productBean as FabricCurtainProductBean);
  List<ProductSkuAttr> get attrList => fabricCurtainProductBean?.attrList;
  OrderGoodsMeasureData get measureData =>
      fabricCurtainProductBean?.measureData;
  FabricCurtainProductProvider(FabricCurtainProductBean bean) {
    productBean = bean;

    // _fetchAttrsData();
  }
  // // 获取属性相关的数据
  // Future _fetchAttrsData() async {
  //   List<int> args = [3, 4, 5, 8, 12, 13];
  //   List<Future<ProductSkuAttrWrapperResp>> futures = args
  //       .map((e) => OTPService.skuAttr(context, params: {
  //             'parts_type': measureData?.partsType,
  //             'goods_id': goodsId,
  //             'type': e
  //           }).then((ProductSkuAttrWrapperResp response) {
  //             if (response?.valid == true) {
  //               attrList?.add(response?.data);
  //             }
  //           }).catchError((err) => err))
  //       .toList();
  //   await Future.wait(futures);
  //   attrList?.sort((ProductSkuAttr a, ProductSkuAttr b) => a.type - b.type);
  //   refresh();
  // }
}
