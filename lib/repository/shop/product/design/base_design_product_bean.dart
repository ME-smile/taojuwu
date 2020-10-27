/*
 * @Description: 软装方案 场景设计商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:22:16
 * @LastEditTime: 2020-10-27 17:02:06
 */

import 'package:taojuwu/repository/shop/product/curtain/fabric_curtain_product_bean.dart';
import 'package:taojuwu/repository/shop/product/design/abstract_base_design_product_bean.dart';
import 'package:taojuwu/repository/shop/product/end_product/concrete_end_product_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';

class BaseDesignProductBean extends AbstractDesignProductBean {
  BaseDesignProductBean.fromJson(Map<String, dynamic> json) {
    id = json['scenes_id'];
    name = json['name'];
    designName = json['scenes_name'];
    picture = json['image'];
    room = json['space'];
    style = json['style'];
    desc = json['scenes_detail'];
    goodsList = CommonKit.parseList(json['goods_list'])?.map((e) {
      int type = e['goods_type'];
      return type == 0
          ? ConcreteEndProductBean.fromJson(e)
          : FabricCurtainProductBean.fromJson(e);
      // if (e['goods_type'] == 0) {}
    })?.toList();
    totalPrice = CommonKit.parseDouble(json['total_price']);
  }

  @override
  double get marketPrice {
    double tmp = 0.0;
    if (!CommonKit.isNullOrEmpty(goodsList)) {
      goodsList?.forEach((element) {
        tmp += element?.marketPrice;
      });
      return tmp;
    }
    return tmp;
  }

  @override
  Future addToCart() {
    Map<String, dynamic> params = {'client_uid': 395, 'cart_list': "$cartArgs"};
    print(params);
    // OTPService.addCartList(params).then((ZYResponse response) {
    //   if (response?.valid == true) {
    //     print('加入购物车成功');
    //   }
    // }).whenComplete(() {});
  }

  @override
  Future buy() {
    // TODO: implement buy
    throw UnimplementedError();
  }

  @override
  // TODO: implement attrArgs
  Map get attrArgs => throw UnimplementedError();

  @override
  get cartArgs =>
      goodsList
          ?.map((e) => {'cart_tag': 'app', 'cart_detail': e?.cartArgs})
          ?.toList() ??
      [];
}
