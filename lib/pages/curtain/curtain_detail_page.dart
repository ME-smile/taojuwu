import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/shop/product_bean.dart';
import 'package:taojuwu/models/shop/sku_attr/accessory_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/canopy_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/craft_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/part_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/room_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_gauze_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_pattern_attr.dart';

import 'package:taojuwu/models/shop/sku_attr/window_shade_attr.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/providers/client_provider.dart';

import 'package:taojuwu/providers/goods_provider.dart';
import 'package:taojuwu/providers/order_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';

import 'package:taojuwu/widgets/user_choose_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

import 'package:taojuwu/widgets/zy_future_builder.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

import 'widgets/attr_options_bar.dart';
import 'widgets/zy_dialog.dart';

class CurtainDetailPage extends StatefulWidget {
  CurtainDetailPage(
    this.id, {
    Key key,
  }) : super(key: key);

  final int id;

  @override
  _CurtainDetailPageState createState() => _CurtainDetailPageState();
}

class _CurtainDetailPageState extends State<CurtainDetailPage> {
  Map<String, dynamic> cartParams;
  Map<String, dynamic> collectParams;
  GoodsProvider goodsProvider;
  bool hasCollect = false;
  int id;

  @override
  void initState() {
    super.initState();
    id = widget.id;

    ClientProvider clientProvider =
        Provider.of<ClientProvider>(context, listen: false);
    cartParams = {
      'client_uid': clientProvider?.clientId,
    };

    collectParams = {
      // 'fav_type':'goods',
      'fav_id': widget.id,
      'client_uid': clientProvider?.clientId
    };
  }

  void setCartParams(GoodsProvider goodsProvider) {
    cartParams['is_shade'] = goodsProvider?.isShade == true ? 1 : 0;
    cartParams['estimated_price'] = goodsProvider?.totalPrice;
    cartParams['measure_id'] = goodsProvider?.measureId;
    cartParams['wc_attr'] = '${getAttrArgs(goodsProvider)}';
  }

  void collect(
    BuildContext context,
  ) {
    if (!hasCollect) {
      OTPService.collect(context, params: collectParams)
          .then((ZYResponse response) {})
          .catchError((err) => err);
    } else {
      OTPService.cancelCollect(context, params: collectParams).then((data) {
        print(data);
      }).catchError((err) => err);
    }
  }

  Map<String, dynamic> getAttrArgs(GoodsProvider provider) {
    return {
      //空间
      '1': {
        'name': provider?.curRoomAttrBean?.name ?? '',
        'id': provider?.curRoomAttrBean?.id ?? ''
      },
      //窗型
      '2': {
        'name':
            WindowPatternAttr.patternsText[provider?.curWindowPattern ?? 0] +
                '/' +
                WindowPatternAttr.stylesText[provider?.curWindowStyle ?? 0] +
                '/' +
                WindowPatternAttr.typesText[provider?.curWindowType ?? 0],
        'id': 24
      },
      //窗纱
      '3': {
        'name': provider?.curWindowGauzeAttrBean?.name ?? '',
        'id': provider?.curWindowGauzeAttrBean?.id ?? ''
      },
      //窗纱
      '4': {
        'name': provider?.curCraftAttrBean?.name ?? '',
        'id': provider?.curCraftAttrBean?.id ?? ''
      },
      //配件
      '5': {
        'name': provider?.curPartAttrBean?.name ?? '',
        'id': provider?.curPartAttrBean?.id ?? ''
      },
      //帘身款式
      // '6': {},
      // // 帘身面料
      // '7': {},
      //幔头
      // '8': {'name': '', 'id': ''},
      '9': [
        // {'name': '宽', 'value': provider?.width},
        // {'name': '高', 'value': provider?.height},
        {'name': '宽', 'value': '${provider?.widthCM ?? ''}'},
        {'name': '高', 'value': '${provider?.heightCM ?? ''}'}
      ],
      //遮光里布
      '12': {
        'name': provider?.curWindowShadeAttrBean?.name ?? '',
        'id': provider?.curWindowShadeAttrBean?.id ?? ''
      },
      '13': (provider?.curAccessoryAttrBeans?.isEmpty == true
              ? [provider?.accessoryAttr?.data?.first]
              : provider?.curAccessoryAttrBeans)
          ?.map((item) => {'name': item.name, 'id': item.id})
          ?.toList()
    };
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

  void addCart(BuildContext ctx, GoodsProvider provider) {
    cartParams.addAll({'wc_attr': jsonEncode(getAttrArgs(provider))});
    cartParams
        .addAll({'cart_detail': jsonEncode(getCartDetail(provider?.goods))});
    OTPService.addCart(context, params: cartParams)
        .then((ZYResponse response) {})
        .catchError((err) => err);
  }

  bool beforePurchase(
      GoodsProvider goodsProvider, ClientProvider clientProvider) {
    if (clientProvider?.clientId == null) {
      CommonKit.showInfo('请选择客户');
      return false;
    }
    if (goodsProvider?.hasSetSize != true) {
      CommonKit.showInfo('请先填写尺寸');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return ZYFutureBuilder(
        futureFunc: OTPService.fetchCurtainDetailData,
        params: {'goods_id': widget.id},
        builder: (BuildContext context, data) {
          ProductBeanRes productBeanRes = data[0];
          ProductBeanDataWrapper wrapper = productBeanRes.data;
          ProductBean bean = wrapper.goodsDetail;
          WindowGauzeAttr windowGauzeAttr = data[1];
          CraftAttr craftAttr = data[2];
          PartAttr partAttr = data[3];
          WindowShadeAttr windowShadeAttr = data[4];
          CanopyAttr canopyAttr = data[5];
          AccessoryAttr accessoryAttr = data[6];
          RoomAttr roomAttr = data[7];
          setCartParams(goodsProvider);
          return Consumer<GoodsProvider>(
            builder: (BuildContext context, GoodsProvider goodsProvider, _) {
              if (goodsProvider?.hasInit == false) {
                goodsProvider?.initData(
                    bean: bean,
                    windowGauzeAttr: windowGauzeAttr,
                    craftAttr: craftAttr,
                    partAttr: partAttr,
                    windowShadeAttr: windowShadeAttr,
                    canopyAttr: canopyAttr,
                    accessoryAttr: accessoryAttr,
                    roomAttr: roomAttr);
                hasCollect = goodsProvider?.hasLike ?? false;
              }
              return Scaffold(
                  body: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
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
                                margin: EdgeInsets.only(top: 80),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          UIKit.getNetworkImgPath(
                                              bean?.picCoverMid))),
                                ),
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
                                  vertical: UIKit.height(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text.rich(TextSpan(
                                          text: bean.goodsName + '     ' ?? '',
                                          children: [
                                            TextSpan(
                                                text: bean.goodsName ?? '',
                                                style: textTheme.caption)
                                          ])),
                                      Text.rich(TextSpan(text: '', children: [
                                        WidgetSpan(
                                            child: IconButton(
                                                icon: AnimatedSwitcher(
                                                  key: ValueKey<bool>(
                                                      hasCollect),
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  child: hasCollect
                                                      ? ZYIcon.like
                                                      : ZYIcon.unlike,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    hasCollect = !hasCollect;
                                                    collect(context);
                                                  });
                                                })),
                                        WidgetSpan(
                                            child: IconButton(
                                                icon: ZYIcon.share,
                                                onPressed: () {})),
                                        WidgetSpan(
                                            child: IconButton(
                                                icon: ZYIcon.cart,
                                                onPressed: () {
                                                  RouteHandler.goCartPage(
                                                      context);
                                                }))
                                      ]))
                                    ],
                                  ),
                                  VSpacing(20),
                                  Text.rich(TextSpan(
                                      text: '¥${bean?.price ?? 0.00}',
                                      children: [
                                        TextSpan(text: ' '),
                                        TextSpan(
                                            text: '元/米起',
                                            style: textTheme.caption)
                                      ])),
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
                                  vertical: UIKit.height(20)),
                              color: themeData.primaryColor,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: UIKit.height(10)),
                                      alignment: Alignment.centerLeft,
                                      child: MeasureDataTipBar()),
                                  Divider(),
                                  AttrOptionsBar(
                                    title: '窗 纱',
                                    trailingText: goodsProvider
                                            ?.curWindowGauzeAttrBean?.name ??
                                        '',
                                    callback: () {
                                      ZYDialog.checkAttr(
                                          context,
                                          '窗纱选择',
                                          goodsProvider
                                              ?.curWindowGauzeAttrBean);
                                    },
                                    isWindowGauze: goodsProvider?.isWindowGauze,
                                  ),
                                  AttrOptionsBar(
                                    title: '工艺方式',
                                    trailingText:
                                        goodsProvider?.curCraftAttrBean?.name ??
                                            '',
                                    callback: () {
                                      ZYDialog.checkAttr(context, '工艺方式',
                                          goodsProvider?.curCraftAttrBean);
                                    },
                                  ),
                                  AttrOptionsBar(
                                    title: '型 材',
                                    trailingText:
                                        goodsProvider?.curPartAttrBean?.name ??
                                            '',
                                    callback: () {
                                      ZYDialog.checkAttr(context, '型材更换',
                                          goodsProvider?.curPartAttrBean);
                                    },
                                  ),
                                  AttrOptionsBar(
                                    title: '遮光里布',
                                    isWindowGauze: goodsProvider?.isWindowGauze,
                                    trailingText: goodsProvider
                                            ?.curWindowShadeAttrBean?.name ??
                                        '',
                                    callback: () {
                                      ZYDialog.checkAttr(
                                          context,
                                          '遮光里布选择',
                                          goodsProvider
                                              ?.curWindowShadeAttrBean);
                                    },
                                  ),
                                  AttrOptionsBar(
                                    title: '幔 头',
                                    isWindowGauze: goodsProvider?.isWindowGauze,
                                    trailingText: goodsProvider
                                            ?.curCanopyAttrBean?.name ??
                                        '',
                                    callback: () {
                                      ZYDialog.checkAttr(context, '幔头选择',
                                          goodsProvider?.curCanopyAttrBean);
                                    },
                                  ),
                                  AttrOptionsBar(
                                    title: '配 饰',
                                    // isRollUpWindow: goodsProvider?.isWindowGauze,
                                    trailingText: goodsProvider?.accText ?? '',
                                    callback: () {
                                      ZYDialog.checkAttr(context, '配饰选择',
                                          goodsProvider?.curAccessoryAttrBeans);
                                    },
                                  ),
                                  Container(
                                    color: themeData.scaffoldBackgroundColor,
                                    height: UIKit.height(20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: bean.description.isNotEmpty
                                ? Html(data: bean?.description)
                                : Container(),
                          )
                        ],
                      )),
                  bottomNavigationBar: BottomActionButtonBar());
            },
          );
        });
  }
}

class BottomActionButtonBar extends StatelessWidget {
  const BottomActionButtonBar({Key key}) : super(key: key);
  bool beforePurchase(GoodsProvider goodsProvider,
      ClientProvider clientProvider, BuildContext context) {
    if (clientProvider?.clientId == null) {
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

  Map<String, dynamic> getAttrArgs(GoodsProvider provider) {
    return {
      //空间
      '1': {
        'name': provider?.curRoomAttrBean?.name ?? '',
        'id': provider?.curRoomAttrBean?.id ?? ''
      },
      //窗型
      '2': {
        'name':
            WindowPatternAttr.patternsText[provider?.curWindowPattern ?? 0] +
                '/' +
                WindowPatternAttr.stylesText[provider?.curWindowStyle ?? 0] +
                '/' +
                WindowPatternAttr.typesText[provider?.curWindowType ?? 0],
        'id': 24
      },
      //窗纱
      '3': {
        'name': provider?.curWindowGauzeAttrBean?.name ?? '',
        'id': provider?.curWindowGauzeAttrBean?.id ?? ''
      },
      //窗纱
      '4': {
        'name': provider?.curCraftAttrBean?.name ?? '',
        'id': provider?.curCraftAttrBean?.id ?? ''
      },
      //配件
      '5': {
        'name': provider?.curPartAttrBean?.name ?? '',
        'id': provider?.curPartAttrBean?.id ?? ''
      },
      //帘身款式
      // '6': {},
      // // 帘身面料
      // '7': {},
      //幔头
      // '8': {'name': '', 'id': ''},
      '9': [
        // {'name': '宽', 'value': provider?.width},
        // {'name': '高', 'value': provider?.height},
        {'name': '宽', 'value': '${provider?.widthCM ?? ''}'},
        {'name': '高', 'value': '${provider?.heightCM ?? ''}'}
      ],
      //遮光里布
      '12': {
        'name': provider?.curWindowShadeAttrBean?.name ?? '',
        'id': provider?.curWindowShadeAttrBean?.id ?? ''
      },
      '13': provider?.curAccessoryAttrBeans == null
          ? [
              {'name': '无', 'id': -1}
            ]
          : (provider?.curAccessoryAttrBeans?.isEmpty == true
                  ? [provider?.accessoryAttr?.data?.first]
                  : provider?.curAccessoryAttrBeans)
              ?.map((item) => {'name': item.name, 'id': item.id})
              ?.toList()
    };
  }

  void setCartParams(GoodsProvider goodsProvider) {
    cartParams['is_shade'] = goodsProvider?.isShade == true ? 1 : 0;
    cartParams['estimated_price'] = goodsProvider?.totalPrice;
    cartParams['measure_id'] = goodsProvider?.measureId;
    cartParams['wc_attr'] = '${getAttrArgs(goodsProvider)}';
  }

  static Map<String, dynamic> cartParams = {
    // 'fav_type':'goods',
    'client_uid': '',
  };

  void addCart(
    BuildContext context,
    GoodsProvider provider,
  ) {
    cartParams.addAll({'wc_attr': jsonEncode(getAttrArgs(provider))});
    cartParams
        .addAll({'cart_detail': jsonEncode(getCartDetail(provider?.goods))});
    OTPService.addCart(context, params: cartParams).then((ZYResponse response) {
      // CommonKit.toast(context, response.message ?? '');
    }).catchError((err) => err);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    // TextTheme textTheme = themeData.textTheme;
    return Consumer3<GoodsProvider, ClientProvider, OrderProvider>(
      builder: (BuildContext context, GoodsProvider goodsProvider,
          ClientProvider clientProvider, OrderProvider orderProvider, _) {
        cartParams['client_uid'] = clientProvider?.clientId;
        return orderProvider?.isMeasureOrder == true
            ? Container(
                color: themeData.primaryColor,
                padding: EdgeInsets.symmetric(
                    horizontal: UIKit.width(20), vertical: UIKit.height(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text.rich(TextSpan(text: '预计:\n', children: [
                      TextSpan(text: '¥${goodsProvider?.totalPrice ?? 0.00}'),
                    ])),
                    ZYRaisedButton('确认选品', () {
                      Map<String, dynamic> data = {
                        'num': 1,
                        '打开方式': jsonEncode([goodsProvider?.curOpenModeName]),
                        'wc_attr': jsonEncode(getAttrArgs(goodsProvider)),
                        'goods_id': goodsProvider?.goodsId
                      };

                      Map<String, dynamic> params = {
                        'vertical_ground_height': 2,
                        'data': jsonEncode(data),
                        'order_goods_id': orderProvider?.orderGoodsId
                      };
                      orderProvider?.selectProduct(context, params: params);
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
                    Text.rich(TextSpan(text: '预计:\n', children: [
                      TextSpan(text: '¥${goodsProvider?.totalPrice ?? 0.00}'),
                    ])),
                    Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            if (!beforePurchase(
                                goodsProvider, clientProvider, context)) return;
                            setCartParams(goodsProvider);
                            addCart(context, goodsProvider);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: UIKit.width(20),
                                vertical: UIKit.height(10)),
                            decoration:
                                BoxDecoration(border: Border.all(width: 1)),
                            child: Text('加入购物车'),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (!beforePurchase(
                                goodsProvider, clientProvider, context)) return;
                            Map map = getAttrArgs(goodsProvider);
                            List wrapper = [];
                            map.forEach((key, val) {
                              Map<String, dynamic> tmp = {};

                              tmp['attr_name'] =
                                  Constants.ATTR_MAP[int.parse('$key')];
                              tmp['attr'] = val is List ? val ?? [] : [val];
                              wrapper.add(jsonEncode(tmp));
                            });
                            RouteHandler.goCommitOrderPage(context,
                                params: jsonEncode({
                                  'data': [
                                    {
                                      'tag': goodsProvider
                                              ?.curRoomAttrBean?.name ??
                                          '',
                                      'img':
                                          goodsProvider?.goods?.picCoverMid ??
                                              '',
                                      'goods_name':
                                          goodsProvider?.goods?.goodsName,
                                      'price': goodsProvider?.goods?.price,
                                      'wc_attr': wrapper,
                                      'attr': jsonEncode(map),
                                      'measure_id':
                                          goodsProvider?.measureId ?? '',
                                      'sku_id': goodsProvider?.goods?.skuId,
                                      'goods_id':
                                          goodsProvider?.goods?.goodsId ?? '',
                                      'total_price':
                                          goodsProvider?.totalPrice ?? 0.0,
                                    }
                                  ],
                                }));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: UIKit.width(20),
                                vertical: UIKit.height(10)),
                            decoration: BoxDecoration(
                                color: themeData.accentColor,
                                border:
                                    Border.all(color: themeData.accentColor)),
                            child: Text(
                              '立即购买',
                              style: themeData.accentTextTheme.button,
                            ),
                          ),
                        )
                      ],
                    ),
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
    return Consumer2<GoodsProvider, OrderProvider>(builder:
        (BuildContext context, GoodsProvider goodsProvider,
            OrderProvider orderProvider, _) {
      return orderProvider?.isMeasureOrder == true
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
                              text: orderProvider?.hasConfirmMeasureData == true
                                  ? '已确认测装数据'
                                  : '请确认测装数据',
                              style: textTheme.body1),
                        ]),
                  ),
                  Spacer(),
                  Text(
                    orderProvider?.hasConfirmMeasureData == true
                        ? orderProvider?.measureDataStr ?? ''
                        : '',
                    textAlign: TextAlign.end,
                  ),
                  ZYIcon.next
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
                  ZYIcon.next
                ],
              ),
            );
    });
  }
}
