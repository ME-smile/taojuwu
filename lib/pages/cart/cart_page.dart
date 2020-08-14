import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:taojuwu/models/shop/cart_list_model.dart';
import 'package:taojuwu/pages/order/commit_order_page.dart';

import 'package:taojuwu/providers/cart_provider.dart';

import 'package:taojuwu/router/handlers.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';

import 'package:taojuwu/utils/ui_kit.dart';

import 'package:taojuwu/widgets/zy_raised_button.dart';

import 'widgets/cart_tabbar_view.dart';

class CartPage extends StatefulWidget {
  final int clientId;
  CartPage({Key key, this.clientId}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
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

  CartModel get curCartModel => cartProvider?.curCartModel;

  @override
  void initState() {
    super.initState();
    _cartProvider = CartProvider();

    tabController =
        TabController(length: cartProvider?.categoryList?.length, vsync: this);
    fetchData();
  }

  Future fetchData() {
    return OTPService.cartCategory(context, params: {
      'client_uid': clientId,
    }).then((CartCategoryResp response) {
      categoryList = response?.data?.data;

      cartProvider?.categoryList = categoryList;

      tabController = TabController(
          length: cartProvider?.categoryList?.length, vsync: this);
    }).whenComplete(() {
      if (mounted) {
        // CartProvider cartProvider = context.watch()<CartProvider>();
        // cartProvider?.setData(
        //     List.filled(categoryList?.length ?? 0, []), categoryList);
        // cartProvider?.assignModelList(0, wrapper?.data);

      }
    });
  }

  @override
  void dispose() {
    tabController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) {
        return _cartProvider;
      },
      builder: (BuildContext context, Widget _) {
        return Scaffold(
            appBar: AppBar(
              title: Text('购物车'),
              centerTitle: true,
              actions: <Widget>[
                Selector<CartProvider, bool>(
                    builder: (BuildContext context, bool isEditting, _) {
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
                  child: Selector<CartProvider, List<CartCategory>>(
                    builder:
                        (BuildContext context, List<CartCategory> list, _) {
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
                          tabs: list
                              ?.map((bean) =>
                                  Text('${bean?.name}(${bean?.count})'))
                              ?.toList());
                    },
                    selector: (BuildContext context, CartProvider provider) =>
                        provider?.categoryList,
                  ),
                  preferredSize: Size.fromHeight(20)),
            ),
            body: Consumer(
              builder: (BuildContext context, CartProvider provider, _) {
                return TabBarView(
                    controller: tabController,
                    children: provider?.categoryList
                        ?.map((e) => CartTabBarView(
                              clientId: clientId,
                              categoryId: e?.id,
                            ))
                        ?.toList());
              },
            ),
            bottomNavigationBar: Consumer(
              builder: (BuildContext context, CartProvider provider, _) {
                return Visibility(
                  visible: provider?.hasModels == true,
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
                                    provider?.batchRemoveGoods(
                                        context, clientId);
                                  },
                                  isActive: provider?.hasSelectedModels,
                                )
                              : ZYRaisedButton(
                                  '结算(${provider?.totalCount ?? 0})', () {
                                  TargetClient.instance.clientId =
                                      provider?.clientId;
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (BuildContext context) {
                                        return CommitOrderPage(
                                          params: {
                                            'data': provider?.checkedModels
                                          },
                                        );
                                      },
                                    ),
                                  );
                                  // RouteHandler.goCommitOrderPage(context,
                                  //     params: jsonEncode(
                                  //         {'data': provider?.checkedModels}));
                                }),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ));
      },
    );
  }
}
