import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/cart_list_model.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/repository/shop/product_sku_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/toast_kit.dart';

class EndProductProvider with ChangeNotifier {
  ProductDetailBean _goods;

  EndProductProvider(ProductDetailBean bean) : _goods = bean;
  ProductDetailBean get goods => _goods;

  int _cartCount = 0;

  int get cartCount => _cartCount;

  set cartCount(int n) {
    _cartCount = n;
    notifyListeners();
  }

  bool get isWindowRoller => goods?.goodsSpecialType == 2;

  String get unit => isWindowRoller ? '元/平方米' : '元/米';

  List<ProductDetailBeanGoodsImageBean> get goodsImgList =>
      _goods?.goodsImgList;

  List<ProductDetailBeanSpecListBean> get specList {
    // List<ProductDetailBeanSpecListBean> list = [
    //   ProductDetailBeanSpecListBean.fromMap({'spec_name': '数量'})
    // ];
    // list.addAll(goods?.specList);
    return goods?.specList;
  }

  List<ProductSkuBean> get skuList => _goods?.skuList;

  int get skuId => goods?.skuId;

  bool canAddToCart = true;

  ProductSkuBean get curProductSkuBean {
    if (skuId == null) return null;
    return skuList?.firstWhere((element) => element?.skuId == skuId);
  }

  int get count => curProductSkuBean?.count ?? 1;
  double get price => curProductSkuBean == null
      ? 0.0
      : double.parse(curProductSkuBean?.price ?? '0.0');
  double get totalPrice {
    if (price == null) return 0.0;
    print('总价');
    print(price * count);
    return price * count;
  }

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

    if (TargetClient().hasSelectedClient == false) {
      ToastKit.showInfo('请选择客户');
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

  Future addCart(
    BuildContext context,
  ) async {
    if (!beforePurchase(context)) return;

    canAddToCart = false;

    Map<String, dynamic> cartParams = {
      'client_uid': TargetClient().clientId,
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
              'img': curProductSkuBean?.image ?? '',
              'goods_name': goods?.goodsName,
              'price': goods?.price,
              'desc': '$checkedAttrText\n数量x${curProductSkuBean?.count ?? 1}',
              'sku_id': goods?.skuId,
              'goods_id': goods?.goodsId ?? '',
              'total_price': totalPrice ?? 0.0,
              'count': count,
              'is_endproduct': true,
              'goods_attrs': jsonEncode([]),
              'goods_type': goods?.goodsSpecialType
            }
          ],
        }));
  }

  Map<String, dynamic> get productAttrArg {
    return {'sku_id': goods?.skuId, 'num': count};
  }

  static Future editCount(BuildContext context,
      {CartModel cartModel, Function callback}) async {
    OTPService.editCartCount(context, params: {
      'sku_id': cartModel?.skuId,
      'num': cartModel?.count,
      'cart_id': cartModel?.cartId
    })
        .then((ZYResponse response) {
          if (response?.valid == true) {
            // cartModel?.count =
            // cartModel?.goodsAttrStr = '${response?.data ?? '0'}';
            if (callback != null) callback();
          }
        })
        .catchError((err) => err)
        .whenComplete(() {
          // Navigator.of(context)
        });
  }

  Future modifyEndProductAttr(BuildContext context,
      {Map<String, dynamic> params,
      CartModel cartModel,
      Function callback}) async {
    params = params ?? {};
    curProductSkuBean?.count = cartModel?.count;
    params?.addAll({'cart_id': cartModel?.cartId, 'sku_id': cartModel?.skuId});
    params?.addAll(productAttrArg);
    OTPService.modifyCartAttr(context, params)
        .then((ZYResponse response) {
          if (response?.valid == true) {
            CartModel model = CartModel.fromJson(response?.data);

            cartModel?.price = model?.price;
            cartModel?.pictureInfo?.picCoverSmall =
                model?.pictureInfo?.picCoverSmall;

            cartModel?.skuId = model?.skuId;
            cartModel?.goodsAttrStr = model?.skuName;
            cartModel?.count = model?.count;

            if (callback != null) {
              callback();
            }

            Navigator.of(context).pop(model);
          }
        })
        .catchError((err) => err)
        .whenComplete(() {
          // Navigator.of(context)
        });
  }
}
