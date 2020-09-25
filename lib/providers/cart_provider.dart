import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:taojuwu/repository/shop/cart_list_model.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class CartProvider with ChangeNotifier {
  // as static fileld,esaier access by Class
  CartProvider({List<CartCategory> list})
      : _categoryList = list ??
            [
              CartCategory('全部', 0),
              CartCategory('窗帘', 0),
              CartCategory('抱枕', 0),
              CartCategory('沙发', 0),
              CartCategory('床品', 0),
            ];

  List<List<CartModel>> modelsList = [];
  List<CartModel> _models = [];
  List<CartModel> get models => _models;

  CartModel curCartModel;
  List<CartCategory> _categoryList;
  List<CartCategory> get categoryList => _categoryList;
  set categoryList(List<CartCategory> list) {
    _categoryList = list;
    notifyListeners();
  }

  set models(List<CartModel> list) {
    _models = list;
    notifyListeners();
  }

  bool get isAllChecked =>
      models?.every((element) => element?.isChecked) ?? false;
  bool get hasModels => models?.isNotEmpty ?? false;
  int get clientId => hasModels ? models?.first?.clientId : null;
  bool _isEditting = false;
  bool get isEditting => _isEditting;

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
    // notifyListeners();
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
    print(selectedModels
        ?.map((item) => item?.toString())
        ?.toList()
        ?.map((item) => Map.castFrom(jsonDecode(item)))
        ?.toList());

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

  void refresh() {
    notifyListeners();
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

  int getCategoryIndexById(String id) {
    for (int i = 0; i < categoryList?.length ?? 0; i++) {
      CartCategory e = categoryList[i];
      if (e?.id == id) {
        return i;
      }
    }
    return 0;
  }

  Future batchRemoveGoods(BuildContext context, int clientId) async {
    List<int> idList = selectedModels?.map((e) => e?.cartId)?.toList();
    ToastKit.showLoading();
    delCartList(context, idList, clientId: clientId, callback: () {
      models?.removeWhere((element) => element?.isChecked == true);
      ToastKit.showSuccessDIYInfo('删除成功');
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
              titleTextStyle: TextStyle(fontSize: 16, color: Color(0xFF333333)),
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
    print('删除购物车请求参数');
    print({'cart_id_array': '$id', 'client_uid': clientId});
    OTPService.delCart(params: {'cart_id_array': '$id', 'client_uid': clientId})
        .then((CartCategoryResp response) {
      if (response?.valid == true) {
        categoryList = response?.data?.data;
        if (callback != null) callback();
      } else {
        ToastKit.showToast(response?.message ?? '');
      }
    }).catchError((err) {
      print(err);
      return err;
    }).whenComplete(() {
      Navigator.of(context).pop();
    });
  }

  void delCartList(BuildContext context, List<int> idList,
      {Function callback, int clientId}) {
    String idStr = idList?.join(',');
    OTPService.delCart(
            params: {'cart_id_array': '$idStr', 'client_uid': clientId})
        .then((CartCategoryResp response) {
      if (response?.valid == true) {
        categoryList = response?.data?.data;

        if (callback != null) callback();
      } else {
        ToastKit.showToast(response?.message ?? '');
      }
    }).catchError((err) => err);
  }
}
