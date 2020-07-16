import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/constants/constants.dart';
// import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/models/shop/cart_list_model.dart';
import 'package:taojuwu/models/zy_response.dart';

import 'package:taojuwu/providers/cart_provider.dart';

import 'package:taojuwu/router/handlers.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/no_data.dart';
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
    with SingleTickerProviderStateMixin {
  final List<String> tabs = ['窗帘'];
  ScrollController scrollController;
  TabController tabController;
  CartListWrapper wrapper;
  List<CartModel> models;
  bool isLoading = true;
  int get count => models?.length ?? 0;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    Future.delayed(Constants.TRANSITION_DURATION, () {
      fetchData();
    });
  }

  void fetchData() {
    OTPService.cartList(context, params: {'client_uid': widget?.clientId})
        .then((CartListResp response) {
      tabController = TabController(length: tabs?.length, vsync: this);
      isLoading = false;
      if (response?.valid == true) {
        wrapper = response?.data;
        models = wrapper?.data;
      }
      if (mounted) {
        setState(() {});
      }
    }).catchError((err) {
      if (mounted) {
        setState(() {});
      }
      return err;
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
  }

  void delCart(CartProvider provider, int id) {
    OTPService.delCart(params: {'cart_id_array': '$id'})
        .then((ZYResponse response) {
      if (response.valid) {
        provider?.removeGoods(id);
        Navigator.of(context).pop();
      } else {
        CommonKit.showToast(response?.message ?? '');
      }
    }).catchError((err) => err);
  }

  void remove(CartProvider provider, CartModel cartModel) {
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
                        delCart(provider, cartModel?.cartId);
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
              content: Text('您确定要从购物车中删除该商品吗?'),
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

  Widget buildCartCard(CartModel cartModel) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    // List<OrderProductAttrWrapper> attrs = cartModel.wcAttr;
    // String attrsText = '';
    // attrs.forEach((OrderProductAttrWrapper item) {
    //   attrsText +=
    //       '${item.attrName}: ${item.attrs.map((item) => item.name).toList().join('')}  ';
    // });
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
                        Text(
                          cartModel?.goodsName ?? '',
                          style:
                              textTheme.title.copyWith(fontSize: UIKit.sp(28)),
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
                        Text.rich(TextSpan(
                            text: '￥' + '${cartModel?.price}' ?? '',
                            children: [TextSpan(text: cartModel?.unit)])),
                      ],
                    ),
                  ))
                ],
              ),
              Text.rich(
                TextSpan(text: '预计总金额', children: [
                  TextSpan(
                      text: '￥' +
                              (double.parse(
                                      cartModel?.estimatedPrice ?? '0.00'))
                                  .toStringAsFixed(2) ??
                          '')
                ]),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return isLoading
        ? LoadingCircle()
        : ChangeNotifierProvider(
            create: (_) {
              CartProvider cartProvider = CartProvider(models: models);
              return cartProvider;
            },
            child: Consumer<CartProvider>(
              builder: (BuildContext context, CartProvider provider, _) {
                List<CartModel> models = provider?.models;
                return Scaffold(
                  appBar: AppBar(
                    title: Text('购物车'),
                    centerTitle: true,
                    bottom: PreferredSize(
                        child: TabBar(
                            controller: tabController,
                            indicatorSize: TabBarIndicatorSize.label,
                            labelPadding:
                                EdgeInsets.only(bottom: 5, left: 5, right: 5),
                            tabs: List.generate(tabs.length, (int i) {
                              return Text('${tabs[i]}($count)');
                            })),
                        preferredSize: Size.fromHeight(20)),
                  ),
                  body: TabBarView(
                      controller: tabController,
                      children: List.generate(tabs.length, (int i) {
                        return (models == null || models?.isEmpty == true)
                            ? NoData()
                            : AnimationLimiter(
                                child: ListView.separated(
                                  itemBuilder: (BuildContext context, int i) {
                                    return AnimationConfiguration.staggeredList(
                                        position: i,
                                        duration:
                                            const Duration(milliseconds: 375),
                                        child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: buildCartCard(
                                                models[i],
                                              ),
                                            )));
                                    // return buildCollectCard(context, beanList[i], i);
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int i) {
                                    return Divider();
                                  },
                                  itemCount: models?.length ?? 0,
                                ),
                              );
                        // : ListView.builder(
                        //     shrinkWrap: true,
                        //     itemCount: models?.length ?? 0,
                        //     itemBuilder: (BuildContext context, int i) {
                        //       return buildCartCard(
                        //         models[i],
                        //       );
                        //     });
                      })),
                  bottomNavigationBar: provider?.hasModels == false
                      ? SizedBox.shrink()
                      : Container(
                          decoration: BoxDecoration(
                              color: themeData.primaryColor,
                              border: Border(
                                  top: BorderSide(
                                      width: .5, color: Colors.grey))),
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
                                margin: EdgeInsets.symmetric(
                                    horizontal: UIKit.width(20)),
                                child: ZYRaisedButton(
                                    '结算(${provider?.totalCount ?? 0})', () {
                                  TargetClient.instance.clientId =
                                      provider?.clientId;
                                  RouteHandler.goCommitOrderPage(context,
                                      params: jsonEncode(
                                          {'data': provider?.checkedModels}));
                                }),
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     TargetClient.instance.clientId =
                              //         provider?.clientId;
                              //     RouteHandler.goCommitOrderPage(context,
                              //         params: jsonEncode(
                              //             {'data': provider?.checkedModels}));
                              //   },
                              //   child: Container(
                              //     margin: EdgeInsets.symmetric(
                              //         horizontal: UIKit.width(20),
                              //         vertical: UIKit.height(20)),
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: UIKit.width(40),
                              //         vertical: UIKit.height(15)),
                              //     child: Text(
                              //       '结算(${provider?.totalCount ?? 0})',
                              //       style: themeData.accentTextTheme.button,
                              //     ),
                              //     color: themeData.accentColor,
                              //   ),
                              // )
                            ],
                          ),
                        ),
                );
              },
            ),
          );
  }
}
