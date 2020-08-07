import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/application.dart';

import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/shop/cart_list_model.dart';

import 'package:taojuwu/pages/goods/curtain/widgets/zy_dialog.dart';

import 'package:taojuwu/providers/cart_provider.dart';

import 'package:taojuwu/router/handlers.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/goods_attr_card.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/no_data.dart';
import 'package:taojuwu/widgets/step_counter.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class CartPage extends StatefulWidget {
  final int clientId;
  CartPage({Key key, this.clientId}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with TickerProviderStateMixin, RouteAware {
  CartProvider _cartProvider = CartProvider();
  CartProvider get cartProvider => _cartProvider;
  int get clientId => widget.clientId;
  TabController tabController;

  bool isLoading = true;
  List<List<CartModel>> modelsList;
  List<CartModel> get models => cartProvider?.models;

  // GlobalKey<AnimatedListState> get animatedListKey =>
  //     keyList[tabController?.index ?? 0];

  List<CartCategory> categoryList;
  CartCategory get curCategory => categoryList == null
      ? CartCategory('全部', 0)
      : categoryList[tabController?.index ?? 0];
  get categoryId => curCategory?.id;
  CartModel curCartModel;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: cartProvider?.categoryList?.length, vsync: this);
    Future.delayed(Constants.TRANSITION_DURATION, () {
      fetchData().whenComplete(() {});
    });
  }

  CartListWrapper wrapper;
  Future fetchData() {
    return OTPService.fetchCartData(context,
            params: {'client_uid': clientId, 'category_id': categoryId ?? 0})
        .then((CartListResp response) {
          if (response?.valid == true) {
            wrapper = response?.data;
            categoryList = wrapper?.categoryList;
            tabController =
                TabController(length: categoryList?.length ?? 0, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) {
        return CartProvider();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('购物车'),
            centerTitle: true,
            actions: <Widget>[
              Selector(builder: (BuildContext context, bool isEditting, _) {
                return FlatButton(
                    onPressed: () {
                      CartProvider provider = context.read<CartProvider>();
                      provider?.isEditting = !provider.isEditting;
                    },
                    child: Text(isEditting == true ? '完成' : '编辑'));
              }, selector: (BuildContext context, CartProvider provider) {
                return provider?.isEditting;
              })
            ],
            bottom: PreferredSize(
                child: Consumer<CartProvider>(
                  builder: (BuildContext context, CartProvider provider, _) {
                    return TabBar(
                        controller: tabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        unselectedLabelStyle:
                            TextStyle(color: Color(0xFF333333), fontSize: 14),
                        labelStyle: TextStyle(
                            color: Color(0xFF1B1B1B),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        labelPadding:
                            EdgeInsets.only(bottom: 5, left: 5, right: 5),
                        tabs: List.generate(provider?.categoryList?.length ?? 0,
                            (int i) {
                          CartCategory bean = provider?.categoryList[i];
                          return Text('${bean?.name}(${bean?.count})');
                        }));
                  },
                ),
                preferredSize: Size.fromHeight(20)),
          ),
          body: Builder(builder: (BuildContext context) {
            cartProvider?.setData(
                List.filled(categoryList?.length ?? 0, []), categoryList);
            cartProvider?.assignModelList(0, wrapper?.data);
            return isLoading
                ? LoadingCircle()
                : TabBarView(
                    controller: tabController,
                    children: List.generate(categoryList?.length ?? 0, (int i) {
                      int id = int.parse(categoryList[i]?.id ?? '0');
                      return CartTabBarView(
                        clientId: clientId,
                        categoryId: id,
                        index: i,
                        requestData: i != 0,
                      );
                    }));
          }),
          bottomNavigationBar: Consumer(
            builder: (BuildContext context, CartProvider provider, _) {
              return AnimatedOpacity(
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
                                  // batchDelCart(provider);
                                  provider
                                      ?.batchRemoveGoods(context)
                                      ?.then((_) {
                                    setState(() {});
                                  });
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
              );
            },
          )),
    );
  }
}

class CartTabBarView extends StatefulWidget {
  final int clientId;
  final int categoryId;
  final int index;
  final bool requestData;
  CartTabBarView(
      {Key key,
      this.clientId,
      this.categoryId,
      this.requestData = true,
      this.index = 0})
      : super(key: key);

  @override
  _CartTabBarViewState createState() => _CartTabBarViewState();
}

class _CartTabBarViewState extends State<CartTabBarView> with RouteAware {
  int get clientId => widget.clientId;
  int get categoryId => widget.categoryId;
  int get index => widget.index;
  bool get requestData => widget.requestData;
  Tween<Offset> tween = Tween<Offset>(
    begin: Offset(1, 0),
    end: Offset(0, 0),
  );
  CartProvider get provider =>
      Provider.of<CartProvider>(context, listen: false);
  Widget buildCartCard(CartModel cartModel, int index) {
    return SlideAnimation(
      key: ObjectKey(cartModel),
      child: cartModel?.isCustomizedProduct == true
          ? CustomizedProductCard(
              cartModel: cartModel,
              index: index,
              clientId: clientId,
            )
          : ProductCard(
              cartModel: cartModel,
              index: index,
              tapCallback: () {
                ZYDialog.checkEndProductAttr(context, cartModel, callback: () {
                  Navigator.of(context).pop();
                  setState(() {});
                });
              },
              checkCallback: (bool isSelected) {
                provider?.checkGoods(cartModel, isSelected);
              },
            ),
    );
  }

  CartModel curCartModel;
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  CartProvider get cartProvider =>
      Provider.of<CartProvider>(context, listen: false);
  List<CartModel> get cartModels => cartProvider?.models;
  void fetchCartList() {
    OTPService.fetchCartData(context,
            params: {'client_uid': clientId, 'category_id': categoryId})
        .then((CartListResp response) {
          if (response?.valid == true) {
            CartListWrapper wrapper = response?.data;

            cartProvider?.assignModelList(index, wrapper?.data);
            // cartProvider?.setData(wrapper?.data);
            // modelsList[tabController?.index] = wrapper?.data;
          }
        })
        .catchError((err) => err)
        .whenComplete(() {
          if (mounted) {
            setState(() {
              // isLoading = false;
            });
          }
        });
  }

  @override
  void initState() {
    super.initState();

    if (requestData) {}
    fetchCartList();
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
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, CartProvider provider, _) {
        return PageTransitionSwitcher(
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: cartModels?.isEmpty == true
              ? NoData()
              : Container(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      // key: key,
                      shrinkWrap: true,
                      itemBuilder: (
                        BuildContext context,
                        int j,
                      ) {
                        return AnimationConfiguration.staggeredList(
                            position: j,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: buildCartCard(cartModels[j], j),
                                )));
                        // return buildCollectCard(context, beanList[i], i);
                      },
                      itemCount:
                          cartModels?.isEmpty == true ? 0 : cartModels?.length,
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class CustomizedProductCard extends StatefulWidget {
  final CartModel cartModel;
  final int index;
  final int clientId;

  final Function tapCallback;

  final Function editAttrCallback;
  CustomizedProductCard(
      {Key key,
      this.cartModel,
      this.index,
      this.clientId,
      this.tapCallback,
      this.editAttrCallback})
      : super(key: key);

  @override
  CustomizedProductCardState createState() => CustomizedProductCardState();
}

class CustomizedProductCardState extends State<CustomizedProductCard>
    with TickerProviderStateMixin {
  int get clientId => widget.clientId;
  CartModel get cartModel => widget.cartModel;
  Function get tapCallback => widget.tapCallback;
  Function get editAttrCallback => widget.editAttrCallback;

  AnimationController slideAnimationController;
  AnimationController sizeAnimationController;
  Animation<Offset> slideAnimation;
  Animation<double> sizeAnimation;

  @override
  void initState() {
    slideAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    sizeAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    slideAnimation = Tween(begin: Offset(0.0, 0.0), end: Offset(1.0, 0.0))
        .animate(slideAnimationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              sizeAnimationController?.forward();
            }
          });
    sizeAnimation =
        Tween(begin: 1.0, end: 0.0).animate(sizeAnimationController);

    super.initState();
  }

  @override
  void dispose() {
    slideAnimationController?.dispose();
    sizeAnimationController?.dispose();
    super.dispose();
  }

  bool visible = true;
  bool isSliding = false;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    // return SizeTransition(sizeFactor: null);
    return SizeTransition(
      sizeFactor: sizeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: Consumer(
            builder: (BuildContext context, CartProvider provider, Widget _) {
              return GestureDetector(
                  onLongPress: () {
                    setState(() {
                      cartModel?.isChecked = true;
                    });
                    provider.remove(context, cartModel, confirm: () {
                      setState(() {
                        visible = false;
                        slideAnimationController?.forward();
                      });
                    }, cancel: () {
                      setState(() {
                        cartModel?.isChecked = false;
                        visible = true;
                      });
                      Navigator.of(context).pop();
                    });
                  },
                  child: Container(
                    color: themeData.primaryColor,
                    margin: EdgeInsets.only(top: UIKit.height(20)),
                    padding: EdgeInsets.symmetric(
                        horizontal: UIKit.width(20),
                        vertical: UIKit.height(20)),
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
                              margin: EdgeInsets.symmetric(
                                  horizontal: UIKit.width(20)),
                              height: UIKit.height(190),
                              // width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        cartModel?.goodsName ?? '',
                                        style: textTheme.headline6
                                            .copyWith(fontSize: UIKit.sp(28)),
                                      ),
                                      Text.rich(TextSpan(
                                          text:
                                              '￥' + '${cartModel?.price}' ?? '',
                                          children: [
                                            TextSpan(text: cartModel?.unit)
                                          ])),
                                    ],
                                  ),
                                  Expanded(
                                    child: Text(
                                      cartModel?.goodsAttrStr ?? '',
                                      softWrap: true,
                                      style: textTheme.caption
                                          .copyWith(fontSize: 12),
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
                          callback: editAttrCallback,
                        ),
                        Text.rich(
                          TextSpan(text: '预计总金额', children: [
                            TextSpan(
                                text: '￥' +
                                        (double.parse(
                                                cartModel?.estimatedPrice ??
                                                    '0.00'))
                                            .toStringAsFixed(2) ??
                                    '',
                                style: TextStyle(
                                    fontSize: UIKit.sp(32),
                                    fontWeight: FontWeight.w500))
                          ]),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final CartModel cartModel;
  final int index;
  final int clientId;
  final Function longPressCallback;
  final Function tapCallback;
  final Function checkCallback;

  ProductCard({
    Key key,
    this.cartModel,
    this.index,
    this.clientId,
    this.longPressCallback,
    this.tapCallback,
    this.checkCallback,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int get clientId => widget.clientId;
  CartModel get cartModel => widget.cartModel;
  Function get longPressCallback => widget.longPressCallback;
  Function get tapCallback => widget.tapCallback;
  Function get checkCallback => widget.checkCallback;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    return Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider provider, _) {
      return GestureDetector(onLongPress: () {
        longPressCallback();
        setState(() {
          cartModel?.isChecked = true;
        });
      }, onTap: () {
        ZYDialog.checkEndProductAttr(context, cartModel, callback: () {
          Navigator.of(context).pop();
          setState(() {});
        });
      }, child: Builder(builder: (BuildContext ctx) {
        ctx = ctx;
        return Container(
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
                      value: cartModel?.isChecked, onChanged: checkCallback),
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
        );
      }));
    });
  }
}
