// /*
//  * @Description: 购物车数据详情
//  * @Author: iamsmiling
//  * @Date: 2020-11-05 15:31:43
//  * @LastEditTime: 2020-11-06 09:27:05
//  */
// import 'package:flutter/cupertino.dart';
// import 'package:taojuwu/repository/shop/cart_list_model.dart';
// import 'package:taojuwu/repository/shop/product_detail/cart/cart_product_detail_bean.dart';

// class CartProvider with ChangeNotifier {
//   List<CartCategory> categoryList = [
//     CartCategory('全部', 0),
//     CartCategory('窗帘', 0),
//     CartCategory('抱枕', 0),
//     CartCategory('沙发', 0),
//     CartCategory('床品', 0),
//   ];

//   CartProductDetailBean bean;

//   CartProvider(this.bean, {this.categoryList});

//   //重新赋值
//   void setCartProductBean(
//     CartProductDetailBean cartProductDetailBean,
//   ) {
//     bean = cartProductDetailBean;
//   }

//   void setCategoryList(List<CartCategory> list) {
//     categoryList = list;
//   }
// }
