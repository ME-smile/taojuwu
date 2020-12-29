import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/cart_list_model.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';

import 'package:taojuwu/repository/shop/sku_attr/accessory_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/canopy_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/craft_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/part_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/window_gauze_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/window_shade_attr.dart';
import 'package:taojuwu/providers/end_product_provider.dart';
import 'package:taojuwu/providers/goods_provider.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/step_counter.dart';
import 'package:taojuwu/widgets/zy_action_chip.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

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

  static Future<CartModel> eidtSectionalBarLength(
      BuildContext ctx, CartModel cartModel,
      {Function callback}) {
    String temp = cartModel.length;
    return showCupertinoModalPopup<CartModel>(
        context: ctx,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext cpntext, StateSetter setState) {
              return Material(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)),
                child: Container(
                  height: MediaQuery.of(context).size.height * .64,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Scaffold(
                    bottomNavigationBar: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ZYSubmitButton('确定', () {
                        OTPService.modifyCartAttr(context, {
                          "cart_id": cartModel.cartId,
                          "num": cartModel.length,
                          "type": 2,
                        }).then((ZYResponse response) {
                          Navigator.of(context).pop();
                          cartModel.length = temp;
                          if (callback != null) callback();
                        });
                        // provider?.modifyEndProductAttr(context,
                        //     cartModel: cartModel, callback: callback);
                      }),
                    ),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 90,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ZYNetImage(
                                  imgPath:
                                      cartModel?.pictureInfo?.picCoverSmall,
                                  needAnimation: false,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.only(left: 12),
                              child: SizedBox(
                                height: 90,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Padding(
                                    //   padding: const EdgeInsets.only(bottom: 3.0),
                                    //   child: Text(
                                    //     '${bean?.goodsName}',
                                    //     style: TaojuwuTextStyle.TITLE_TEXT_STYLE,
                                    //   ),
                                    // ),
                                    Spacer(),
                                    Text(
                                      '¥${cartModel?.price}',
                                      style: TaojuwuTextStyle.RED_TEXT_STYLE
                                          .copyWith(fontSize: 14),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Text(
                                        '已选:' + "${cartModel?.length}米",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: const Color(0xFF6D6D6D)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                          ],
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            '米数',
                            style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF333333),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 36,
                            maxWidth: 128,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: TextField(
                              // autofocus: true,
                              controller:
                                  TextEditingController(text: cartModel.length),
                              onChanged: (String text) {
                                temp = text;
                              },
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Color(0xFFF5F5F5),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color(0xFFEFF0F0))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color(0xFFEFF0F0))),
                                  contentPadding: EdgeInsets.only(
                                      left: 10, top: 8, bottom: 8, right: 10),
                                  hintText: "输入米数"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
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
              builder: (BuildContext context, ProductDetailBeanResp response) {
                ProductDetailBeanDataWrapper wrapper = response?.data;
                ProductDetailBean bean = wrapper?.goods;
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
                                                      ?.curProductSkuBean
                                                      ?.image,
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
                                                    '¥${provider?.curProductSkuBean?.price ?? ''}',
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
                                                ProductDetailBeanSpecListBean
                                                    item =
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
                                                        ProductDetailBeanSpecValueBean
                                                            e =
                                                            item?.value[index];
                                                        return Container(
                                                          height: 28,
                                                          child: ZYActionChip(
                                                            callback: () {
                                                              item?.value
                                                                  ?.forEach(
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

class OptionView extends StatelessWidget {
  final String img;
  final String text;
  final String price;
  final Function callback;
  final bool showBorder;

  bool get showPrice => double.parse(price ?? '0.00') != 0.0;
  const OptionView(
      {Key key,
      this.img,
      this.text: '',
      this.callback,
      this.showBorder: false,
      this.price: ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return InkWell(
      onTap: callback,
      child: Container(
        width: width / 5,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: showBorder
                            ? Theme.of(context).accentColor
                            : Colors.transparent,
                        width: 1.2)),
                child: ZYNetImage(
                  imgPath: img,
                  callback: callback,
                  width: UIKit.width(150),
                  height: UIKit.width(150),
                )),
            Padding(
              padding: EdgeInsets.only(top: UIKit.height(10)),
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: showBorder
                    ? textTheme.bodyText2.copyWith(fontSize: 12)
                    : textTheme.caption,
              ),
            ),
            Offstage(
              offstage: !showPrice,
              child: Padding(
                padding: EdgeInsets.only(top: UIKit.height(10)),
                child: Text(
                  '¥$price',
                  textAlign: TextAlign.center,
                  style: showBorder
                      ? textTheme.bodyText2.copyWith(fontSize: 12)
                      : textTheme.caption,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
