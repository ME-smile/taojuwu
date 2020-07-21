import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:taojuwu/models/shop/cart_list_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> models;

  bool get isAllChecked =>
      models?.every((element) => element?.isChecked) ?? false;
  bool get hasModels => models?.isNotEmpty;
  int get clientId => hasModels ? models?.first?.clientId : null;
  bool _isEditting = false;
  bool get isEditting => _isEditting;

  set isEditting(bool flag) {
    _isEditting = flag;
    checkAll(false);
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

  CartProvider({this.models});

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

  void removeGoods(int id) {
    int i = models?.indexWhere((model) => model?.cartId == id);
    if (i != -1) {
      models?.removeAt(i);
    }
    notifyListeners();
  }

  void batchRemoveGoods() {
    models?.removeWhere((element) => element?.isChecked);
    notifyListeners();
  }
}
