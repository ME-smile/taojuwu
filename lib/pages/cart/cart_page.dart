import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/application.dart';

import 'package:taojuwu/constants/constants.dart';

// import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/models/shop/cart_list_model.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/pages/goods/curtain/widgets/zy_dialog.dart';

import 'package:taojuwu/providers/cart_provider.dart';

import 'package:taojuwu/router/handlers.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';

import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/goods_attr_card.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/no_data.dart';
import 'package:taojuwu/widgets/step_counter.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class CartPage extends StatefulWidget {
  final int clientId;
  CartPage({Key key, this.clientId}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin, RouteAware {
  CartProvider _cartProvider = CartProvider();
  CartProvider get cartProvider => _cartProvider;
  int get clientId => widget.clientId;
  TabController tabController;

  bool isLoading = true;
  List<List<CartModel>> modelsList;
  List<CartModel> get models => cartProvider?.models;
  List<GlobalKey<AnimatedListState>> keyList;
  // GlobalKey<AnimatedListState> get animatedListKey =>
  //     keyList[tabController?.index ?? 0];
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  List<CartCategory> categoryList;
  CartCategory get curCategory => categoryList == null
      ? CartCategory('全部', 0, 0)
      : categoryList[tabController?.index ?? 0];
  get categoryId => curCategory?.id;
  CartModel curCartModel;
  bool hasInit = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(Constants.TRANSITION_DURATION, () {
      fetchData().whenComplete(() {});
    });
  }

  void fetchCartList() {
    cartProvider?.curIndex = tabController?.index;

    if (models != null) return;
    setState(() {
      isLoading = true;
    });
    OTPService.fetchCartData(context,
            params: {'client_uid': clientId, 'category_id': categoryId})
        .then((CartListResp response) {
          if (response?.valid == true) {
            CartListWrapper wrapper = response?.data;
            modelsList[tabController?.index] = wrapper?.data;
          }
        })
        .catchError((err) => err)
        .whenComplete(() {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        });
  }

  Future fetchData() {
    return OTPService.fetchCartData(context,
            params: {'client_uid': clientId, 'category_id': categoryId ?? 0})
        .then((CartListResp response) {
          if (response?.valid == true) {
            CartListWrapper wrapper = response?.data;
            categoryList = wrapper?.categoryList;
            tabController =
                TabController(length: categoryList?.length ?? 0, vsync: this)
                  ..addListener(fetchCartList);
            modelsList = List.filled(categoryList?.length ?? 0, null);
            keyList = List.filled(
                categoryList?.length ?? 0, GlobalKey<AnimatedListState>());
            modelsList[0] = wrapper?.data;
            hasInit = true;
            cartProvider?.setData(modelsList, categoryList);
          }
        })
        .catchError((err) => err)
        .whenComplete(() {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        });
  }

  @override
  void didChangeDependencies() {
    Application.routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    GoodsAttrWrapper goodsAttrWrapper =
        TargetOrderGoods.instance.goodsAttrWrapper;
    if (goodsAttrWrapper != null) {
      curCartModel?.attrs = goodsAttrWrapper?.goodsAttrList;
      curCartModel?.estimatedPrice =
          '${goodsAttrWrapper?.totalPrice ?? '0.00'}';
      setState(() {});
    }
    super.didPopNext();
  }

  @override
  void dispose() {
    tabController?.dispose();
    Application.routeObserver.unsubscribe(this);
    super.dispose();
  }

  void batchDelCart(CartProvider provider) {
    List<int> idList =
        provider?.selectedModels?.map((e) => e?.cartId)?.toList();
    String idStr = idList?.join(',');
    OTPService.delCart(params: {'cart_id_array': '$idStr'})
        .then((ZYResponse response) {
          if (response.valid) {
            for (int i = 0; i < idList?.length ?? 0; i++) {
              int id = idList[i];

              CartModel cartModel = provider?.models
                  ?.firstWhere((element) => element?.cartId == id);
              provider?.removeGoods(id);
              animatedListKey?.currentState?.removeItem(
                  i,
                  (context, animation) => AnimationConfiguration.staggeredList(
                      position: i,
                      duration: const Duration(milliseconds: 500),
                      child: SlideTransition(
                        position: animation?.drive(tween),
                        child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: buildCartCard(cartModel, i),
                            )),
                      )));
            }
            // provider?.batchRemoveGoods();
          } else {
            CommonKit.showToast(response?.message ?? '');
          }
        })
        .catchError((err) => err)
        .whenComplete(() {
          provider?.isEditting = false;
        });
  }

  void delCart(CartProvider provider, int id, {CartModel cartModel}) {
    OTPService.delCart(params: {'cart_id_array': '$id'})
        .then((ZYResponse response) {
      if (response.valid) {
        Navigator.of(context).pop();
        int i = provider?.models?.indexOf(cartModel);
        provider?.removeGoods(id);
        animatedListKey?.currentState?.removeItem(
            i,
            (context, animation) => AnimationConfiguration.staggeredList(
                position: i,
                duration: const Duration(milliseconds: 500),
                child: SlideTransition(
                  position: animation?.drive(tween),
                  child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: buildCartCard(cartModel, i),
                      )),
                )));
      } else {
        CommonKit.showToast(response?.message ?? '');
      }
    }).catchError((err) => err);
  }

  void remove(CartProvider provider, CartModel cartModel, {int index}) {
    if (Platform.isAndroid) {
      showDialog(
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
                      ZYOutlineButton('取消', () {
                        Navigator.of(context).pop();
                      }),
                      SizedBox(
                        width: 30,
                      ),
                      ZYRaisedButton('确定', () {
                        delCart(provider, cartModel?.cartId,
                            cartModel: cartModel);
                        // animatedListKey?.currentState?.removeItem(index, (context, animation) => null)
                      }),
                    ],
                  )
                ],
              ),
            );
          });
    } else {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(
                '删除',
              ),
              content: Text('您确定从购物��中删除该商品吗?'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('确定'),
                  onPressed: () {
                    delCart(provider, cartModel?.cartId);
                  },
                )
              ],
            );
          });
    }
  }

  Widget buildProductCard(CartModel cartModel, int index) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    return Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider provider, _) {
      return GestureDetector(
        onLongPress: () {
          remove(provider, cartModel);
        },
        onTap: () {
          ZYDialog.checkEndProductAttr(context, cartModel, callback: () {
            Navigator.of(context).pop();
            setState(() {});
          });
        },
        child: Container(
          color: themeData.primaryColor,
          margin: EdgeInsets.only(top: UIKit.height(20)),
          padding: EdgeInsets.symmetric(
              horizontal: UIKit.width(20), vertical: UIKit.height(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                      value: cartModel?.isChecked,
                      onChanged: (bool isSelected) {
                        provider?.checkGoods(cartModel, isSelected);
                      }),
                  ZYNetImage(
                    imgPath: cartModel?.pictureInfo?.picCoverSmall,
                    isCache: false,
                    width: UIKit.width(180),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                    height: UIKit.height(190),
                    // width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              cartModel?.goodsName ?? '',
                              style: textTheme.headline6
                                  .copyWith(fontSize: UIKit.sp(28)),
                            ),
                            Text.rich(TextSpan(
                                text: '￥' + '${cartModel?.price}' ?? '',
                                children: [TextSpan(text: cartModel?.unit)])),
                          ],
                        ),
                        Expanded(
                          child: Text(
                            cartModel?.goodsAttrStr ?? '',
                            softWrap: true,
                            style: textTheme.caption.copyWith(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: StepCounter(
                            count: cartModel?.count ?? 0,
                            model: cartModel,
                            callback: () {
                              setState(() {});
                            },
                          ),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildCustomizedProductCard(CartModel cartModel, int index) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider provider, _) {
      return GestureDetector(
        onLongPress: () {
          remove(provider, cartModel);
        },
        child: Container(
          color: themeData.primaryColor,
          margin: EdgeInsets.only(top: UIKit.height(20)),
          padding: EdgeInsets.symmetric(
              horizontal: UIKit.width(20), vertical: UIKit.height(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                      value: cartModel?.isChecked,
                      onChanged: (bool isSelected) {
                        provider?.checkGoods(cartModel, isSelected);
                      }),
                  ZYNetImage(
                    imgPath: cartModel?.pictureInfo?.picCoverSmall,
                    isCache: false,
                    width: UIKit.width(180),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                    height: UIKit.height(190),
                    // width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              cartModel?.goodsName ?? '',
                              style: textTheme.headline6
                                  .copyWith(fontSize: UIKit.sp(28)),
                            ),
                            Text.rich(TextSpan(
                                text: '￥' + '${cartModel?.price}' ?? '',
                                children: [TextSpan(text: cartModel?.unit)])),
                          ],
                        ),
                        Expanded(
                          child: Text(
                            cartModel?.goodsAttrStr ?? '',
                            softWrap: true,
                            style: textTheme.caption.copyWith(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
              GoodsAttrCard(
                cartModel: cartModel,
                clientId: clientId,
                callback: () {
                  curCartModel = cartModel;
                },
              ),
              Text.rich(
                TextSpan(text: '预计总金额', children: [
                  TextSpan(
                      text: '￥' +
                              (double.parse(
                                      cartModel?.estimatedPrice ?? '0.00'))
                                  .toStringAsFixed(2) ??
                          '',
                      style: TextStyle(
                          fontSize: UIKit.sp(32), fontWeight: FontWeight.w500))
                ]),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildCartCard(CartModel cartModel, int index) {
    return SlideAnimation(
      child: cartModel?.isCustomizedProduct == true
          ? buildCustomizedProductCard(cartModel, index)
          : buildProductCard(cartModel, index),
    );
  }

  Tween<Offset> tween = Tween<Offset>(
    begin: Offset(1, 0),
    end: Offset(0, 0),
  );
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) {
        return cartProvider;
      },
      child: Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider provider, _) {
          // List<CartModel> models = provider?.models;
          return Scaffold(
              appBar: AppBar(
                title: Text('购物车'),
                centerTitle: true,
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        provider?.isEditting = !provider.isEditting;
                      },
                      child: Text(provider?.isEditting == true ? '完成' : '编辑'))
                ],
                bottom: PreferredSize(
                    child: !hasInit
                        ? Container()
                        : Consumer<CartProvider>(
                            builder: (BuildContext context,
                                CartProvider provider, _) {
                              return TabBar(
                                  controller: tabController,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  unselectedLabelStyle: TextStyle(
                                      color: Color(0xFF333333), fontSize: 14),
                                  labelStyle: TextStyle(
                                      color: Color(0xFF1B1B1B),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  labelPadding: EdgeInsets.only(
                                      bottom: 5, left: 5, right: 5),
                                  tabs: List.generate(categoryList?.length ?? 0,
                                      (int i) {
                                    CartCategory bean = categoryList[i];
                                    return Text(
                                        '${bean?.name}(${bean?.count})');
                                  }));
                            },
                          ),
                    preferredSize: Size.fromHeight(20)),
              ),
              body: isLoading
                  ? LoadingCircle()
                  : TabBarView(
                      controller: tabController,
                      children:
                          List.generate(categoryList?.length ?? 0, (int i) {
                        List<CartModel> cartModels = cartProvider?.models;
                        print(cartModels);
                        return cartModels?.isEmpty == true
                            ? NoData()
                            : AnimationLimiter(
                                child: AnimatedList(
                                  // key: key,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int j,
                                      Animation animation) {
                                    return AnimationConfiguration.staggeredList(
                                        position: j,
                                        duration:
                                            const Duration(milliseconds: 375),
                                        child: SlideTransition(
                                          position: animation?.drive(tween),
                                          child: SlideAnimation(
                                              verticalOffset: 50.0,
                                              child: FadeInAnimation(
                                                child: buildCartCard(
                                                    cartModels[j], j),
                                              )),
                                        ));
                                    // return buildCollectCard(context, beanList[i], i);
                                  },
                                  // separatorBuilder:
                                  //     (BuildContext context, int i) {
                                  //   return Divider(
                                  //     height: 1,
                                  //   );
                                  // },
                                  initialItemCount: cartModels?.length ?? 0,
                                ),
                              );
                        // : AnimationLimiter(
                        //     child: ListView.separated(
                        //       shrinkWrap: true,
                        //       itemBuilder: (BuildContext context, int i) {
                        //         return AnimationConfiguration.staggeredList(
                        //             position: i,
                        //             duration:
                        //                 const Duration(milliseconds: 375),
                        //             child: SlideAnimation(
                        //                 verticalOffset: 50.0,
                        //                 child: FadeInAnimation(
                        //                   child:
                        //                       buildCartCard(cartModels[i], i),
                        //                 )));
                        //         // return buildCollectCard(context, beanList[i], i);
                        //       },
                        //       separatorBuilder:
                        //           (BuildContext context, int i) {
                        //         return Divider(
                        //           height: 1,
                        //         );
                        //       },
                        //       itemCount: cartModels?.length ?? 0,
                        //     ),
                        //   );
                      })),
              bottomNavigationBar: AnimatedOpacity(
                opacity: provider?.hasModels == true ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Container(
                  decoration: BoxDecoration(
                      color: themeData.primaryColor,
                      border: Border(
                          top: BorderSide(width: .5, color: Colors.grey))),
                  child: Row(
                    children: <Widget>[
                      // Text.rich(textSpan)
                      Checkbox(
                          value: provider?.isAllChecked ?? false,
                          onChanged: (bool isSelected) {
                            provider.checkAll(isSelected);
                          }),
                      Text('全选'),
                      Spacer(),
                      Text(
                          '总价: ￥${provider?.totalAmount?.toStringAsFixed(2) ?? 0.00}元'),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                        child: provider?.isEditting == true
                            ? ZYRaisedButton(
                                '删除所选',
                                () {
                                  batchDelCart(provider);
                                },
                                isActive: provider?.hasSelectedModels,
                              )
                            : ZYRaisedButton('结算(${provider?.totalCount ?? 0})',
                                () {
                                TargetClient.instance.clientId =
                                    provider?.clientId;
                                RouteHandler.goCommitOrderPage(context,
                                    params: jsonEncode(
                                        {'data': provider?.checkedModels}));
                              }),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
