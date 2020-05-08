import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/models/shop/cart_list_model.dart';
import 'package:taojuwu/pages/cart/widgets/cart_card_view.dart';

import 'package:taojuwu/providers/cart_provider.dart';
import 'package:taojuwu/providers/client_provider.dart';
import 'package:taojuwu/router/handlers.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  final List<String> tabs = ['窗帘'];

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
  }

  CartProvider cartProvider;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return ZYFutureBuilder(
        futureFunc: OTPService.cartList,
        params: {
          'client_uid': Provider.of<ClientProvider>(context).clientId,
        },
        builder: (BuildContext context, CartListResp response) {
          CartListWrapper wrapper = response?.data;
          List<Category> categories = wrapper?.categories;
          List<CartModel> models = wrapper?.data;
          //  tabController = TabController(length:categories.isEmpty?tabs.length:categories.length, vsync: this);

          return ChangeNotifierProvider(
            create: (_) {
              cartProvider = CartProvider(models: models);
              return cartProvider;
            },
            child: Consumer<CartProvider>(
              builder: (BuildContext context, CartProvider provider, _) {
                List<CartModel> models = provider?.models;
                return Scaffold(
                  appBar: AppBar(
                    title: Text('购物车'),
                    centerTitle: true,
                    bottom: TabBar(
                        controller: tabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: categories?.isEmpty == true
                            ? List.generate(tabs.length, (int i) {
                                return Text('${tabs[i]}(0)');
                              })
                            : List.generate(categories?.length ?? 0, (int i) {
                                Category item = categories[i];
                                return Text('${item.tag}(${item.count})');
                              })),
                  ),
                  body: TabBarView(
                      controller: tabController,
                      children: List.generate(tabs.length, (int i) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: models?.length ?? 0,
                            itemBuilder: (BuildContext context, int i) {
                              return CartCardView(
                                cartModel: models[i],
                              );
                            });
                      })),
                  bottomNavigationBar: provider?.models?.isEmpty == true
                      ? Container()
                      : Container(
                          padding:
                              EdgeInsets.symmetric(vertical: UIKit.height(15)),
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
                              Text('总价: ￥${provider?.totalAmount ?? 0.00}元'),
                              InkWell(
                                onTap: () {
                                  RouteHandler.goCommitOrderPage(context,
                                      params: jsonEncode(
                                          {'data': provider?.checkedModels}));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: UIKit.width(20),
                                      vertical: UIKit.height(20)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: UIKit.width(40),
                                      vertical: UIKit.height(15)),
                                  child: Text(
                                    '结算(${provider?.totalCount ?? 0})',
                                    style: themeData.accentTextTheme.button,
                                  ),
                                  color: themeData.accentColor,
                                ),
                              )
                            ],
                          ),
                        ),
                );
              },
            ),
          );
        });
  }
}
