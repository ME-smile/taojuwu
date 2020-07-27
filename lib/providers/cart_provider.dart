import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:taojuwu/models/shop/cart_list_model.dart';

class CartProvider with ChangeNotifier {
  int _curIndex = 0;
  List<List<CartModel>> modelsList;
  List<CartModel> get models => modelsList == null ? [] : modelsList[curIndex];
  List<CartCategory> categoryList;
  CartCategory get curCategory =>
      categoryList == null ? null : categoryList[curIndex];
  bool get isAllChecked =>
      models?.every((element) => element?.isChecked) ?? false;
  bool get hasModels => models?.isNotEmpty ?? false;
  int get clientId => hasModels ? models?.first?.clientId : null;
  bool _isEditting = false;
  bool get isEditting => _isEditting;

  int get curIndex => _curIndex;

  set curIndex(int index) {
    _curIndex = index;
    notifyListeners();
  }

  set isEditting(bool flag) {
    _isEditting = flag;
    checkAll(false);
  }

  void setData(List<List<CartModel>> cartModelsList,
      List<CartCategory> cartCategoryList) {
    modelsList = cartModelsList;
    categoryList = cartCategoryList;
    notifyListeners();
  }

  List<CartModel> get selectedModels =>
      models
          ?.where((item) => item.isChecked == true)
          ?.toList()
          ?.reversed
          ?.toList() ??
      [];
  List<Map> get checkedModels {
    final selectedModels =
        models?.where((item) => item.isChecked == true)?.toList()?.reversed;
    return selectedModels
        ?.map((item) => item?.toString())
        ?.toList()
        ?.map((item) => Map.castFrom(jsonDecode(item)))
        ?.toList();
  }

  int get totalCount => hasModels ? selectedModels?.length ?? 0 : 0;

  bool get hasSelectedModels => totalCount > 0;
  double get totalAmount {
    if (!hasModels) return 0.0;
    double sum = 0.0;
    selectedModels?.forEach((element) {
      sum += element?.totalPrice;
    });
    return sum;
  }

  void checkAll(bool isSelected) {
    models?.forEach((item) {
      item.isChecked = isSelected;
    });
    notifyListeners();
  }

  void checkGoods(CartModel model, bool isSelected) {
    model?.isChecked = isSelected;

    notifyListeners();
  }

  void countReduce(int i) {}

  void removeGoods(
    int id, {
    Function callback,
  }) {
    CartModel cartModel =
        models?.firstWhere((element) => element?.cartId == id);
    int i = models?.indexWhere((model) => model?.cartId == id);
    String categoryId = cartModel?.categoryId;
    if (i != -1) {
      models?.removeAt(i);

      //在全部tab下
      categoryList?.forEach((element) {
        if (element?.id == categoryId && element?.id == curCategory?.id) {
          element?.count--;
        }
        curCategory?.count--;
      });
    }
    notifyListeners();
  }

  void batchRemoveGoods() {
    List<CartModel> cartModels =
        models?.where((element) => element?.isChecked)?.toList();
    String categoryId = cartModels?.first?.categoryId;
    int len = cartModels?.length ?? 0;

    categoryList?.forEach((element) {
      if (element?.id == categoryId && element?.id != curCategory?.id) {
        int count = element?.count ?? 0;
        element?.count = count - len > 0 ? count - len : 0;
      }
      int count = curCategory?.count ?? 0;
      curCategory?.count = count - len > 0 ? count - len : 0;
    });
    models?.removeWhere((element) => element?.isChecked);
    notifyListeners();
  }
}
