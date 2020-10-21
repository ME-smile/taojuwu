// import 'package:animations/animations.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:provider/provider.dart';
// import 'package:taojuwu/application.dart';
// import 'package:taojuwu/icon/ZYIcon.dart';
// import 'package:taojuwu/repository/shop/cart_list_model.dart';
// import 'package:taojuwu/repository/shop/product_bean.dart';

// import 'package:taojuwu/view/goods/base/bottom_action_bar.dart';
// import 'package:taojuwu/view/goods/base/cart_button.dart';
// import 'package:taojuwu/view/goods/base/like_button.dart';
// import 'package:taojuwu/view/goods/base/onsale_tag.dart';
// import 'package:taojuwu/providers/end_product_provider.dart';
// import 'package:taojuwu/services/otp_service.dart';
// import 'package:taojuwu/singleton/target_client.dart';
// import 'package:taojuwu/singleton/target_order_goods.dart';
// import 'package:taojuwu/utils/toast_kit.dart';
// import 'package:taojuwu/utils/ui_kit.dart';
// import 'package:taojuwu/widgets/loading.dart';
// import 'package:taojuwu/widgets/step_counter.dart';
// import 'package:taojuwu/widgets/user_choose_button.dart';
// import 'package:taojuwu/widgets/v_spacing.dart';
// import 'package:taojuwu/widgets/zy_action_chip.dart';

// import 'package:taojuwu/widgets/zy_netImage.dart';
// import 'package:taojuwu/widgets/zy_submit_button.dart';

// class EndProductDetailPage extends StatefulWidget {
//   final int id;
//   EndProductDetailPage({Key key, this.id}) : super(key: key);

//   @override
//   _EndProductDetailPageState createState() => _EndProductDetailPageState();
// }

// class _EndProductDetailPageState extends State<EndProductDetailPage>
//     with RouteAware {
//   int get id => widget.id;

//   bool beforePurchase(EndProductProvider provider, BuildContext context) {
//     if (TargetClient().hasSelectedClient == false) {
//       ToastKit.showInfo('请选择客户');
//       return false;
//     }
//     return true;
//   }

//   @override
//   void dispose() {
//     goodsProvider?.dispose();
//     super.dispose();
//   }

//   @override
//   void didPopNext() {
//     OTPService.cartCount(context,
//             params: {'client_uid': TargetClient().clientId, 'goods_id': id})
//         .then((CartCountResp cartCountResp) {
//           if (mounted)
//             TargetOrderGoods.instance.endProductProvider?.cartCount =
//                 cartCountResp?.data;
//         })
//         .catchError((err) => err)
//         .whenComplete(() {
//           if (mounted) {
//             setState(() {});
//           }
//         });
//   }

//   @override
//   void didChangeDependencies() {
//     Application.routeObserver.subscribe(this, ModalRoute.of(context));
//     super.didChangeDependencies();
//   }

//   @override
//   void initState() {
//     fetchData();

//     super.initState();
//   }

//   void fetchData() {
//     OTPService.endProductDetailData(context,
//             params: {'goods_id': id, 'client_uid': TargetClient().clientId})
//         .then((data) {
//           ProductBeanResp response = data[0];
//           CartCountResp cartCountResp = data[1];

//           ProductBeanDataWrapper wrapper = response?.data;
//           bean = wrapper?.goodsDetail;
//           goodsProvider = EndProductProvider(bean);
//           TargetOrderGoods.instance.setEndProductProvider(goodsProvider);
//           TargetOrderGoods.instance.endProductProvider.cartCount =
//               cartCountResp?.data;
//         })
//         .catchError((err) => err)
//         .whenComplete(() {
//           if (mounted) {
//             setState(() {
//               isLoading = false;
//             });
//           }
//         });
//   }

//   bool isLoading = true;
//   EndProductProvider goodsProvider;
//   ProductBean bean;
//   @override
//   Widget build(BuildContext context) {
//     ThemeData themeData = Theme.of(context);
//     TextTheme textTheme = themeData.textTheme;
//     // return Scaffold(
//     //   appBar: AppBar(
//     //     title: Text('商品详情'),
//     //   ),
//     // );
//     return PageTransitionSwitcher(
//       duration: Duration(milliseconds: 500),
//       transitionBuilder: (
//         Widget child,
//         Animation<double> animation,
//         Animation<double> secondaryAnimation,
//       ) {
//         return FadeThroughTransition(
//           animation: animation,
//           secondaryAnimation: secondaryAnimation,
//           child: child,
//         );
//       },
//       child: isLoading
//           ? LoadingCircle()
//           : ChangeNotifierProvider<EndProductProvider>.value(
//               value: goodsProvider,
//               child: Consumer<EndProductProvider>(builder:
//                   (BuildContext context, EndProductProvider provider, _) {
//                 return WillPopScope(
//                   onWillPop: () {
//                     return Future.value(true);
//                   },
//                   child: Scaffold(
//                     body: NestedScrollView(
//                       headerSliverBuilder:
//                           (BuildContext context, bool innerBoxIsScrolled) {
//                         return <Widget>[
//                           SliverAppBar(
//                             actions: <Widget>[UserChooseButton()],
//                             expandedHeight: 360,
//                             floating: false,
//                             pinned: true,
//                             flexibleSpace: FlexibleSpaceBar(
//                               background: Container(
//                                   // padding: EdgeInsets.symmetric(
//                                   //     horizontal: UIKit.width(50),
//                                   //     vertical: UIKit.height(20)),
//                                   margin: EdgeInsets.only(top: 80),
//                                   child: Swiper(
//                                     key: ValueKey(id),
//                                     itemCount: bean?.goodsImgList?.length,
//                                     itemBuilder:
//                                         (BuildContext context, int index) {
//                                       ProductBeanGoodsImageBean item =
//                                           bean?.goodsImgList[index];
//                                       return ZYNetImage(
//                                         width: 300,
//                                         height: 300,
//                                         imgPath: item?.picCoverBig,
//                                         needAnimation: false,
//                                       );
//                                     },
//                                     pagination: new SwiperPagination(
//                                         margin:
//                                             EdgeInsets.symmetric(horizontal: 5),
//                                         builder: DotSwiperPaginationBuilder(
//                                             size: 8.0,
//                                             activeSize: 8.0,
//                                             activeColor: Colors.black,
//                                             color:
//                                                 Colors.black.withOpacity(.3))),
//                                   )),
//                             ),
//                           )
//                         ];
//                       },
//                       body: CustomScrollView(slivers: <Widget>[
//                         SliverToBoxAdapter(
//                           child: Container(
//                             color: themeData.primaryColor,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: UIKit.width(20),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: <Widget>[
//                                     Text.rich(TextSpan(
//                                         text: '${bean?.goodsName} ' ?? '',
//                                         style: TextStyle(
//                                             fontSize: UIKit.sp(28),
//                                             fontWeight: FontWeight.w400),
//                                         children: [
//                                           TextSpan(
//                                               text: bean?.goodsName ?? '',
//                                               style: textTheme.caption)
//                                         ])),
//                                     Container(
//                                       child: Row(
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: EdgeInsets.only(right: 20),
//                                             child: LikeButton(),
//                                           ),
//                                           CartButton(
//                                             count: provider?.cartCount,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 VSpacing(20),
//                                 Text.rich(TextSpan(
//                                     text: '¥${bean?.price ?? 0.00}',
//                                     style: TextStyle(
//                                         fontSize: UIKit.sp(32),
//                                         fontWeight: FontWeight.w500),
//                                     children: [
//                                       TextSpan(
//                                           text: '元', style: textTheme.caption),
//                                       TextSpan(text: ' '),
//                                       TextSpan(
//                                           text: bean?.isPromotionGoods == true
//                                               ? '¥${bean?.marketPrice}'
//                                               : '',
//                                           style: textTheme.caption.copyWith(
//                                               decoration:
//                                                   TextDecoration.lineThrough)),
//                                       WidgetSpan(
//                                           child: Offstage(
//                                         offstage:
//                                             bean?.isPromotionGoods == false,
//                                         child: OnSaleTag(),
//                                       ))
//                                     ])),
//                                 VSpacing(10),
//                                 Divider(),
//                                 Container(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: UIKit.height(20)),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[
//                                       Expanded(
//                                         child: Text.rich(
//                                           TextSpan(
//                                               text: '已选',
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15),
//                                               children: [
//                                                 WidgetSpan(
//                                                     child: SizedBox(
//                                                   width: 10,
//                                                 )),
//                                                 TextSpan(
//                                                     text: provider
//                                                         ?.checkedAttrText,
//                                                     style: textTheme.caption
//                                                         .copyWith(fontSize: 14))
//                                               ]),
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           selectAttrOption(provider, () {
//                                             Navigator.of(context).pop();
//                                           }, shouldPop: false);
//                                         },
//                                         child: Icon(
//                                           ZYIcon.three_dot,
//                                           color: Colors.black,
//                                           size: 28,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SliverToBoxAdapter(
//                           child: VSpacing(20),
//                         ),
//                         SliverToBoxAdapter(
//                           child: bean?.description?.isNotEmpty == true
//                               ? Html(
//                                   data: bean?.description,
//                                   backgroundColor: themeData.primaryColor,
//                                 )
//                               : Container(),
//                         )
//                       ]),
//                     ),
//                     bottomNavigationBar: PurchaseActionBar(
//                       totalPrice: '${provider?.totalPrice ?? '0.00'}',
//                       canAddToCart: provider?.canAddToCart ?? true,
//                       addToCartFunc: () {
//                         selectAttrOption(provider, () {
//                           provider?.addCart(context);
//                         });
//                       },
//                       purchaseFunc: () {
//                         selectAttrOption(provider, () {}).whenComplete(() {
//                           provider?.createOrder(context);
//                         });
//                       },
//                     ),
//                   ),
//                 );
//               }),
//             ),
//     );
//   }

//   Future selectAttrOption(EndProductProvider provider, Function callback,
//       {bool shouldPop = true}) async {
//     if (TargetClient().hasSelectedClient == false) {
//       return ToastKit.showInfo('请选择客户');
//     }
//     return showCupertinoModalPopup(
//         context: context,
//         builder: (BuildContext context) {
//           double height = MediaQuery.of(context).size.height;
//           double width = MediaQuery.of(context).size.width;
//           return ClipRRect(
//             borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(10), topLeft: Radius.circular(10)),
//             child: Container(
//               width: width,
//               height: height * .7,
//               child: Scaffold(
//                 body: Stack(
//                   children: <Widget>[
//                     Container(
//                         padding: EdgeInsets.all(16),
//                         child: StatefulBuilder(builder:
//                             (BuildContext context, StateSetter setState) {
//                           return Column(
//                             children: <Widget>[
//                               Row(
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: EdgeInsets.only(right: 14),
//                                     child: ZYNetImage(
//                                       imgPath: provider
//                                           ?.curProductSkuBean?.tinyPicUrl,
//                                       width: UIKit.width(180),
//                                       height: UIKit.width(180),
//                                     ),
//                                   ),
//                                   Expanded(
//                                       child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: <Widget>[
//                                       Text(
//                                         '¥${provider?.curProductSkuBean?.price ?? ''}',
//                                         style: TextStyle(
//                                             color: Color(0xFFFF6161),
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       Text(
//                                         '已选:${provider?.checkedAttrText ?? ''}',
//                                         style: TextStyle(
//                                             fontSize: 14,
//                                             color: Color(0xFF6D6D6D)),
//                                       )
//                                     ],
//                                   ))
//                                 ],
//                               ),
//                               Container(
//                                 alignment: Alignment.centerLeft,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: <Widget>[
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: UIKit.height(16)),
//                                       child: Text('数量'),
//                                     ),
//                                     StepCounter(
//                                       count: provider?.count,
//                                       model: provider?.curProductSkuBean,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Flexible(
//                                 child: ListView.builder(
//                                   shrinkWrap: true,
//                                   padding: EdgeInsets.all(0),
//                                   itemBuilder: (BuildContext context, int i) {
//                                     ProductBeanSpecListBean item =
//                                         provider?.specList[i];

//                                     return Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: UIKit.height(16)),
//                                           child: Text(item?.specName),
//                                         ),
//                                         Wrap(
//                                           runSpacing: UIKit.sp(16),
//                                           spacing: UIKit.sp(24),
//                                           children: List.generate(
//                                               item?.value?.length, (index) {
//                                             ProductBeanSpecValueBean e =
//                                                 item?.value[index];
//                                             return Container(
//                                               height: 26,
//                                               child: AspectRatio(
//                                                 aspectRatio: 3,
//                                                 child: ZYActionChip(
//                                                   callback: () {
//                                                     item?.value
//                                                         ?.forEach((element) {
//                                                       element?.selected = false;
//                                                     });
//                                                     setState(() {
//                                                       e.selected = !e.selected;
//                                                     });
//                                                     provider?.skuList
//                                                         ?.forEach((element) {
//                                                       if (element
//                                                               ?.attrValueItemsFormat ==
//                                                           provider
//                                                               ?.checkedOptionsValueStr) {
//                                                         provider?.skuId =
//                                                             element?.skuId;
//                                                       }
//                                                     });
//                                                   },
//                                                   bean: ActionBean.fromJson({
//                                                     'text': e.specValueName,
//                                                     'is_checked': e.selected
//                                                   }),
//                                                 ),
//                                               ),
//                                             );
//                                           }),
//                                         )
//                                       ],
//                                     );
//                                   },
//                                   itemCount: provider?.specList?.length ?? 0,
//                                 ),
//                               )
//                             ],
//                           );
//                         })),
//                     Positioned(
//                         top: 10,
//                         right: 10,
//                         child: InkWell(
//                           child: Icon(ZYIcon.close),
//                           onTap: () {
//                             Navigator.of(context).pop();
//                           },
//                         ))
//                   ],
//                 ),
//                 bottomNavigationBar: Container(
//                   margin: EdgeInsets.symmetric(vertical: 8),
//                   child: ZYSubmitButton('确定', () {
//                     callback();
//                     if (shouldPop) {
//                       Navigator.of(context).pop();
//                     }
//                   }),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
