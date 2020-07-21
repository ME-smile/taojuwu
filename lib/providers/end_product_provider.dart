import 'package:flutter/material.dart';
import 'package:taojuwu/models/shop/product_bean.dart';
import 'package:taojuwu/models/shop/sku_bean.dart';

class EndProductProvider with ChangeNotifier {
  ProductBean _goods;

  EndProductProvider(ProductBean bean) : _goods = bean;
  ProductBean get goods => _goods;

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

  int get count => _goods?.count;
  SkuBean get curSkubean {
    return skuList?.firstWhere((element) => element?.skuId == skuId);
  }

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
}
