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
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/no_data.dart';

class CartPage extends StatefulWidget {
  final int clientId;
  CartPage({Key key, this.clientId}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  final List<String> tabs = ['窗帘'];

  TabController tabController;
  CartListWrapper wrapper;
  List<CartModel> models;
  bool isLoading = true;
  int get count => models?.length ?? 0;
  @override
  void initState() {
    super.initState();
    ClientProvider clientProvider =
        Provider.of<ClientProvider>(context, listen: false);
    OTPService.cartList(context,
            params: {'client_uid': clientProvider?.clientId})
        .then((CartListResp response) {
      tabController = TabController(length: tabs?.length, vsync: this);
      isLoading = false;
      print(response);
      if (response?.valid == true) {
        wrapper = response?.data;
        models = wrapper?.data;
      }
      setState(() {});
    }).catchError((err) => err);
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
    return isLoading
        ? LoadingCircle()
        : ChangeNotifierProvider(
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
                    bottom: PreferredSize(
                        child: TabBar(
                            controller: tabController,
                            indicatorSize: TabBarIndicatorSize.label,
                            tabs: List.generate(tabs.length, (int i) {
                              return Text('${tabs[i]}($count)');
                            })),
                        preferredSize: Size.fromHeight(20)),
                  ),
                  body: TabBarView(
                      controller: tabController,
                      children: List.generate(tabs.length, (int i) {
                        print(models);
                        return models == null || models?.isNotEmpty != true
                            ? NoData()
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: models?.length ?? 0,
                                itemBuilder: (BuildContext context, int i) {
                                  return CartCardView(
                                    cartModel: models[i],
                                  );
                                });
                      })),
                  bottomNavigationBar: provider?.models?.isNotEmpty != true
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
  }
}
