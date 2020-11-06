/*
 * @Description: 成品
 * @Author: iamsmiling
 * @Date: 2020-10-19 09:59:02
 * @LastEditTime: 2020-10-19 11:26:21
 */
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_viewmodel.dart';

class EndProductViewModel extends BaseGoodsViewModel {
  ProductDetailBean bean; //商品详情

  EndProductViewModel(this.bean);
  @override
  Future addToCart() {
    throw UnimplementedError();
  }

  @override
  Future purchase() {
    throw UnimplementedError();
  }

  @override
  double get totalPrice => throw UnimplementedError();
}
