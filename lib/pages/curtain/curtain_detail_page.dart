import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/models/shop/product_bean.dart';

import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/pages/curtain/subPages/pre_measure_data_page.dart';

import 'package:taojuwu/providers/goods_provider.dart';

import 'package:taojuwu/router/handlers.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';

import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';

import 'package:taojuwu/widgets/user_choose_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';

import 'package:taojuwu/widgets/zy_raised_button.dart';

import 'widgets/attr_options_bar.dart';
import 'widgets/onsale_tag.dart';
import 'widgets/zy_dialog.dart';

class CurtainDetailPage extends StatefulWidget {
  CurtainDetailPage(
    this.id, {
    Key key,
  }) : super(key: key);

  final int id; //商品id

  @override
  _CurtainDetailPageState createState() => _CurtainDetailPageState();
}

class _CurtainDetailPageState extends State<CurtainDetailPage> {
  Map<String, dynamic> cartParams = {};
  Map<String, dynamic> collectParams = {};

  TextEditingController widthInputController;
  TextEditingController heightInputController;
  TextEditingController dyInputController;

  int id;
  String partType;
  ValueNotifier<bool> hasCollected;

  TargetClient targetClient = TargetClient.instance;

  @override
  void dispose() {
    super.dispose();
    hasCollected?.dispose();
    widthInputController?.dispose();
    heightInputController?.dispose();
    dyInputController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    id = widget.id;

    widthInputController = TextEditingController();
    heightInputController = TextEditingController();
    dyInputController = TextEditingController();
    hasCollected = ValueNotifier<bool>(false);
  }

  void setCartParams(GoodsProvider goodsProvider) {
    cartParams['is_shade'] = goodsProvider?.isShade == true ? 1 : 0;
    cartParams['estimated_price'] = goodsProvider?.totalPrice;
    cartParams['measure_id'] = goodsProvider?.measureId;
    cartParams['wc_attr'] = '${goodsProvider.getAttrArgs()}';
    cartParams['client_uid'] = TargetClient.instance.clientId;
  }

  collect(
    BuildContext context,
  ) {
    // final Completer<bool> completer = new Completer<bool>();
    if (!TargetClient.instance.hasSelectedClient) {
      CommonKit.showInfo('请选择客户');
      return;
    }
    collectParams = {
      // 'fav_type':'goods',
      'fav_id': widget.id,
      'client_uid': TargetClient.instance.clientId
    };
    if (hasCollected?.value == false) {
      OTPService.collect(params: collectParams).then((ZYResponse response) {
        if (response?.valid == true) {
          hasCollected.value = true;
        }
      }).catchError((err) => err);
    } else {
      OTPService.cancelCollect(params: collectParams)
          .then((ZYResponse response) {
        if (response?.valid == true) {
          hasCollected.value = false;
        }
      }).catchError((err) => err);
    }
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
                          style: Theme.of(context).textTheme.body1),
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
                          style: Theme.of(context).textTheme.body1),
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
      return CommonKit.showInfo('请输入正确的尺寸');
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
    cartParams.addAll({'wc_attr': jsonEncode(provider.getAttrArgs())});
    cartParams
        .addAll({'cart_detail': jsonEncode(getCartDetail(provider?.goods))});
    OTPService.addCart(params: cartParams)
        .then((ZYResponse response) {})
        .catchError((err) => err);
  }

  bool beforePurchase(GoodsProvider goodsProvider) {
    if (TargetClient.instance.hasSelectedClient == false) {
      CommonKit.showInfo('请选择客户');
      return false;
    }
    if (goodsProvider?.hasSetSize != true) {
      CommonKit.showInfo('请先填写尺寸');
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
    );
    setCartParams(goodsProvider);
    hasCollected?.value = goodsProvider?.hasLike;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    return ZYFutureBuilder(
        futureFunc: OTPService.fetchCurtainDetailData,
        params: {
          'goods_id': widget.id,
        },
        builder: (BuildContext context, data) {
          return ChangeNotifierProvider(
            create: (BuildContext context) {
              GoodsProvider goodsProvider = GoodsProvider();
              initData(data, goodsProvider);
              TargetOrderGoods.instance.setGoodsProvider(goodsProvider);
              return goodsProvider;
            },
            child: Consumer<GoodsProvider>(
              builder: (BuildContext context, GoodsProvider goodsProvider, _) {
                return WillPopScope(
                    child: Scaffold(
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
                                  expandedHeight: 400,
                                  floating: false,
                                  pinned: true,
                                  flexibleSpace: FlexibleSpaceBar(
                                    background: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: UIKit.width(50),
                                            vertical: UIKit.height(20)),
                                        margin: EdgeInsets.only(top: 80),
                                        child: ZYNetImage(
                                          imgPath: bean?.picCoverMid,
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
                                        VSpacing(20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text.rich(TextSpan(
                                                text:
                                                    '${bean?.goodsName} ' ?? '',
                                                style: TextStyle(
                                                    fontSize: UIKit.sp(28),
                                                    fontWeight:
                                                        FontWeight.w400),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          bean?.goodsName ?? '',
                                                      style: textTheme.caption)
                                                ])),
                                            Text.rich(
                                                TextSpan(text: '', children: [
                                              WidgetSpan(
                                                  child: ValueListenableBuilder(
                                                      valueListenable:
                                                          hasCollected,
                                                      builder:
                                                          (BuildContext context,
                                                              bool isLiked, _) {
                                                        return InkWell(
                                                            child: Icon(
                                                              ZYIcon.like,
                                                              size: 18,
                                                              color: isLiked
                                                                  ? Colors.red
                                                                  : const Color(
                                                                      0xFFCCCCCC),
                                                            ),
                                                            onTap: () {
                                                              collect(context);
                                                            });
                                                      })),
                                              WidgetSpan(
                                                  child: SizedBox(
                                                      width: UIKit.width(30))),
                                              WidgetSpan(
                                                  child: InkWell(
                                                      child: Icon(ZYIcon.cart,
                                                          size: 18),
                                                      onTap: () {
                                                        if (targetClient
                                                                .hasSelectedClient ==
                                                            false) {
                                                          return CommonKit
                                                              .showInfo(
                                                                  '请选择客户');
                                                        }
                                                        RouteHandler.goCartPage(
                                                          context,
                                                          clientId: targetClient
                                                              .clientId,
                                                        );
                                                      }))
                                            ]))
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
                                          color:
                                              themeData.scaffoldBackgroundColor,
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
                        bottomNavigationBar: BottomActionButtonBar()),
                    onWillPop: () {
                      Navigator.of(context).pop();
                      TargetOrderGoods.instance.clear();
                      TargetOrderGoods.instance.goodsProvider.release();
                      return Future.value(false);
                    });
              },
            ),
          );
        });
  }
}

class BottomActionButtonBar extends StatelessWidget {
  const BottomActionButtonBar({Key key}) : super(key: key);

  static Map<String, dynamic> data = {};
  static Map<String, dynamic> params = {
    'dataId': '',
    'width': '',
    'height': '',
    'install_room': '',
    'goods_id': '',
    'vertical_ground_height': '',
    'data': {},
  };
  void setParams(GoodsProvider provider) {
    params['dataId'] = '${provider?.windowPatternId ?? ''}';
    params['width'] = '${provider?.widthCMStr ?? ''}';
    params['height'] = '${provider?.heightCMStr ?? ''}';
    params['vertical_ground_height'] = '${provider?.dy ?? ''}';
    params['goods_id'] = '${provider?.goodsId ?? ''}';
    params['install_room'] = '${provider?.curRoomAttrBean?.id ?? ''}';
    data.clear();
    data['${provider?.windowPatternId ?? ''}'] = {
      'name': '${provider?.windowPatternStr ?? ''}',
      'selected': {
        '安装选项': ['${provider?.curInstallMode ?? ''}'],
        '打开方式': provider?.openModeParams
      }
    };

    params['data'] = jsonEncode(data);
  }

  bool validateData(GoodsProvider provider) {
    String w = provider?.widthCMStr ?? '0.00';
    String h = provider?.heightCMStr ?? '0.00';
    if (w?.trim()?.isEmpty == true) {
      CommonKit?.showInfo('请填写宽度');
      return false;
    }
    if (double.parse(w) == 0) {
      CommonKit?.showInfo('宽度不能为0哦');
      return false;
    }
    if (h?.trim()?.isEmpty == true) {
      CommonKit?.showInfo('请填写高度');
      return false;
    }
    if (double.parse(h) == 0) {
      CommonKit?.showInfo('高度不能为0哦');
      return false;
    }
    if (double.parse(h) > 350) {
      CommonKit.showInfo('暂不支持3.5m以上定制');
      h = '350';
      return false;
    }
    return true;
  }

  bool beforePurchase(GoodsProvider goodsProvider, BuildContext context) {
    setParams(goodsProvider);

    if (TargetClient.instance.hasSelectedClient == false) {
      CommonKit.showInfo('请选择客户');
      return false;
    }
    if (goodsProvider?.hasSetSize != true) {
      CommonKit.showInfo('请先填写尺寸');
      return false;
    }
    return true;
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

  void setCartParams(GoodsProvider goodsProvider) {
    cartParams['is_shade'] = goodsProvider?.isShade == true ? 1 : 0;
    cartParams['estimated_price'] = goodsProvider?.totalPrice;
    cartParams['measure_id'] = goodsProvider?.measureId;
    cartParams['wc_attr'] = '${goodsProvider.getAttrArgs()}';
  }

  static Map<String, dynamic> cartParams = {
    // 'fav_type':'goods',
    'client_uid': '',
  };

  addCart(
    BuildContext context,
    GoodsProvider provider,
  ) {
    cartParams.addAll({'wc_attr': jsonEncode(provider.getAttrArgs())});
    cartParams
        .addAll({'cart_detail': jsonEncode(getCartDetail(provider?.goods))});

    GoodsProvider goodsProvider = TargetOrderGoods.instance.goodsProvider;
    goodsProvider?.canAddToCart = false;
    goodsProvider.saveMeasure(context, callback: () {
      cartParams['measure_id'] = goodsProvider?.measureId;

      OTPService.addCart(params: cartParams)
          .then((ZYResponse response) {})
          .catchError((err) => err)
          .whenComplete(() {
        goodsProvider?.canAddToCart = true;
      });
    });
  }

  Future createOrder(BuildContext context) async {
    GoodsProvider goodsProvider = TargetOrderGoods.instance.goodsProvider;
    await goodsProvider?.saveMeasure(context, callback: () {
      purchase(context);
    });
  }

  Future purchase(BuildContext context) async {
    GoodsProvider goodsProvider = TargetOrderGoods.instance.goodsProvider;
    if (!beforePurchase(goodsProvider, context)) return;

    Map map = goodsProvider.getAttrArgs();
    List wrapper = [];
    map.forEach((key, val) {
      Map<String, dynamic> tmp = {};
      tmp['attr_name'] = Constants.ATTR_MAP[int.parse('$key')];
      tmp['attr'] = val is List ? val ?? [] : [val];
      wrapper.add(jsonEncode(tmp));
    });
    RouteHandler.goCommitOrderPage(context,
        params: jsonEncode({
          'data': [
            {
              'tag': goodsProvider?.curRoomAttrBean?.name ?? '',
              'img': goodsProvider?.goods?.picCoverMid ?? '',
              'goods_name': goodsProvider?.goods?.goodsName,
              'price': goodsProvider?.goods?.price,
              'wc_attr': wrapper,
              'attr': jsonEncode(map),
              'dy': goodsProvider?.dy,
              'measure_id': goodsProvider?.measureId ?? '',
              'sku_id': goodsProvider?.goods?.skuId,
              'goods_id': goodsProvider?.goods?.goodsId ?? '',
              'total_price': goodsProvider?.totalPrice ?? 0.0,
              'goods_type': goodsProvider?.goodsType
            }
          ],
        }));
  }

  void selectProduct(BuildContext context, {Map<String, dynamic> params}) {
    OTPService.selectProduct(params: params).then((ZYResponse response) {
      if (response.valid) {
        GoodsProvider goodsProvider =
            Provider.of<GoodsProvider>(context, listen: false);
        goodsProvider?.clearGoodsInfo();
        Navigator.of(context)..pop()..pop();
        // TargetRoute.instance.setRoute(
        //     '${Routes.orderDetail}?id=${TargetOrderGoods.instance.orderId}');
        // Navigator.of(context)
        //     .popUntil(ModalRoute.withName(TargetRoute.instance.route));
      } else {
        CommonKit.showInfo(response?.message ?? '');
      }
    }).catchError((err) => err);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    // TextTheme textTheme = themeData.textTheme;
    TargetOrderGoods targetOrderGoods = TargetOrderGoods.instance;
    return Consumer<GoodsProvider>(
      builder: (BuildContext context, GoodsProvider goodsProvider, _) {
        cartParams['client_uid'] = TargetClient.instance.clientId;
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
                    ZYRaisedButton('确认选品', () {
                      if (targetOrderGoods?.hasConfirmMeasureData == false &&
                          goodsProvider?.isWindowRoller == false) {
                        return CommonKit.showInfo('请先确认测装数据');
                      }
                      Map<String, dynamic> data = {
                        'num': 1,
                        'goods_id': goodsProvider?.goodsId,
                        '安装选项': ['${goodsProvider?.curInstallMode ?? ''}'],
                        '打开方式': goodsProvider?.openModeParams
                      };

                      // data['${goodsProvider?.windowPatternId ?? ''}'] = {
                      //   'name': '${goodsProvider?.windowPatternStr ?? ''}',
                      //   'selected': {
                      //     '安装选项': ['${goodsProvider?.curInstallMode ?? ''}'],
                      //     '打开方式': goodsProvider?.openModeParams
                      //   }
                      // };
                      Map<String, dynamic> params = {
                        'vertical_ground_height': goodsProvider?.dyCMStr,
                        'data': jsonEncode(data),
                        'wc_attr': jsonEncode(goodsProvider.getAttrArgs()),
                        'order_goods_id': targetOrderGoods?.orderGoodsId,
                      };
                      TargetOrderGoods.instance.clear();
                      selectProduct(context, params: params);
                    })
                  ],
                ))
            : Container(
                color: themeData.primaryColor,
                padding: EdgeInsets.symmetric(
                    horizontal: UIKit.width(20), vertical: UIKit.height(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text.rich(TextSpan(text: '预计:\n', children: [
                        TextSpan(
                            text: '¥${goodsProvider?.totalPrice ?? 0.00}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                      ])),
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: goodsProvider?.canAddToCart == true
                                      ? () {
                                          if (!beforePurchase(
                                              goodsProvider, context)) return;
                                          setCartParams(goodsProvider);
                                          addCart(context, goodsProvider);
                                        }
                                      : null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: UIKit.width(20),
                                        vertical: UIKit.height(11)),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                goodsProvider?.canAddToCart ==
                                                        true
                                                    ? themeData.accentColor
                                                    : themeData.disabledColor)),
                                    child: Text(
                                      '加入购物车',
                                      textAlign: TextAlign.center,
                                      style: goodsProvider?.canAddToCart == true
                                          ? TextStyle()
                                          : TextStyle(
                                              color: themeData.disabledColor),
                                    ),
                                  ),
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (!beforePurchase(
                                          goodsProvider, context)) return;
                                      createOrder(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: UIKit.height(11)),
                                      decoration: BoxDecoration(
                                          color: themeData.accentColor,
                                          border: Border.all(
                                              color: themeData.accentColor)),
                                      child: Text(
                                        '立即购买',
                                        style: themeData.accentTextTheme.button,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  flex: 1),
                            ],
                          ),
                        ))
                  ],
                ),
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
                              style: textTheme.body1),
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
                              style: textTheme.body1),
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
