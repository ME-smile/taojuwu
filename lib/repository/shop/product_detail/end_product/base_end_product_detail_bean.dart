/*
 * @Description: 所有成品商品的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:17:00
 * @LastEditTime: 2020-12-31 15:53:58
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/add_to_cart_event.dart';
import 'package:taojuwu/repository/shop/product_detail/base/spec/product_spec_bean.dart';
import 'package:taojuwu/repository/shop/product_sku_bean.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';

import 'abstract_base_end_product_detail_bean.dart';

abstract class BaseEndProductDetailBean
    extends AbstractBaseEndProductDetailBean {
  List<ProductSpecBean> specList;
  List<ProductSkuBean> skuList;

  bool hasSelectedSpec = false;
  BaseEndProductDetailBean.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    specList = CommonKit.parseList(json['spec_list'])
        ?.map((e) => ProductSpecBean.fromJson(e))
        ?.toList();
    skuList = CommonKit.parseList(json['sku_list'])
        .map((e) => ProductSkuBean.fromJson(e))
        ?.toList();
  }

  Future addToCartRequest({Function callback, BuildContext context}) {
    return OTPService.addCart(params: cartArgs).then((ZYResponse response) {
      if (response?.valid == true) {
        ToastKit.showSuccessDIYInfo('加入购物车成功');
        Application.eventBus.fire(AddToCartEvent(response?.data));
        if (context != null) {
          Navigator.of(context).pop();
        }
      } else {
        ToastKit.showErrorInfo(response?.message);
      }
    }).catchError((err) => err);
  }

  List<bool> selectSpec() {
    List<bool> list = [];
    for (int i = 0; i < specList?.length; i++) {
      ProductSpecBean e = specList[i];
      bool flag = hasSelectSpecOption(e);
      list.add(flag);
      if (!flag) return list;
    }
    return list;
  }

  int get colorSpecCount {
    ProductSpecBean e = specList?.firstWhere((e) => e?.name?.contains('颜色'),
        orElse: () => null);
    return e?.options?.length ?? 0;
  }

  bool hasSelectSpecOption(ProductSpecBean spec) {
    bool flag = spec?.options
            ?.firstWhere((e) => e?.isSelected == true, orElse: () => null)
            ?.isSelected ??
        false;
    if (!flag) {
      ToastKit.showInfo('请选择${spec?.name}');
      return false;
    }
    return true;
  }

  ProductSkuBean get currentSkuBean =>
      skuList?.firstWhere((element) => element?.skuName == selectedOptionsName,
          orElse: () => null);

  int get skuId => currentSkuBean?.skuId;

  int get picId => currentSkuBean?.picId;

  String get mainImg => CommonKit.isNullOrEmpty(currentSkuBean?.image)
      ? cover
      : currentSkuBean?.image;

  String get specName {
    if (CommonKit.isNullOrEmpty(specList)) return '数量:x$count';
    return '请选择' +
        ((specList?.map((e) => e?.name)?.toList())?.join('/') ?? '') +
        '/数量';
  }

  String get selectedOptionsName =>
      (specList?.map((e) => e?.selectedOptionsName)?.toList()?.join(' ') ?? '');

  void selectSpecOption(ProductSpecBean spec, ProductSpecOptionBean option) {
    spec?.options?.forEach((el) {
      el?.isSelected = el == option;
    });
  }

  String get detailDescription {
    List<String> list = [];
    specList?.forEach((el) {
      String selectedOptionName = el?.options
              ?.firstWhere((o) => o?.isSelected, orElse: () => null)
              ?.name ??
          '';
      list.add('${el.name}: $selectedOptionName ');
    });
    return list.join(',');
  }
}
