import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/shop/product_bean.dart';

import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/pages/curtain/widgets/onsale_tag.dart';
import 'package:taojuwu/providers/end_product_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/step_counter.dart';
import 'package:taojuwu/widgets/user_choose_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_action_chip.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class EndProductDetailPage extends StatefulWidget {
  final int id;
  EndProductDetailPage({Key key, this.id}) : super(key: key);

  @override
  _EndProductDetailPageState createState() => _EndProductDetailPageState();
}

class _EndProductDetailPageState extends State<EndProductDetailPage> {
  int get id => widget.id;

  ValueNotifier<bool> hasCollected;

  @override
  void initState() {
    hasCollected = ValueNotifier<bool>(false);
    super.initState();
  }

  Map<String, dynamic> collectParams = {};
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

  bool beforePurchase(EndProductProvider provider, BuildContext context) {
    if (TargetClient.instance.hasSelectedClient == false) {
      CommonKit.showInfo('请选择客户');
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    hasCollected?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return ZYFutureBuilder(
        futureFunc: OTPService.productDetail,
        params: {
          'goods_id': id,
        },
        builder: (BuildContext context, ProductBeanRes response) {
          ProductBeanDataWrapper wrapper = response?.data;
          ProductBean bean = wrapper?.goodsDetail;
          TargetClient targetClient = TargetClient.instance;
          return ChangeNotifierProvider<EndProductProvider>(
            create: (BuildContext context) => EndProductProvider(bean),
            child: Consumer<EndProductProvider>(builder:
                (BuildContext context, EndProductProvider provider, _) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(true);
                },
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: UIKit.width(50),
                                    vertical: UIKit.height(20)),
                                margin: EdgeInsets.only(top: 80),
                                child: Swiper(
                                  itemCount: bean?.goodsImgList?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    ProductBeanGoodsImageBean item =
                                        bean?.goodsImgList[index];
                                    return ZYNetImage(imgPath: item?.picCover);
                                  },
                                  pagination: new SwiperPagination(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      builder: DotSwiperPaginationBuilder(
                                          activeColor: Colors.black,
                                          color: Colors.black.withOpacity(.3))),
                                )),
                          ),
                        )
                      ];
                    },
                    body: CustomScrollView(slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Container(
                          color: themeData.primaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: UIKit.width(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              VSpacing(20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text.rich(TextSpan(
                                      text: '${bean?.goodsName} ' ?? '',
                                      style: TextStyle(
                                          fontSize: UIKit.sp(28),
                                          fontWeight: FontWeight.w400),
                                      children: [
                                        TextSpan(
                                            text: bean?.goodsName ?? '',
                                            style: textTheme.caption)
                                      ])),
                                  Text.rich(TextSpan(text: '', children: [
                                    WidgetSpan(
                                        child: ValueListenableBuilder(
                                            valueListenable: hasCollected,
                                            builder: (BuildContext context,
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
                                        child:
                                            SizedBox(width: UIKit.width(30))),
                                    WidgetSpan(
                                        child: InkWell(
                                            child: Icon(ZYIcon.cart, size: 18),
                                            onTap: () {
                                              if (targetClient
                                                      .hasSelectedClient ==
                                                  false) {
                                                return CommonKit.showInfo(
                                                    '请选择客户');
                                              }
                                              RouteHandler.goCartPage(
                                                context,
                                                clientId: targetClient.clientId,
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
                                        text: provider?.unit,
                                        style: textTheme.caption),
                                    TextSpan(text: ' '),
                                    TextSpan(
                                        text: bean?.isPromotionGoods == true
                                            ? '¥${bean?.marketPrice}'
                                            : '',
                                        style: textTheme.caption.copyWith(
                                            decoration:
                                                TextDecoration.lineThrough)),
                                    WidgetSpan(
                                        child: Offstage(
                                      offstage: bean?.isPromotionGoods == false,
                                      child: OnSaleTag(),
                                    ))
                                  ])),
                              VSpacing(10),
                              Divider(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: UIKit.height(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                            text: '已选',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                            children: [
                                              WidgetSpan(
                                                  child: SizedBox(
                                                width: 10,
                                              )),
                                              TextSpan(
                                                  text:
                                                      provider?.checkedAttrText,
                                                  style: textTheme.caption
                                                      .copyWith(fontSize: 14))
                                            ]),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        selectAttrOption(provider, () {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Icon(
                                        ZYIcon.three_dot,
                                        color: Colors.black,
                                        size: 28,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: VSpacing(20),
                      ),
                      SliverToBoxAdapter(
                        child: bean?.description?.isNotEmpty == true
                            ? Html(
                                data: bean?.description,
                                backgroundColor: themeData.primaryColor,
                              )
                            : Container(),
                      )
                    ]),
                  ),
                  bottomNavigationBar: Container(
                    color: themeData.primaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: UIKit.width(20),
                        vertical: UIKit.height(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text.rich(TextSpan(text: '预计:\n', children: [
                            TextSpan(
                                text: '¥${provider?.totalPrice ?? 0.00}',
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
                                      // onTap: provider?.canAddToCart == true
                                      //     ? () {
                                      //         if (!beforePurchase(
                                      //             goodsProvider, context))
                                      //           return;
                                      //         setCartParams(goodsProvider);
                                      //         addCart(context, goodsProvider);
                                      //       }
                                      //     : null,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: UIKit.width(20),
                                            vertical: UIKit.height(11)),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: provider?.canAddToCart ==
                                                        true
                                                    ? themeData.accentColor
                                                    : themeData.disabledColor)),
                                        child: Text(
                                          '加入购物车',
                                          textAlign: TextAlign.center,
                                          style: provider?.canAddToCart == true
                                              ? TextStyle()
                                              : TextStyle(
                                                  color:
                                                      themeData.disabledColor),
                                        ),
                                      ),
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          // if (!beforePurchase(
                                          //     goodsProvider, context)) return;
                                          // createOrder(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: UIKit.height(11)),
                                          decoration: BoxDecoration(
                                              color: themeData.accentColor,
                                              border: Border.all(
                                                  color:
                                                      themeData.accentColor)),
                                          child: Text(
                                            '立即购买',
                                            style: themeData
                                                .accentTextTheme.button,
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
                  ),
                ),
              );
            }),
          );
        });
  }

  void selectAttrOption(EndProductProvider provider, Function callback) async {
    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;
          return ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            child: Container(
              width: width,
              height: height * .7,
              child: Scaffold(
                body: Stack(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(16),
                        child: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 14),
                                    child: ZYNetImage(
                                      imgPath: provider?.curSkubean?.coverUrl,
                                      width: UIKit.width(180),
                                      height: UIKit.width(180),
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        '¥${provider?.curSkubean?.price ?? ''}',
                                        style: TextStyle(
                                            color: Color(0xFFFF6161),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '已选:${provider?.checkedAttrText ?? ''}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF6D6D6D)),
                                      )
                                    ],
                                  ))
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int i) {
                                  ProductBeanSpecListBean item =
                                      provider?.specList[i];

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: UIKit.height(16)),
                                        child: Text(item?.specName),
                                      ),
                                      i == 0
                                          ? StepCounter(
                                              count: provider?.count,
                                              model: provider?.goods,
                                            )
                                          : Wrap(
                                              runSpacing: UIKit.sp(16),
                                              spacing: UIKit.sp(32),
                                              children: List.generate(
                                                  item?.value?.length, (index) {
                                                ProductBeanSpecValueBean e =
                                                    item?.value[index];
                                                return Container(
                                                  height: 26,
                                                  child: AspectRatio(
                                                    aspectRatio: 3,
                                                    child: ZYActionChip(
                                                      callback: () {
                                                        item?.value?.forEach(
                                                            (element) {
                                                          element?.selected =
                                                              false;
                                                        });
                                                        setState(() {
                                                          e.selected =
                                                              !e.selected;
                                                        });
                                                        provider?.skuList
                                                            ?.forEach(
                                                                (element) {
                                                          if (element
                                                                  ?.attrValueItemsFormat ==
                                                              provider
                                                                  ?.checkedOptionsValueStr) {
                                                            provider?.skuId =
                                                                element?.skuId;
                                                          }
                                                        });
                                                      },
                                                      bean:
                                                          ActionBean.fromJson({
                                                        'text': e.specValueName,
                                                        'is_checked': e.selected
                                                      }),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            )
                                    ],
                                  );
                                },
                                itemCount: provider?.specList?.length ?? 0,
                              ),
                            ],
                          );
                        })),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: InkWell(
                          child: Icon(ZYIcon.close),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ))
                  ],
                ),
                bottomNavigationBar: ZYSubmitButton('确定', () {
                  callback();
                }),
              ),
            ),
          );
        });
  }
}
