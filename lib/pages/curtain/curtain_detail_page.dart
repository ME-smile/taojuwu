import 'dart:convert';

import 'package:common_utils/common_utils.dart';
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
import 'package:taojuwu/providers/client_provider.dart';

import 'package:taojuwu/providers/goods_provider.dart';
import 'package:taojuwu/providers/order_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/loading.dart';

import 'package:taojuwu/widgets/user_choose_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

import 'package:taojuwu/widgets/zy_raised_button.dart';

import 'widgets/attr_options_bar.dart';
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
  Map<String, dynamic> cartParams;
  Map<String, dynamic> collectParams;

  TextEditingController widthInputController;
  TextEditingController heightInputController;
  TextEditingController dyInputController;

  int id;
  String partType;
  ValueNotifier<bool> hasCollected = ValueNotifier<bool>(false);

  @override
  void dispose() {
    super.dispose();
    hasCollected?.dispose();
    widthInputController?.dispose();
    heightInputController?.dispose();
    dyInputController?.dispose();
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    id = widget.id;

    ClientProvider clientProvider =
        Provider.of<ClientProvider>(context, listen: false);
    GoodsProvider goodsProvider =
        Provider.of<GoodsProvider>(context, listen: false);
    partType = goodsProvider?.partType;
    widthInputController = TextEditingController();
    heightInputController = TextEditingController();
    dyInputController = TextEditingController();
    cartParams = {
      'client_uid': clientProvider?.clientId,
    };
    collectParams = {
      // 'fav_type':'goods',
      'fav_id': widget.id,
      'client_uid': clientProvider?.clientId
    };
    OTPService.fetchCurtainDetailData(context, params: {
      'goods_id': widget.id,
      'client_uid': clientProvider?.clientId,
      'parts_type': partType
    }).then((data) {
      ProductBeanRes productBeanRes = data[0];
      ProductBeanDataWrapper wrapper = productBeanRes.data;
      ProductBean bean = wrapper.goodsDetail;

      if (mounted) {
        if (goodsProvider?.hasInit == false) {
          goodsProvider?.initDataWithFilter(
            bean: bean,
            windowGauzeAttr: data[1],
            craftAttr: data[2],
            partAttr: data[3],
            windowShadeAttr: data[4],
            canopyAttr: data[5],
            accessoryAttr: data[6],
            roomAttr: data[7],
          );
        }
        setCartParams(goodsProvider);
        hasCollected?.value = goodsProvider?.hasLike;

        setState(() {
          isLoading = false;
        });
      }
    }).catchError((err) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return err;
    });
  }

  void setCartParams(GoodsProvider goodsProvider) {
    cartParams['is_shade'] = goodsProvider?.isShade == true ? 1 : 0;
    cartParams['estimated_price'] = goodsProvider?.totalPrice;
    cartParams['measure_id'] = goodsProvider?.measureId;
    cartParams['wc_attr'] = '${goodsProvider.getAttrArgs()}';
  }

  collect(
    BuildContext context,
  ) {
    // final Completer<bool> completer = new Completer<bool>();
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

  void setSize() async {
    await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<GoodsProvider>(
            builder: (BuildContext context, GoodsProvider goodsProvider, _) {
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
                      // closeSizeDialog();
                      // print(depositInput?.text);
                      String w = widthInputController?.text?.trim();
                      String h = heightInputController?.text?.trim();
                      if (w?.isNotEmpty != true ||
                          h?.isNotEmpty != true ||
                          double.parse(w ?? '0.00') == 0 ||
                          double.parse(h ?? '0.00') == 0) {
                        return CommonKit.showInfo('请输入正确的尺寸');
                      }
                      goodsProvider?.width = widthInputController?.text;
                      goodsProvider?.height = heightInputController?.text;
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        });
  }

  void setDy({OrderGoodsMeasure measureData}) async {
    await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<GoodsProvider>(
            builder: (BuildContext context, GoodsProvider goodsProvider, _) {
              return CupertinoAlertDialog(
                title: Text('离地距离（cm）'),
                content: Column(
                  children: <Widget>[
                    CupertinoTextField(
                      controller: dyInputController,
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
                      // closeSizeDialog();
                      // print(depositInput?.text);
                      goodsProvider?.dy = dyInputController?.text;
                      measureData?.verticalGroundHeight =
                          dyInputController?.text;

                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        });
  }

  Widget buildWindowRollerOption() {
    OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    return orderProvider?.hasOrderGoodsId == true
        ? Consumer<GoodsProvider>(
            builder: (BuildContext context, GoodsProvider goodsProvider, _) {
              goodsProvider?.initMeasureDataForWindowRoller();
              return Column(
                children: <Widget>[
                  AttrOptionsBar(
                    title: '空间',
                    trailingText: goodsProvider
                            ?.forWindowRollerMeasureData?.installRoom ??
                        '',
                    callback: null,
                    showNext: false,
                  ),
                  AttrOptionsBar(
                    title: '窗型',
                    trailingText:
                        goodsProvider?.forWindowRollerMeasureData?.windowType ??
                            '',
                    callback: null,
                    showNext: false,
                  ),
                  AttrOptionsBar(
                    title: '尺寸',
                    // isRollUpWindow: goodsProvider?.isWindowGauze,
                    trailingText:
                        '${goodsProvider?.forWindowRollerWidthMstr ?? ''}米,${goodsProvider?.forWindowRollerHeightMstr ?? ''}米',
                    callback: null,
                    showNext: false,
                  ),
                  AttrOptionsBar(
                    title: '离地距离',
                    // isRollUpWindow: goodsProvider?.isWindowGauze,
                    trailingText: '${goodsProvider?.dyCMStr ?? ''}cm',
                    callback: () {
                      setDy(
                          measureData:
                              goodsProvider?.forWindowRollerMeasureData);
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

    return isLoading
        ? LoadingCircle()
        : Consumer2<GoodsProvider, ClientProvider>(
            builder: (BuildContext context, GoodsProvider goodsProvider,
                ClientProvider clientProvider, _) {
              ProductBean bean = goodsProvider?.goods;
              return WillPopScope(
                  child: Scaffold(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text.rich(TextSpan(
                                              text:
                                                  '${bean?.goodsName}      ' ??
                                                      '',
                                              children: [
                                                TextSpan(
                                                    text: bean?.goodsName ?? '',
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
                                                      return IconButton(
                                                          icon: Icon(
                                                            ZYIcon.like,
                                                            color: isLiked
                                                                ? Colors.red
                                                                : const Color(
                                                                    0xFFCCCCCC),
                                                          ),
                                                          onPressed: () {
                                                            collect(context);
                                                          });
                                                    })),
                                            WidgetSpan(
                                                child: IconButton(
                                                    icon: Icon(ZYIcon.cart),
                                                    onPressed: () {
                                                      if (clientProvider
                                                              ?.clientId ==
                                                          null) {
                                                        return CommonKit
                                                            .showInfo('请选择客户');
                                                      }
                                                      RouteHandler.goCartPage(
                                                        context,
                                                        clientId: clientProvider
                                                            ?.clientId,
                                                      );
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
                    OrderProvider orderProvider =
                        Provider.of(context, listen: false);
                    orderProvider.hasConfirmMeasureData = false;
                    if (orderProvider?.isMeasureOrder == false &&
                        goodsProvider?.isWindowRoller == false) {
                      goodsProvider?.clearGoodsInfo();
                    }
                    goodsProvider?.partType = '';
                    goodsProvider?.hasInitOpenMode = false;
                    return Future.value(false);
                  });
            },
          );
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
    'goods_id': ''
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

  Future<bool> beforePurchase(GoodsProvider goodsProvider,
      ClientProvider clientProvider, BuildContext context) async {
    OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    setParams(goodsProvider);
    if (clientProvider?.clientId == null) {
      CommonKit.showInfo('请选择客户');
      return false;
    }

    if (validateData(goodsProvider)) {
      if (orderProvider?.isMeasureOrder == false &&
          goodsProvider?.isWindowRoller == true &&
          goodsProvider?.hasSetSize != true) {
        await OTPService.saveMeasure(context, params: params)
            .then((ZYResponse response) {
          if (response?.valid == true) {
            goodsProvider?.measureId = response?.data;
          } else {
            CommonKit.showInfo(response?.message ?? '');
          }
        }).catchError((err) => err);
      }
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

  void addCart(
    BuildContext context,
    GoodsProvider provider,
  ) {
    cartParams.addAll({'wc_attr': jsonEncode(provider.getAttrArgs())});
    cartParams
        .addAll({'cart_detail': jsonEncode(getCartDetail(provider?.goods))});
    OTPService.addCart(params: cartParams).then((ZYResponse response) {
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
                      if (orderProvider?.hasConfirmMeasureData == false &&
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
                        'order_goods_id': orderProvider?.orderGoodsId,
                      };
                      LogUtil.e(params);
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
                          onTap: () async {
                            if (!await beforePurchase(
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
                          onTap: () async {
                            if (!await beforePurchase(
                                goodsProvider, clientProvider, context)) return;
                            Map map = goodsProvider.getAttrArgs();
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
                                      'dy': goodsProvider?.dy,
                                      'measure_id':
                                          goodsProvider?.measureId ?? '',
                                      'sku_id': goodsProvider?.goods?.skuId,
                                      'goods_id':
                                          goodsProvider?.goods?.goodsId ?? '',
                                      'total_price':
                                          goodsProvider?.totalPrice ?? 0.0,
                                      'goods_type': goodsProvider?.goodsType
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
