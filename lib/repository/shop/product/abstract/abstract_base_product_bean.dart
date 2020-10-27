/*
 * @Description: //所有商品的抽象类基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:03:47
 * @LastEditTime: 2020-10-27 16:20:27
 */

abstract class AbstractBaseProductBean {
  double get totalPrice;

  Future addToCart();

  Future buy();

  Map<dynamic, dynamic> get attrArgs;

  get cartArgs;
}
