import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/pages/order/widgets/measure_order_card.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/no_data.dart';
import 'package:taojuwu/widgets/search_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

import 'widgets/order_card.dart';

class OrderPage extends StatefulWidget {
  final String clientId;
  OrderPage({Key key, this.clientId: ''}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  List items = Constants.ORDER_STATUS_TAB_MAP.values.toList();
  TabController _tabController;
  List nums;
  List<OrderModelData> models;
  List<Map<String, dynamic>> params = [
    {},
    {
      'status': '1',
    },
    {
      'status': '2',
    },
    {
      'status': '14',
    },
    {
      'status': '3',
    },
    {
      'status': '5',
    },
    {
      'status': '6,7',
    },
    {
      'status': '8',
    },
  ];
  @override
  void initState() {
    super.initState();
    OTPService.orderList(context).then((OrderModelListResp response) {
      setState(() {
        nums = response?.data?.statusNum?.values?.toList();
        models = response?.data?.data ?? [];
      });
    }).catchError((err) => err);
    _tabController = TabController(length: items.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZYFutureBuilder(
        futureFunc: OTPService.orderList,
        params: params[_tabController.index],
        builder: (BuildContext context, OrderModelListResp response) {
          return Scaffold(
              appBar: AppBar(
                title: Text('订单管理'),
                actions: <Widget>[SearchButton(type: 3)],
                centerTitle: true,
                bottom: PreferredSize(
                    child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        unselectedLabelColor: Colors.grey,
                        labelPadding: EdgeInsets.only(
                            bottom: UIKit.height(10),
                            left: UIKit.width(10),
                            right: UIKit.width(10)),
                        tabs: List.generate(
                            Constants.ORDER_STATUS_TAB_MAP.length, (int i) {
                          return Text(
                            '${items[i]}(${nums == null ? 0 : nums[i]})',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(fontSize: UIKit.sp(32)),
                          );
                        })),
                    preferredSize: Size.fromHeight(UIKit.height(60))),
              ),
              body: TabBarView(
                  controller: _tabController,
                  children: List.generate(items?.length ?? 0, (int i) {
                    return OrderTabView(
                      params: params[i],
                      models: i == 0 ? models : null,
                    );
                  })));
        });
  }
}

class OrderTabView extends StatefulWidget {
  final Map<String, dynamic> params;
  final List<OrderModelData> models;
  const OrderTabView({Key key, this.params, this.models}) : super(key: key);

  @override
  _OrderTabViewState createState() => _OrderTabViewState();
}

class _OrderTabViewState extends State<OrderTabView> {
  Map<String, dynamic> params;
  List<OrderModelData> models;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isRefresh = true;
  @override
  void initState() {
    super.initState();
    params = widget.params;
    params['page'] = 1;
    models = widget.models ?? [];
  }

  OrderModelDataWrapper wrapper;

  void requestData() {
    OTPService.orderList(context, params: params)
        .then((OrderModelListResp response) {
      wrapper = response?.data;
      List<OrderModelData> tmp = wrapper?.data ?? [];
      if (isRefresh) {
        if (mounted) {
          setState(() {
            models = tmp;
          });
        }
        _refreshController?.refreshCompleted();
      } else {
        setState(() {
          tmp.forEach((item) {
            if (models?.contains(item) == false) {
              models.addAll(tmp);
            }
          });
          _refreshController?.loadComplete();
        });
      }
    }).catchError((err) {
      if (isRefresh) {
        _refreshController?.refreshFailed();
      } else {
        _refreshController?.loadFailed();
      }
    });
  }

  Widget buildOrderCard(OrderModelData model) {
    if (model?.isMeasureOrder == true) {
      if (model?.hasNotsSelectedProduct == false) {
        return MeasureOrderHasNotSelectedProductedCard(
          orderModelData: model,
        );
      }
    }
    return OrderCard(model);
  }

  Widget buildOrderListView(List<OrderModelData> models) {
    return models == null || models?.isEmpty == true
        ? NoData()
        : SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () async {
              params['page_index'] = 1;
              isRefresh = true;
              requestData();
            },
            onLoading: () async {
              params['page_index']++;
              isRefresh = false;
              requestData();
            },
            child: ListView.separated(
                itemBuilder: (BuildContext context, int i) {
                  OrderModelData item = models[i];

                  return buildOrderCard(item);
                },
                separatorBuilder: (BuildContext context, int i) {
                  return VSpacing(20);
                },
                itemCount: models?.length ?? 0),
          );
  }

  @override
  Widget build(BuildContext context) {
    return models == null
        ? ZYFutureBuilder(
            futureFunc: OTPService.orderList,
            params: params,
            builder: (BuildContext context, OrderModelListResp response) {
              OrderModelDataWrapper wrapper = response?.data;
              List<OrderModelData> models = wrapper?.data;
              return buildOrderListView(models);
            })
        : models?.isEmpty == true ? NoData() : buildOrderListView(models);
  }
}
