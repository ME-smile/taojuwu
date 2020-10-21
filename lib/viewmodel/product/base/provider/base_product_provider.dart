/*
 * @Description: 商品provider的基类，混入changeNotifier,具有刷新的功能
 * @Author: iamsmiling
 * @Date: 2020-10-20 18:12:25
 * @LastEditTime: 2020-10-21 09:13:20
 */
import 'package:flutter/cupertino.dart';
import 'package:taojuwu/viewmodel/product/base/provider/abstract_base_product_provider.dart';

class BaseProductProvider extends AbstractBaseProductProvider
    with ChangeNotifier {
  // 通知页面刷新
  refresh() {
    notifyListeners();
  }
}
