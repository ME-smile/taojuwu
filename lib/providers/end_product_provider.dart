import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taojuwu/models/shop/product_bean.dart';
import 'package:taojuwu/models/shop/sku_bean.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/common_kit.dart';

class EndProductProvider with ChangeNotifier {
  ProductBean _goods;

  EndProductProvider(ProductBean bean) : _goods = bean;
  ProductBean get goods => _goods;

  int _cartCount = 0;

  int get cartCount => _cartCount;

  set cartCount(int n) {
    _cartCount = n;
    notifyListeners();
  }

  bool get isWindowRoller => goods?.goodsSpecialType == 2;

  String get unit => isWindowRoller ? '元/平方米' : '元/米';

  List<ProductBeanGoodsImageBean> get goodsImgList => _goods?.goodsImgList;

  List<ProductBeanSpecListBean> get specList {
    List<ProductBeanSpecListBean> list = [
      ProductBeanSpecListBean.fromMap({'spec_name': '数量'})
    ];
    list.addAll(goods?.specList);
    return list;
  }

  List<SkuBean> get skuList => _goods?.skuList;

  int get skuId => goods?.skuId;

  bool canAddToCart = true;

  SkuBean get curSkubean {
    return skuList?.firstWhere((element) => element?.skuId == skuId);
  }

  int get count => curSkubean?.count;
  double get price => double.parse(curSkubean?.price);
  double get totalPrice => price * count;
  set skuId(int id) {
    _goods?.skuId = id;
    notifyListeners();
  }

  String get checkedAttrText {
    List<String> options = [];
    specList?.forEach((element) {
      element?.value?.forEach((item) {
        if (item?.selected == true) {
          options?.add(item?.specValueName);
        }
      });
    });
    return options?.join(' ');
  }

  String get checkedOptionsValueStr {
    List<String> options = [];
    specList?.forEach((element) {
      element?.value?.forEach((item) {
        if (item?.selected == true) {
          options?.add('${element?.specId ?? ''}:${item?.specValueId ?? ''}');
        }
      });
    });
    return options?.join(';');
  }

  bool beforePurchase(BuildContext context) {
    // setParams(goodsProvider);

    if (TargetClient.instance.hasSelectedClient == false) {
      CommonKit.showInfo('请选择客户');
      return false;
    }

    // if (isValidateData == false) {
    //   return false;
    // }
    return true;
  }

  Map<String, dynamic> get cartDetail {
    return {
      'sku_id': '${goods?.skuId}' ?? '',
      'goods_id': '${goods?.goodsId}' ?? '',
      'goods_name': '${goods?.goodsName}' ?? '',
      'shop_id': '${goods?.shopId}' ?? '',
      'picture': '${goods?.picture}' ?? '',
      'num': '$count'
    };
  }

  void addCart(
    BuildContext context,
  ) {
    if (!beforePurchase(context)) return;

    canAddToCart = false;

    Map<String, dynamic> cartParams = {
      'client_uid': TargetClient.instance.clientId,
      'cart_detail': jsonEncode(cartDetail),
      'estimated_price': totalPrice,
      // 'wc_attr': jsonEncode(attrArgs),
      // 'cart_detail': jsonEncode(cartDetail),
      // 'measure_id': measureId,
      // 'estimated_price': totalPrice,
      // 'is_shade': isShade == true ? 1 : 0
    };
    OTPService.addCart(params: cartParams)
        .then((ZYResponse response) {
          if (response?.valid == true) {
            cartCount = response?.data;
            print(response?.data);
          }
        })
        .catchError((err) => err)
        .whenComplete(() {
          canAddToCart = true;
        });
  }

  Future createOrder(BuildContext context) async {
    if (!beforePurchase(context)) return;

    RouteHandler.goCommitOrderPage(context,
        params: jsonEncode({
          'data': [
            {
              'tag': goods?.goodsName ?? '',
              'img': curSkubean?.coverUrl ?? '',
              'goods_name': goods?.goodsName,
              'price': goods?.price,
              'desc': checkedAttrText,
              'sku_id': goods?.skuId,
              'goods_id': goods?.goodsId ?? '',
              'total_price': totalPrice ?? 0.0,
              'count': count,
              'is_endproduct': true,
              'goods_attrs': jsonEncode([])
            }
          ],
        }));
  }
}
