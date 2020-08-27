import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/shop/cart_list_model.dart';
import 'package:taojuwu/models/shop/product_bean.dart';

import 'package:taojuwu/models/shop/sku_attr/accessory_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/canopy_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/craft_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/part_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_gauze_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_shade_attr.dart';
import 'package:taojuwu/providers/end_product_provider.dart';
import 'package:taojuwu/providers/goods_provider.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/step_counter.dart';
import 'package:taojuwu/widgets/zy_action_chip.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

import 'option_view.dart';
import 'sku_attr_picker.dart';

class ZYDialog {
  static void checkAttr(BuildContext context, String title, dynamic curOpotion,
      {GoodsProvider goodsProvider}) async {
    await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return CheckAttrModal(
            title,
            goodsProvider,
            curOpotion,
          );
        });
  }

  static Future<CartModel> checkEndProductAttr(
      BuildContext ctx, CartModel cartModel,
      {Function callback}) {
    return showCupertinoModalPopup<CartModel>(
        context: ctx,
        builder: (BuildContext context) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;
          return ZYFutureBuilder(
              futureFunc: OTPService.productDetail,
              params: {
                'goods_id': cartModel?.goodsId,
                'sku_id': cartModel?.skuId,
              },
              loadingWidget: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)),
                child: Container(
                  child: LoadingCircle(),
                  height: height * 0.7,
                ),
              ),
              builder: (BuildContext context, ProductBeanRes response) {
                ProductBeanDataWrapper wrapper = response?.data;
                ProductBean bean = wrapper?.goodsDetail;
                return ChangeNotifierProvider(
                    create: (BuildContext context) => EndProductProvider(bean),
                    child: Consumer(builder: (BuildContext context,
                        EndProductProvider provider, __) {
                      return ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                        child: Container(
                          width: width,
                          height: height * .7,
                          child: Scaffold(
                            body: Stack(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(16),
                                    child: StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 14),
                                                child: ZYNetImage(
                                                  imgPath: provider
                                                      ?.curSkubean?.coverUrl,
                                                  width: UIKit.width(180),
                                                  height: UIKit.width(180),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    '¥${provider?.curSkubean?.price ?? ''}',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFFF6161),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '已选:${provider?.checkedAttrText ?? ''}',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFF6D6D6D)),
                                                  )
                                                ],
                                              ))
                                            ],
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          UIKit.height(16)),
                                                  child: Text('数量'),
                                                ),
                                                StepCounter(
                                                  count: cartModel?.count,
                                                  model: cartModel,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.all(0),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                ProductBeanSpecListBean item =
                                                    provider?.specList[i];

                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  UIKit.height(
                                                                      16)),
                                                      child:
                                                          Text(item?.specName),
                                                    ),
                                                    Wrap(
                                                      runSpacing: UIKit.sp(16),
                                                      spacing: UIKit.sp(24),
                                                      children: List.generate(
                                                          item?.value?.length,
                                                          (index) {
                                                        ProductBeanSpecValueBean
                                                            e =
                                                            item?.value[index];
                                                        return Container(
                                                          height: 26,
                                                          child: AspectRatio(
                                                            aspectRatio: 3,
                                                            child: ZYActionChip(
                                                              callback: () {
                                                                item?.value
                                                                    ?.forEach(
                                                                        (element) {
                                                                  element?.selected =
                                                                      false;
                                                                });
                                                                setState(() {
                                                                  e.selected = !e
                                                                      .selected;
                                                                });
                                                                provider
                                                                    ?.skuList
                                                                    ?.forEach(
                                                                        (element) {
                                                                  if (element
                                                                          ?.attrValueItemsFormat ==
                                                                      provider
                                                                          ?.checkedOptionsValueStr) {
                                                                    provider?.skuId =
                                                                        element
                                                                            ?.skuId;
                                                                  }
                                                                });
                                                              },
                                                              bean: ActionBean
                                                                  .fromJson({
                                                                'text': e
                                                                    .specValueName,
                                                                'is_checked':
                                                                    e.selected
                                                              }),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    )
                                                  ],
                                                );
                                              },
                                              itemCount:
                                                  provider?.specList?.length ??
                                                      0,
                                            ),
                                          )
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
                            bottomNavigationBar: Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ZYSubmitButton('确定', () {
                                provider?.modifyEndProductAttr(context,
                                    cartModel: cartModel, callback: callback);
                              }),
                            ),
                          ),
                        ),
                      );
                    }));
              });
        });
  }
}

class CheckAttrModal extends StatefulWidget {
  final String title;
  final curOption;
  final GoodsProvider goodsProvider;
  CheckAttrModal(
    this.title,
    this.goodsProvider,
    this.curOption, {
    Key key,
  }) : super(key: key);

  @override
  _CheckAttrModalState createState() => _CheckAttrModalState();
}

class _CheckAttrModalState extends State<CheckAttrModal> {
  Map<String, dynamic> dict;
  var tmp;
  String title;
  @override
  void initState() {
    GoodsProvider provider =
        widget.goodsProvider ?? TargetOrderGoods.instance.goodsProvider;
    tmp = widget.curOption;
    title = widget.title;
    dict = {
      '窗纱选择': {
        'list': provider?.windowGauzeAttr?.data ?? [],
        'tap': (WindowGauzeAttrBean bean) {
          setState(() {
            tmp = bean;
          });
        },
        'confirm': () {
          provider?.curWindowGauzeAttrBean = tmp;
        }
      },
      '工艺方式': {
        'list': provider?.craftAttr?.data ?? [],
        'tap': (CraftAttrBean bean) {
          setState(() {
            tmp = bean;
          });
        },
        'confirm': () {
          provider?.curCraftAttrBean = tmp;
        }
      },
      '型材更换': {
        'list': provider?.partAttr?.data ?? [],
        'tap': (PartAttrBean bean) {
          setState(() {
            tmp = bean;
          });
        },
        'confirm': () {
          provider?.curPartAttrBean = tmp;
        }
      },
      '里布选择': {
        'list': provider?.windowShadeAttr?.data ?? [],
        'tap': (WindowShadeAttrBean bean) {
          setState(() {
            tmp = bean;
          });
        },
        'confirm': () {
          provider?.curWindowShadeAttrBean = tmp;
        }
      },
      '幔头选择': {
        'list': provider?.canopyAttr?.data ?? [],
        'tap': (CanopyAttrBean bean) {
          setState(() {
            tmp = bean;
          });
        },
        'confirm': () {
          provider?.curCanopyAttrBean = tmp;
        }
      },
      '配饰选择': {
        'list': provider?.accessoryAttr?.data ?? [],
        'tap': (AccessoryAttrBean bean) {
          provider?.checkAccessoryAttrBean(bean);
          setState(() {});
        },
        'confirm': () {}
      },
    };

    super.initState();
  }

  bool get isLessOption => dict[title]['list'].length < 4 ?? false;
  @override
  Widget build(BuildContext context) {
    return SkuAttrPicker(
        title: title,
        callback: () {
          dict[title]['confirm']();
          Navigator.of(context).pop();
        },
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                  horizontal: isLessOption ? UIKit.width(40) : 0),
              alignment: isLessOption ? Alignment.centerLeft : Alignment.center,
              child: Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.horizontal,
                spacing: 8,
                runSpacing: 20,
                children: List.generate(dict[title]['list'].length, (int i) {
                  var item = dict[title]['list'][i];
                  return OptionView(
                    img: item.picture,
                    text: item.name,
                    price: '${item.price ?? ''}',
                    showBorder:
                        title != '配饰选择' ? tmp?.id == item?.id : item.isChecked,
                    callback: () {
                      dict[title]['tap'](item);
                    },
                  );
                }),
              ),
            )));
  }
}
