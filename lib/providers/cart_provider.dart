import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:taojuwu/models/shop/cart_list_model.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class CartProvider with ChangeNotifier {
  // as static fileld,esaier access by Class
  static List<CartCategory> tabs = [
    CartCategory('全部', 0),
    CartCategory('窗帘', 0),
    CartCategory('抱枕', 0),
    CartCategory('沙发', 0),
    CartCategory('床品', 0),
  ];
  int _curIndex = 0;
  List<List<CartModel>> modelsList = [];
  List<CartModel> get models => modelsList.isEmpty ? [] : modelsList[curIndex];
  List<CartCategory> _categoryList = [
    CartCategory('全部', 0),
    CartCategory('窗帘', 0),
    CartCategory('抱枕', 0),
    CartCategory('沙发', 0),
    CartCategory('床品', 0),
  ];
  List<CartCategory> get categoryList => _categoryList;
  set categoryList(List<CartCategory> list) {
    _categoryList = list;
    notifyListeners();
  }

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
    print(curIndex);
  }

  set isEditting(bool flag) {
    _isEditting = flag;
    checkAll(false);
  }

  void setData(List<List<CartModel>> cartModelsList,
      [List<CartCategory> cartCategoryList]) {
    modelsList = cartModelsList;
    if (cartCategoryList != null) categoryList = cartCategoryList;
    notifyListeners();
  }

  void assignModelList(int index, List<CartModel> cartModelsList) {
    modelsList[index] = cartModelsList;
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
      int totalCount = curCategory?.count;
      totalCount--;
      curCategory?.count = totalCount > 0 ? totalCount : 0;
      //在全部tab下

      categoryList?.forEach((element) {
        if (curCategory?.isAll == true) {
          if (element?.id == categoryId) {
            element?.count--;
          }
        } else {
          if (element?.isAll == true) {
            element?.count--;
          }
        }
      });
    }
    removeGoodsFromList(categoryId, [id]);
    notifyListeners();
  }

  int getCategoryIndexById(String id) {
    for (int i = 0; i < categoryList?.length ?? 0; i++) {
      CartCategory e = categoryList[i];
      if (e?.id == id) {
        return i;
      }
    }
    return 0;
  }

  void removeGoodsFromList(String categoryId, List<int> idList) {
    int index = getCategoryIndexById(categoryId);

    categoryList?.forEach((element) {
      if (curCategory?.isAll == true) {
        if (modelsList[index] == null) return;
        modelsList[index]?.removeWhere(
            (element) => idList?.contains(element?.categoryId) ?? false);
      } else {
        modelsList?.first?.removeWhere(
            (element) => idList?.contains(element?.categoryId) ?? false);
      }
    });
  }

  Future batchRemoveGoods(BuildContext context) async {
    List<CartModel> cartModels =
        models?.where((element) => element?.isChecked)?.toList();

    String categoryId = cartModels?.isEmpty ?? false != true
        ? ''
        : cartModels?.first?.categoryId;

    List<int> idList = selectedModels?.map((e) => e?.cartId)?.toList();
    CommonKit.showLoading();
    delCartList(context, categoryId, idList, callback: () {
      cartModels?.forEach((element) {
        if (element?.callback != null) {
          element?.callback();
        }
      });
      models?.removeWhere((element) => element?.isChecked);
      int len = cartModels?.length ?? 0;
      int count = curCategory?.count ?? 0;
      curCategory?.count = count - len > 0 ? count - len : 0;
      categoryList?.forEach((element) {
        if (curCategory?.isAll == true) {
          if (element?.id == categoryId) {}
        } else {
          if (element?.isAll == true) {
            int count = element?.count ?? 0;
            element?.count = count - len > 0 ? count - len : 0;
          }
        }
      });
      removeGoodsFromList(categoryId, idList);
    });

    notifyListeners();
  }

  Future remove(BuildContext context, CartModel cartModel,
      {int index, int clientId, Function cancel, Function confirm}) async {
    if (Platform.isAndroid) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                '删除',
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('您确定要从购物车中删除该商品吗?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ZYOutlineButton('取消', cancel),
                      SizedBox(
                        width: 30,
                      ),
                      ZYRaisedButton('确定', () {
                        delCart(context, cartModel?.cartId,
                            clientId: clientId, callback: confirm);
                      }),
                    ],
                  )
                ],
              ),
            );
          });
    } else {
      await showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(
                '删除',
              ),
              content: Text('您确定从购物车中删除该商品吗?'),
              actions: <Widget>[
                CupertinoDialogAction(child: Text('取消'), onPressed: cancel),
                CupertinoDialogAction(
                  child: Text('确定'),
                  onPressed: () {
                    delCart(context, cartModel?.cartId,
                        clientId: clientId, callback: confirm);
                  },
                )
              ],
            );
          });
    }
  }

  void delCart(BuildContext context, int id,
      {CartModel cartModel, Function callback, int clientId}) {
    OTPService.delCart(params: {'cart_id_array': '$id', 'cleint_uid': clientId})
        .then((CartCategoryResp response) {
          if (response?.valid == true) {
            removeGoods(id);
            if (callback != null) callback();
          } else {
            CommonKit.showToast(response?.message ?? '');
          }
        })
        .catchError((err) => err)
        .whenComplete(() {
          Navigator.of(context).pop();
        });
  }

  void delCartList(BuildContext context, String categoryId, List<int> idList,
      {Function callback}) {
    String idStr = idList?.join(',');
    OTPService.delCart(params: {'cart_id_array': '$idStr'})
        .then((ZYResponse response) {
          if (response?.valid == true) {
            CommonKit.showSuccess();
            if (callback != null) callback();
          } else {
            CommonKit.showToast(response?.message ?? '');
          }
        })
        .catchError((err) => err)
        .whenComplete(() {});
  }

  Future afterDel(
    BuildContext context,
  ) async {
    OTPService.cartCategory(context).then((CartCategoryResp response) {
      if (response?.valid == true) {
        categoryList = response?.data?.data;
      }
    }).catchError((err) => err);
  }
}
