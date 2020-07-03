import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:taojuwu/models/shop/cart_list_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> models;
  double totalAmount = 0.00;
  int totalCount = 0;
  bool isAllChecked = false;
  bool get hasModels => models?.isNotEmpty;
  int get clientId => hasModels ? models?.first?.clientId : null;
  CartProvider({this.models});

  void checkAll(bool isSelected) {
    isAllChecked = isSelected;
    models?.forEach((item) {
      item.isChecked = isAllChecked;
      totalAmount += double.parse(item.estimatedPrice ?? 0.00);
      totalCount++;
    });
    if (!isSelected) {
      totalAmount = 0.00;
      totalCount = 0;
    }

    notifyListeners();
  }

  void checkGoods(CartModel model, bool isSelected) {
    model?.isChecked = isSelected;
    if (isSelected) {
      totalCount++;
      totalAmount += double.parse(model?.estimatedPrice ?? '0.00');
    } else {
      totalCount--;
      totalAmount -= double.parse(model?.estimatedPrice ?? '0.00');
    }
    totalCount = totalCount < 0 ? 0 : totalCount;
    totalAmount = totalAmount < 0.00 ? 0.00 : totalAmount;
    if (totalCount != models?.length) {
      isAllChecked = false;
    } else {
      isAllChecked = true;
    }
    notifyListeners();
  }

  List<Map> get checkedModels {
    final selectedModels =
        models?.where((item) => item.isChecked == true)?.toList()?.reversed;
    return selectedModels
        ?.map((item) => item?.toString())
        ?.toList()
        ?.map((item) => Map.castFrom(jsonDecode(item)))
        ?.toList();
  }

  void removeGoods(int id) {
    int i = models?.indexWhere((model) => model?.cartId == id);
    if (i != -1) {
      models?.removeAt(i);
      totalCount--;
    }
    totalCount = totalCount < 0 ? 0 : totalCount;
    notifyListeners();
  }
}
