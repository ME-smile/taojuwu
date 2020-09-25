import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/cart_list_model.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';

import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/view/goods/base/bottom_action_bar.dart';
import 'package:taojuwu/view/goods/base/cart_button.dart';
import 'package:taojuwu/view/goods/base/like_button.dart';
import 'package:taojuwu/view/goods/curtain/subPages/pre_measure_data_page.dart';

import 'package:taojuwu/providers/goods_provider.dart';

import 'package:taojuwu/router/handlers.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';

import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/loading.dart';

import 'package:taojuwu/widgets/user_choose_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';

import 'package:taojuwu/widgets/zy_raised_button.dart';

import 'widgets/attr_options_bar.dart';
import '../base/onsale_tag.dart';
import 'widgets/zy_dialog.dart';

typedef AddToCartCallback = Function(Offset endPoint, Key rootKey);

class CurtainDetailPage extends StatefulWidget {
  CurtainDetailPage(
    this.id, {
    Key key,
  }) : super(key: key);

  final int id; //商品id

  @override
  _CurtainDetailPageState createState() => _CurtainDetailPageState();
}

class _CurtainDetailPageState extends State<CurtainDetailPage> with RouteAware {
  Map<String, dynamic> cartParams = {};

  TextEditingController widthInputController;
  TextEditingController heightInputController;
  TextEditingController dyInputController;

  Offset endPoint;
  int id;
  String partType;

  TargetClient targetClient = TargetClient();

  @override
  void dispose() {
    super.dispose();

    widthInputController?.dispose();
    heightInputController?.dispose();
    dyInputController?.dispose();
    Application.routeObserver.unsubscribe(this);
  }

  @override
  void initState() {
    super.initState();
    id = widget.id;
    Future.delayed(Constants.TRANSITION_DURATION, () {
      fetchData();
    });
    widthInputController = TextEditingController();
    heightInputController = TextEditingController();
    dyInputController = TextEditingController();
  }

  @override
  void didPopNext() {
    OTPService.cartCount(context,
            params: {'client_uid': TargetClient().clientId, 'goods_id': id})
        .then((CartCountResp cartCountResp) {
      TargetOrderGoods.instance.goodsProvider?.cartCount = cartCountResp?.data;
    }).catchError((err) => err);
    if (mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    Application.routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  void setCartParams(GoodsProvider goodsProvider) {
    cartParams['is_shade'] = goodsProvider?.isShade == true ? 1 : 0;
    cartParams['estimated_price'] = goodsProvider?.totalPrice;
    cartParams['measure_id'] = goodsProvider?.measureId;
    cartParams['wc_attr'] = '${goodsProvider.attrArgs}';
    cartParams['client_uid'] = TargetClient().clientId;
  }

  Map<String, dynamic> getCartDetail(ProductBean bean) {
    return {
      'sku_id': '${bean?.skuId}' ?? '',
      'goods_id': '${bean?.goodsId}' ?? '',
      'goods_name': '${bean?.goodsName}' ?? '',
      'shop_id': '${bean?.shopId}' ?? '',
      'price': '${bean?.price}' ?? '',
      'picture': '${bean?.picture}' ?? '',
      'num': '1'
    };
  }

  Widget buildWindowGauzeOption() {
    return Consumer<GoodsProvider>(
      builder: (BuildContext context, GoodsProvider goodsProvider, _) {
        return Column(
          children: <Widget>[
            AttrOptionsBar(
              title: '工艺方式',
              trailingText: goodsProvider?.curCraftAttrBean?.name ?? '',
              callback: () {
                ZYDialog.checkAttr(
                    context, '工艺方式', goodsProvider?.curCraftAttrBean);
              },
            ),
            AttrOptionsBar(
              title: '型 材',
              trailingText: goodsProvider?.curPartAttrBean?.name ?? '',
              callback: () {
                ZYDialog.checkAttr(
                    context, '型材更换', goodsProvider?.curPartAttrBean);
              },
            ),
            AttrOptionsBar(
              title: '配 饰',
              // isRollUpWindow: goodsProvider?.isWindowGauze,
              trailingText: goodsProvider?.accText ?? '',
              callback: () {
                ZYDialog.checkAttr(
                    context, '配饰选择', goodsProvider?.curAccessoryAttrBeans);
              },
            ),
          ],
        );
      },
    );
  }

  void checkRoomAttr(BuildContext context) async {
    await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return RoomAttrCheckWrapper();
        });
  }

  void checkWindowPattern(BuildContext context) async {
    await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return WindowStyleCheckWrapper();
        });
  }

  void setSize() {
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ChangeNotifierProvider.value(
              value: TargetOrderGoods.instance.goodsProvider,
              child: Consumer<GoodsProvider>(builder:
                  (BuildContext context, GoodsProvider goodsProvider, _) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  title: Text.rich(
                    TextSpan(text: '请输入尺寸（cm)\n', children: [
                      TextSpan(
                          text: '不足1㎡按1㎡计算',
                          style: Theme.of(context).textTheme.bodyText2),
                    ]),
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 36,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: TextField(
                            controller: widthInputController,
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            decoration: InputDecoration(
                                filled: true,
                                hintText: '请输入宽（cm）',
                                fillColor: const Color(0xFFF2F2F2),
                                contentPadding: EdgeInsets.all(10)),
                          ),
                        ),
                      ),
                      VSpacing(5),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 36,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: TextField(
                            controller: heightInputController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                filled: true,
                                hintText: '请输入高（cm）',
                                fillColor: const Color(0xFFF2F2F2),
                                contentPadding: EdgeInsets.all(10)),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ZYOutlineButton('取消', () {
                            Navigator.of(context).pop();
                          }),
                          SizedBox(
                            width: 40,
                          ),
                          ZYRaisedButton('确定', () {
                            saveSize(goodsProvider);
                          })
                        ],
                      )
                    ],
                  ),
                );
              }),
            );
          });
    } else {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return ChangeNotifierProvider.value(
              value: TargetOrderGoods.instance.goodsProvider,
              child: Consumer<GoodsProvider>(
                builder:
                    (BuildContext context, GoodsProvider goodsProvider, _) {
                  return CupertinoAlertDialog(
                    title: Text.rich(TextSpan(text: '请输入尺寸（cm)\n', children: [
                      TextSpan(
                          text: '不足1㎡按1㎡计算',
                          style: Theme.of(context).textTheme.bodyText2),
                    ])),
                    content: Column(
                      children: <Widget>[
                        CupertinoTextField(
                          controller: widthInputController,
                          keyboardType: TextInputType.number,
                          placeholder: '请输入宽（cm）',
                        ),
                        CupertinoTextField(
                          controller: heightInputController,
                          keyboardType: TextInputType.number,
                          placeholder: '请输入高（cm）',
                        ),
                      ],
                    ),
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
                          saveSize(goodsProvider);
                        },
                      )
                    ],
                  );
                },
              ),
            );
          });
    }
  }

  void saveSize(GoodsProvider goodsProvider) {
    String w = widthInputController?.text?.trim();
    String h = heightInputController?.text?.trim();
    if (w?.isNotEmpty != true ||
        h?.isNotEmpty != true ||
        double.parse(w ?? '0.00') == 0 ||
        double.parse(h ?? '0.00') == 0) {
      return ToastKit.showInfo('请输入正确的尺寸');
    }
    goodsProvider?.hasSetSize = true;
    goodsProvider?.width = widthInputController?.text;
    goodsProvider?.height = heightInputController?.text;

    Navigator.of(context).pop();
  }

  void saveDy(GoodsProvider goodsProvider) {
    goodsProvider?.dy = dyInputController?.text;
    goodsProvider?.measureData?.verticalGroundHeight = dyInputController?.text;
    Navigator.of(context).pop();
  }

  void setDy() {
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ChangeNotifierProvider.value(
              value: TargetOrderGoods.instance.goodsProvider,
              child: Consumer<GoodsProvider>(
                builder:
                    (BuildContext context, GoodsProvider goodsProvider, _) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    title: Text(
                      '离地距离（cm）',
                      textAlign: TextAlign.center,
                    ),
                    titleTextStyle:
                        TextStyle(fontSize: 16, color: Color(0xFF333333)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 36,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: TextField(
                              controller: dyInputController,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  filled: true,
                                  hintText: '请输入离地距离（cm）',
                                  fillColor: const Color(0xFFF2F2F2),
                                  contentPadding: EdgeInsets.all(10)),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ZYOutlineButton('取消', () {
                              Navigator.of(context).pop();
                            }),
                            SizedBox(
                              width: 40,
                            ),
                            ZYRaisedButton('确定', () {
                              saveDy(goodsProvider);
                            })
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          });
    } else {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return ChangeNotifierProvider.value(
              value: TargetOrderGoods.instance.goodsProvider,
              child: Consumer<GoodsProvider>(
                builder:
                    (BuildContext context, GoodsProvider goodsProvider, _) {
                  return CupertinoAlertDialog(
                    title: Text('离地距离（cm）'),
                    content: Column(
                      children: <Widget>[
                        CupertinoTextField(
                          controller: dyInputController,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          placeholder: '请输入离地距离（cm）',
                        ),
                      ],
                    ),
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
                          saveDy(goodsProvider);
                        },
                      )
                    ],
                  );
                },
              ),
            );
          });
    }
  }

  Widget buildWindowRollerOption() {
    return TargetOrderGoods.instance.isMeasureOrder == true
        ? Consumer<GoodsProvider>(
            builder: (BuildContext context, GoodsProvider goodsProvider, _) {
              return Column(
                children: <Widget>[
                  AttrOptionsBar(
                    title: '空间',
                    trailingText: goodsProvider?.measureData?.installRoom ?? '',
                    callback: null,
                    showNext: false,
                  ),
                  AttrOptionsBar(
                    title: '窗型',
                    trailingText: goodsProvider?.measureData?.windowType ?? '',
                    callback: null,
                    showNext: false,
                  ),
                  AttrOptionsBar(
                    title: '尺寸',
                    // isRollUpWindow: goodsProvider?.isWindowGauze,
                    trailingText:
                        '${goodsProvider?.widthCMStr ?? ''}米,${goodsProvider?.heightCMStr ?? ''}米',
                    callback: null,
                    showNext: false,
                  ),
                  AttrOptionsBar(
                    title: '离地距离',
                    // isRollUpWindow: goodsProvider?.isWindowGauze,
                    trailingText: '${goodsProvider?.dyCMStr ?? ''}cm',
                    callback: () {
                      setDy();
                    },
                  ),
                ],
              );
            },
          )
        : Consumer<GoodsProvider>(
            builder: (BuildContext context, GoodsProvider goodsProvider, _) {
              return Column(
                children: <Widget>[
                  AttrOptionsBar(
                    title: '空间',
                    trailingText: goodsProvider?.curRoomAttrBean?.name ?? '',
                    callback: () {
                      checkRoomAttr(context);
                    },
                  ),
                  AttrOptionsBar(
                    title: '窗型',
                    trailingText: goodsProvider?.windowPatternStr ?? '',
                    callback: () {
                      checkWindowPattern(context);
                    },
                  ),
                  AttrOptionsBar(
                    title: '尺寸',
                    // isRollUpWindow: goodsProvider?.isWindowGauze,
                    trailingText: goodsProvider?.sizeText,
                    callback: () {
                      setSize();
                    },
                  ),
                  AttrOptionsBar(
                    title: '离地距离',
                    // isRollUpWindow: goodsProvider?.isWindowGauze,
                    trailingText: '${goodsProvider?.dyCMStr ?? ''}cm',
                    callback: () {
                      setDy();
                    },
                  ),
                ],
              );
            },
          );
  }

  Widget buildCurtainOption() {
    return Consumer<GoodsProvider>(
      builder: (BuildContext context, GoodsProvider goodsProvider, _) {
        return Column(
          children: <Widget>[
            AttrOptionsBar(
              title: '窗 纱',
              trailingText: goodsProvider?.curWindowGauzeAttrBean?.name ?? '',
              callback: () {
                ZYDialog.checkAttr(
                    context, '窗纱选择', goodsProvider?.curWindowGauzeAttrBean);
              },
            ),
            AttrOptionsBar(
              title: '工艺方式',
              trailingText: goodsProvider?.curCraftAttrBean?.name ?? '',
              callback: () {
                ZYDialog.checkAttr(
                    context, '工艺方式', goodsProvider?.curCraftAttrBean);
              },
            ),
            AttrOptionsBar(
              title: '型 材',
              trailingText: goodsProvider?.curPartAttrBean?.name ?? '',
              callback: () {
                ZYDialog.checkAttr(
                    context, '型材更换', goodsProvider?.curPartAttrBean);
              },
            ),
            AttrOptionsBar(
              title: '里布',
              trailingText: goodsProvider?.curWindowShadeAttrBean?.name ?? '',
              callback: () {
                ZYDialog.checkAttr(
                    context, '里布选择', goodsProvider?.curWindowShadeAttrBean);
              },
            ),
            AttrOptionsBar(
              title: '幔 头',
              trailingText: goodsProvider?.curCanopyAttrBean?.name ?? '',
              callback: () {
                ZYDialog.checkAttr(
                    context, '幔头选择', goodsProvider?.curCanopyAttrBean);
              },
            ),
            AttrOptionsBar(
              title: '配 饰',
              // isRollUpWindow: goodsProvider?.isWindowGauze,
              trailingText: goodsProvider?.accText ?? '',
              callback: () {
                ZYDialog.checkAttr(
                    context, '配饰选择', goodsProvider?.curAccessoryAttrBeans);
              },
            ),
          ],
        );
      },
    );
  }

  void addCart(BuildContext ctx, GoodsProvider provider) {
    cartParams.addAll({'wc_attr': jsonEncode(provider.attrArgs)});
    cartParams
        .addAll({'cart_detail': jsonEncode(getCartDetail(provider?.goods))});
    OTPService.addCart(params: cartParams)
        .then((ZYResponse response) {})
        .catchError((err) => err);
  }

  bool beforePurchase(GoodsProvider goodsProvider) {
    if (TargetClient().hasSelectedClient == false) {
      ToastKit.showInfo('请选择客户');
      return false;
    }
    if (goodsProvider?.hasSetSize != true) {
      ToastKit.showInfo('请先填写尺寸');
      return false;
    }
    return true;
  }

  ProductBean bean;
  void initData(data, GoodsProvider goodsProvider) {
    OrderGoodsMeasure measureData = data[0];
    ProductBeanRes productBeanRes = data[1];
    ProductBeanDataWrapper wrapper = productBeanRes.data;
    bean = wrapper.goodsDetail;
    CartCountResp cartCountResp = data[9];
    goodsProvider?.initDataWithFilter(
        measureData: measureData,
        bean: bean,
        windowGauzeAttr: data[2],
        craftAttr: data[3],
        partAttr: data[4],
        windowShadeAttr: data[5],
        canopyAttr: data[6],
        accessoryAttr: data[7],
        roomAttr: data[8],
        cartCount: cartCountResp?.data);
    setCartParams(goodsProvider);
  }

  bool isLoading = true;
  GoodsProvider goodsProvider;
  void fetchData() {
    OTPService.fetchCurtainDetailData(context, params: {
      'goods_id': widget.id,
    })
        .then((data) {
          goodsProvider = GoodsProvider();
          initData(data, goodsProvider);
          TargetOrderGoods.instance.setGoodsProvider(goodsProvider);
        })
        .catchError((err) => err)
        .whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

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
          : ChangeNotifierProvider(
              create: (BuildContext context) {
                return goodsProvider;
              },
              child: Consumer<GoodsProvider>(
                builder:
                    (BuildContext context, GoodsProvider goodsProvider, _) {
                  return WillPopScope(
                      child: Scaffold(
                          // key: rootKey,
                          body: NestedScrollView(
                              headerSliverBuilder: (BuildContext context,
                                  bool innerBoxIsScrolled) {
                                return <Widget>[
                                  SliverAppBar(
                                    actions: <Widget>[
                                      UserChooseButton(
                                        id: widget.id,
                                      )
                                    ],
                                    expandedHeight: 320,
                                    floating: false,
                                    pinned: true,
                                    flexibleSpace: FlexibleSpaceBar(
                                      background: Container(
                                          // padding: EdgeInsets.symmetric(
                                          //     horizontal: UIKit.width(50),
                                          //     vertical: UIKit.height(20)),
                                          margin: EdgeInsets.only(top: 80),
                                          child: ZYNetImage(
                                            imgPath: bean?.picCoverBig,
                                            width: 300,
                                            height: 240,
                                            needAnimation: false,
                                          )
                                          // decoration: BoxDecoration(
                                          //   image: DecorationImage(
                                          //       image: NetworkImage(
                                          // UIKit.getNetworkImgPath(
                                          //     bean?.picCoverMid))),
                                          // ),
                                          ),
                                    ),
                                  )
                                ];
                              },
                              body: CustomScrollView(
                                slivers: <Widget>[
                                  SliverToBoxAdapter(
                                    child: Container(
                                      color: themeData.primaryColor,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: UIKit.width(20),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // VSpacing(20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text.rich(TextSpan(
                                                  text: '${bean?.goodsName} ' ??
                                                      '',
                                                  style: TextStyle(
                                                      fontSize: UIKit.sp(28),
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  children: [
                                                    TextSpan(
                                                        text: bean?.goodsName ??
                                                            '',
                                                        style:
                                                            textTheme.caption)
                                                  ])),
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 20),
                                                      child: LikeButton(
                                                        goodsId: id,
                                                        clientId: TargetClient
                                                            .instance.clientId,
                                                        hasLiked: goodsProvider
                                                                ?.hasLike ??
                                                            false,
                                                        callback: () {
                                                          goodsProvider
                                                              ?.like(widget.id);
                                                        },
                                                      ),
                                                    ),
                                                    CartButton(
                                                      // key: cartKey,
                                                      count: goodsProvider
                                                          ?.cartCount,
                                                      callback: () {
                                                        if (TargetClient()
                                                                .hasSelectedClient ==
                                                            false) {
                                                          return ToastKit
                                                              .showInfo(
                                                                  '请选择客户');
                                                        }
                                                        RouteHandler.goCartPage(
                                                            context,
                                                            clientId:
                                                                TargetClient
                                                                    .instance
                                                                    .clientId);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              )
                                              // Text.rich(
                                              //     TextSpan(text: '', children: [
                                              //   WidgetSpan(
                                              //       child: ValueListenableBuilder(
                                              //           valueListenable:
                                              //               hasCollected,
                                              //           builder:
                                              //               (BuildContext context,
                                              //                   bool isLiked, _) {
                                              //             return InkWell(
                                              //                 child: Icon(
                                              //                   ZYIcon.like,
                                              //                   size: 18,
                                              //                   color: isLiked
                                              //                       ? Colors.red
                                              //                       : const Color(
                                              //                           0xFFCCCCCC),
                                              //                 ),
                                              //                 onTap: () {
                                              //                   collect(context);
                                              //                 });
                                              //           })),
                                              //   WidgetSpan(
                                              //       child: SizedBox(
                                              //           width: UIKit.width(30))),
                                              //   WidgetSpan(
                                              //       child: InkWell(
                                              //           child: Icon(ZYIcon.cart,
                                              //               size: 18),
                                              //           onTap: () {
                                              //             if (targetClient
                                              //                     .hasSelectedClient ==
                                              //                 false) {
                                              //               return CommonKit
                                              //                   .showInfo(
                                              //                       '请选择客户');
                                              //             }
                                              //             RouteHandler.goCartPage(
                                              //               context,
                                              //               clientId: targetClient
                                              //                   .clientId,
                                              //             );
                                              //           }))
                                              // ]))
                                            ],
                                          ),
                                          VSpacing(20),
                                          Text.rich(TextSpan(
                                              text: '¥${bean?.price ?? 0.00}',
                                              style: TextStyle(
                                                  fontSize: UIKit.sp(32),
                                                  fontWeight: FontWeight.w500),
                                              children: [
                                                TextSpan(
                                                    text: goodsProvider?.unit,
                                                    style: textTheme.caption),
                                                TextSpan(text: ' '),
                                                TextSpan(
                                                    text: bean?.isPromotionGoods ==
                                                            true
                                                        ? '¥${bean?.marketPrice}'
                                                        : '',
                                                    style: textTheme.caption
                                                        .copyWith(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough)),
                                                WidgetSpan(
                                                    child: Offstage(
                                                  offstage:
                                                      bean?.isPromotionGoods ==
                                                          false,
                                                  child: OnSaleTag(),
                                                ))
                                              ])),
                                          VSpacing(20),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: VSpacing(20),
                                  ),
                                  SliverToBoxAdapter(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: UIKit.width(20),
                                          vertical: UIKit.height(10)),
                                      color: themeData.primaryColor,
                                      child: Column(
                                        children: <Widget>[
                                          Offstage(
                                            offstage:
                                                goodsProvider?.isWindowRoller ==
                                                    true,
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: UIKit.height(10)),
                                                alignment: Alignment.centerLeft,
                                                child: MeasureDataTipBar()),
                                          ),
                                          Offstage(
                                            offstage:
                                                goodsProvider?.isWindowRoller ==
                                                    true,
                                            child: Divider(),
                                          ),
                                          goodsProvider?.isWindowGauze == true
                                              ? buildWindowGauzeOption()
                                              : goodsProvider?.isWindowRoller ==
                                                      true
                                                  ? buildWindowRollerOption()
                                                  : buildCurtainOption(),
                                          Container(
                                            color: themeData
                                                .scaffoldBackgroundColor,
                                            height: UIKit.height(20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: bean?.description?.isNotEmpty == true
                                        ? Html(data: bean?.description)
                                        : Container(),
                                  )
                                ],
                              )),
                          bottomNavigationBar: BottomActionButtonBar(
                              // rootKey: rootKey,
                              // cartKey: cartKey,
                              )),
                      onWillPop: () {
                        Navigator.of(context).pop();
                        TargetOrderGoods.instance.clear();

                        return Future.value(false);
                      });
                },
              ),
            ),
    );
  }
}

class BottomActionButtonBar extends StatelessWidget {
  final GlobalKey rootKey;
  final GlobalKey cartKey;
  const BottomActionButtonBar({Key key, this.rootKey, this.cartKey})
      : super(key: key);

  // void setParams(GoodsProvider provider) {
  //   params['dataId'] = '${provider?.windowPatternId ?? ''}';
  //   params['width'] = '${provider?.widthCMStr ?? ''}';
  //   params['height'] = '${provider?.heightCMStr ?? ''}';
  //   params['vertical_ground_height'] = '${provider?.dy ?? ''}';
  //   params['goods_id'] = '${provider?.goodsId ?? ''}';
  //   params['install_room'] = '${provider?.curRoomAttrBean?.id ?? ''}';
  //   data.clear();
  //   data['${provider?.windowPatternId ?? ''}'] = {
  //     'name': '${provider?.windowPatternStr ?? ''}',
  //     'selected': {
  //       '安装选项': ['${provider?.curInstallMode ?? ''}'],
  //       '打开方式': provider?.openModeParams
  //     }
  //   };

  //   params['data'] = jsonEncode(data);
  // }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    // TextTheme textTheme = themeData.textTheme;

    return Consumer<GoodsProvider>(
      builder: (BuildContext context, GoodsProvider goodsProvider, _) {
        return TargetOrderGoods.instance.isMeasureOrder
            ? Container(
                color: themeData.primaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: UIKit.width(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text.rich(TextSpan(text: '预计:\n', children: [
                      TextSpan(text: '¥${goodsProvider?.totalPrice ?? 0.00}'),
                    ])),
                    ZYRaisedButton(
                      '确认选品',
                      () {
                        goodsProvider?.selectProduct(context);
                      },
                      horizontalPadding: 32,
                      verticalPadding: 8,
                      fontsize: 16,
                    )
                  ],
                ))
            : PurchaseActionBar(
                totalPrice: goodsProvider?.totalPrice ?? '0.00',
                rootKey: rootKey,
                cartKey: cartKey,
                addToCartFunc: () {
                  goodsProvider?.addCart(context);
                },
                canAddToCart: goodsProvider?.canAddToCart ?? true,
                purchaseFunc: () {
                  goodsProvider?.createOrder(context);
                },
              );
      },
    );
  }
}

class MeasureDataTipBar extends StatelessWidget {
  const MeasureDataTipBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Consumer<GoodsProvider>(
        builder: (BuildContext context, GoodsProvider goodsProvider, _) {
      return goodsProvider?.isMeasureOrderGoods == true
          ? InkWell(
              onTap: () {
                RouteHandler.goMeasureDataPreviewPage(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                        text: '*  ',
                        style: TextStyle(color: Color(0xFFE02020)),
                        children: [
                          TextSpan(
                              text: TargetOrderGoods
                                          .instance.hasConfirmMeasureData ==
                                      true
                                  ? '已确认测装数据'
                                  : '请确认测装数据',
                              style: textTheme.bodyText2),
                        ]),
                  ),
                  Spacer(),
                  Text(
                    TargetOrderGoods.instance.hasConfirmMeasureData == true
                        ? goodsProvider?.measureDataStr ?? ''
                        : '',
                    textAlign: TextAlign.end,
                  ),
                  Icon(ZYIcon.next)
                ],
              ))
          : InkWell(
              onTap: () {
                RouteHandler.goPreMeasureDataPage(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                        text: '*  ',
                        style: TextStyle(color: Color(0xFFE02020)),
                        children: [
                          TextSpan(
                              text: goodsProvider?.hasSetSize == true
                                  ? '已预填测装数据'
                                  : '请预填测装数据',
                              style: textTheme.bodyText2),
                        ]),
                  ),
                  Spacer(),
                  Text(
                    goodsProvider?.hasSetSize == true
                        ? goodsProvider?.measureDataStr ?? ''
                        : '',
                    textAlign: TextAlign.end,
                  ),
                  Icon(ZYIcon.next)
                ],
              ),
            );
    });
  }
}
