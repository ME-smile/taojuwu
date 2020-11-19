/*
 * @Description: //TODO
 * @Author: iamsmiling
 * @Date: 2020-11-06 09:33:06
 * @LastEditTime: 2020-11-09 16:00:56
 */
// /*
//  * @Description: 购物车tab视图
//  * @Author: iamsmiling
//  * @Date: 2020-11-06 09:33:06
//  * @LastEditTime: 2020-11-09 10:16:43
//  */
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:taojuwu/repository/shop/cart_list_model.dart';
// import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';
// import 'package:taojuwu/repository/shop/product_detail/curtain/base_curtain_product_detail_bean.dart';
// import 'package:taojuwu/services/otp_service.dart';
// import 'package:taojuwu/view/cart/widgets/base/curtain_product_bean_cart_card.dart';
// import 'package:taojuwu/view/cart/widgets/base/end_product_bean_cart_card.dart';
// import 'package:taojuwu/viewmodel/cart/cart_provider.dart';

// class CartTabView extends StatefulWidget {
//   final int clientId;
//   final String categoryId;
//   CartTabView({Key key, this.categoryId, this.clientId}) : super(key: key);

//   @override
//   _CartTabViewState createState() => _CartTabViewState();
// }

// class _CartTabViewState extends State<CartTabView> {
//   int get clientId => widget.clientId;
//   String get categoryId => widget.categoryId;
//   bool isLoading = true;
//   @override
//   void initState() {
//     fetchData();
//     super.initState();
//   }

//   Future fetchData() {
//     return OTPService.cartList(context,
//             params: {'client_uid': clientId, 'category_id': categoryId})
//         .then((CartListResp response) {
//           if (response?.valid == true) {
//             CartProvider provider = Provider.of(context, listen: false);
//             provider?.setCartProductBean(response?.data?.bean);
//           }
//         })
//         .catchError((err) => err)
//         .whenComplete(() {
//           setState(() {
//             isLoading = false;
//           });
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CartProvider>(
//       builder: (BuildContext context, CartProvider provider, _) {
//         List<SingleProductDetailBean> goodsList = provider?.bean?.goodsList;
//         return ListView.builder(
//           itemCount: provider?.bean?.goodsList?.length ?? 0,
//           itemBuilder: (BuildContext context, int i) {
//             SingleProductDetailBean bean = goodsList[i];
//             return bean is BaseCurtainProductDetailBean
//                 ? CurtainProductBeanCartCard(
//                     bean: bean,
//                   )
//                 : EndProductBeanCartCard(
//                     bean: bean,
//                   );
//           },
//         );
//       },
//     );
//   }
// }
