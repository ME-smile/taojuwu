// /*
//  * @Description:  第二版购物车
//  * @Author: iamsmiling
//  * @Date: 2020-10-31 13:34:35
//  * @LastEditTime: 2020-11-09 10:31:39
//  */
// import 'package:animations/animations.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:taojuwu/repository/shop/cart_list_model.dart';
// import 'package:taojuwu/services/otp_service.dart';
// import 'package:taojuwu/view/cart/widgets/cart_tab_view.dart';
// import 'package:taojuwu/viewmodel/cart/cart_provider.dart';

// class CartPage extends StatefulWidget {
//   final int clientId;
//   CartPage({Key key, this.clientId}) : super(key: key);

//   @override
//   _CartPageState createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
//   int get clientId => widget.clientId;
//   bool isLoading = true;

//   List<CartCategory> categoryList = [
//     CartCategory('全部', 0),
//     CartCategory('窗帘', 0),
//     CartCategory('抱枕', 0),
//     CartCategory('沙发', 0),
//     CartCategory('床品', 0),
//     CartCategory('饰品', 0),
//   ];

//   CartProvider cartProvider;
//   TabController tabController;
//   @override
//   void initState() {
//     fetchData();
//     cartProvider = CartProvider(bean, categoryList: categoryList);
//     tabController = TabController(length: categoryList?.length, vsync: this);
//     super.initState();
//   }

//   Future fetchData() {
//     return OTPService.cartCategory(context, params: {'client_uid': clientId})
//         .then((CartCategoryResp response) {
//       categoryList = response?.data?.data;
//       cartProvider.setCategoryList(categoryList);
//       tabController = TabController(length: categoryList?.length, vsync: this);
//     }).whenComplete(() {
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }

//   void refreh() {}

//   @override
//   void dispose() {
//     tabController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider.value(
//       value: cartProvider,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('购物车'),
//           centerTitle: true,
//           elevation: 0,
//         ),
//         body: PageTransitionSwitcher(
//           transitionBuilder: (
//             Widget child,
//             Animation<double> animation,
//             Animation<double> secondaryAnimation,
//           ) {
//             return FadeThroughTransition(
//               animation: animation,
//               secondaryAnimation: secondaryAnimation,
//               child: child,
//             );
//           },
//           child: Column(
//             children: [
//               Selector<CartProvider, List<CartCategory>>(
//                 builder: (BuildContext context, List<CartCategory> list, _) {
//                   return Container(
//                     margin: EdgeInsets.only(bottom: 8),
//                     color: Theme.of(context).primaryColor,
//                     child: TabBar(
//                         controller: tabController,
//                         indicatorSize: TabBarIndicatorSize.label,
//                         unselectedLabelStyle:
//                             TextStyle(color: Color(0xFF333333), fontSize: 14),
//                         labelStyle: TextStyle(
//                             color: Color(0xFF1B1B1B),
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500),
//                         labelPadding:
//                             EdgeInsets.only(bottom: 5, left: 5, right: 5),
//                         tabs: list
//                             ?.map((bean) => Container(
//                                   padding: EdgeInsets.only(top: 8, bottom: 4),
//                                   child: Text(
//                                     '${bean?.name}(${bean?.count})',
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         color: const Color(0xFF1B1B1B)),
//                                   ),
//                                 ))
//                             ?.toList()),
//                   );
//                 },
//                 selector: (BuildContext context, CartProvider provider) =>
//                     provider?.categoryList,
//               ),
//               Expanded(
//                 child: TabBarView(
//                     controller: tabController,
//                     children: categoryList
//                         ?.map((e) => CartTabView(
//                               clientId: clientId,
//                               categoryId: e?.id,
//                             ))
//                         ?.toList()),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
