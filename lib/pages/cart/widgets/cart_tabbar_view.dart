import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:taojuwu/models/shop/cart_list_model.dart';
import 'package:taojuwu/pages/goods/curtain/widgets/zy_dialog.dart';
import 'package:taojuwu/providers/cart_provider.dart';
import 'package:taojuwu/providers/end_product_provider.dart';
import 'package:taojuwu/services/otp_service.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/goods_attr_card.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/no_data.dart';
import 'package:taojuwu/widgets/step_counter.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class CartTabBarView extends StatefulWidget {
  final int clientId;
  final String categoryId;

  CartTabBarView({
    Key key,
    this.clientId,
    this.categoryId,
  }) : super(key: key);

  @override
  _CartTabBarViewState createState() => _CartTabBarViewState();
}

class _CartTabBarViewState extends State<CartTabBarView> {
  int get clientId => widget.clientId;
  String get categoryId => widget.categoryId;

  Tween<Offset> tween = Tween<Offset>(
    begin: Offset(1, 0),
    end: Offset(0, 0),
  );
  CartProvider get provider =>
      Provider.of<CartProvider>(context, listen: false);
  bool isLoading = true;
  Widget buildCartCard(CartModel cartModel, int index) {
    return SlideAnimation(
      child: cartModel?.isCustomizedProduct == true
          ? CustomizedProductCard(
              cartModel: cartModel,
              index: index,
              clientId: clientId,
              editAttrCallback: () {
                FocusManager.instance.primaryFocus.unfocus();
                provider?.curCartModel = cartModel;
              },
            )
          : ProductCard(
              cartModel: cartModel,
              index: index,
              clientId: clientId,
              tapCallback: () {
                ZYDialog.checkEndProductAttr(context, cartModel, callback: () {
                  setState(() {});
                  context.read<CartProvider>().refresh();
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
  CartProvider get cartProvider => context.read<CartProvider>();
  List<CartModel> get cartModels => cartProvider?.models ?? [];
  CartListWrapper wrapper;
  void fetchData() {
    print({'client_uid': clientId, 'category_id': categoryId});
    OTPService.cartList(context,
            params: {'client_uid': clientId, 'category_id': categoryId})
        .then((CartListResp response) {
      if (response?.valid == true) {
        wrapper = response?.data;

        // cartProvider?.assignModelList(index, wrapper?.data);
      }
    }).whenComplete(() {
      if (mounted) {
        isLoading = false;

        cartProvider?.models = wrapper?.data;
      }
    });
  }

  RefreshController _refreshController;
  @override
  void initState() {
    super.initState();
    fetchData();
    _refreshController = RefreshController();
  }

  @override
  void dispose() {
    _refreshController?.dispose();

    super.dispose();
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
          child: isLoading
              ? LoadingCircle()
              : cartModels?.isEmpty == true
                  ? NoData()
                  : Container(
                      alignment: Alignment.topCenter,
                      child: AnimationLimiter(
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: false,
                          enablePullUp: false,
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
                            itemCount: cartModels?.isEmpty == true
                                ? 0
                                : cartModels?.length,
                          ),
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
                      provider?.isEditting = false;
                      cartModel?.isChecked = true;
                    });

                    provider.remove(context, cartModel, clientId: clientId,
                        confirm: () {
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

class _ProductCardState extends State<ProductCard>
    with TickerProviderStateMixin {
  int get clientId => widget.clientId;
  CartModel get cartModel => widget.cartModel;
  Function get longPressCallback => widget.longPressCallback;
  Function get tapCallback => widget.tapCallback;
  Function get checkCallback => widget.checkCallback;

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

  void refresh() {
    context?.read<CartProvider>()?.refresh();
  }

  bool visible = true;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

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
                      provider?.isEditting = false;
                      cartModel?.isChecked = true;
                    });

                    provider.remove(context, cartModel, clientId: clientId,
                        confirm: () {
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
                  onTap: tapCallback,
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
                                onChanged: checkCallback),
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
                                mainAxisSize: MainAxisSize.min,
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
                                      Text('￥' + '${cartModel?.price}' ?? '')
                                      // Text.rich(TextSpan(
                                      //     text: '￥' + '${cartModel?.price}' ?? '',
                                      //     children: [TextSpan(text: cartModel?.unit)])),
                                    ],
                                  ),
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Text(
                                          cartModel?.goodsAttrStr ?? '',
                                          softWrap: true,
                                          style: textTheme.caption
                                              .copyWith(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 18,
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.bottomRight,
                                    child: StepCounter(
                                      key: ValueKey(cartModel?.count),
                                      count: cartModel?.count ?? 0,
                                      model: cartModel,
                                      callback: () {
                                        EndProductProvider.editCount(context,
                                            cartModel: cartModel, callback: () {
                                          refresh();
                                        });
                                      },
                                    ),
                                  ))
                                ],
                              ),
                            ))
                          ],
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
