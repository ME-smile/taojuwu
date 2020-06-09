import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/pages/order/widgets/measure_order_card.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/no_data.dart';
import 'package:taojuwu/widgets/search_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

import 'widgets/order_card.dart';

class OrderPage extends StatefulWidget {
  final int clientId;

  OrderPage({
    Key key,
    this.clientId,
  }) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List items = Constants.ORDER_STATUS_TAB_MAP.values.toList();
  TabController _tabController;
  List nums;
  List<OrderModelData> models;

  static const PAGE_SIZE = 10;
  List<Map<String, dynamic>> params = [
    {
      'page_size': PAGE_SIZE,
      'page': 1,
    },
    {
      'status': '1',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
    {
      'status': '2',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
    {
      'status': '14',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
    {
      'status': '3,4',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
    {
      'status': '5',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
    {
      'status': '6,7',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
    {
      'status': '8',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
  ];
  @override
  void initState() {
    super.initState();

    //对全部数据进行特殊处理
    if (mounted) {
      params?.first['client_uid'] = widget?.clientId;
      _tabController = TabController(length: items.length, vsync: this)
        ..addListener(() {
          params?.forEach((item) {
            item['page'] = 1;
          });
        });
    }

    fetchData();
  }

  void fetchData() {
    OTPService.orderList(context, params: params?.first)
        .then((OrderModelListResp response) {
      if (mounted) {
        setState(() {
          nums = response?.data?.statusNum?.values?.toList();
          models = response?.data?.data;
        });
      }
    }).catchError((err) {
      return err;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  tabs: List.generate(Constants.ORDER_STATUS_TAB_MAP.length,
                      (int i) {
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
                tab: i,
                params: params[i],
                clientId: widget.clientId,
                models: i == 0 ? models : null,
              );
            })));
  }

  @override
  bool get wantKeepAlive => true;
}

class OrderTabView extends StatefulWidget {
  final Map<String, dynamic> params;
  final List<OrderModelData> models;
  final int clientId;
  final int tab;
  const OrderTabView(
      {Key key, this.params, this.models, this.clientId, this.tab})
      : super(key: key);

  @override
  _OrderTabViewState createState() => _OrderTabViewState();
}

class _OrderTabViewState extends State<OrderTabView> {
  Map<String, dynamic> params;
  List<OrderModelData> models = [];
  int totalPage = 0;

  static const PAGE_SIZE = 10;

  bool hasMoreData = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isRefresh = true;

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    params = widget.params;
    params['page'] = 1;
    params['client_uid'] = widget.clientId;
    models = widget.models;
    fetchData();
  }

  void fetchData() {
    OTPService.orderList(context, params: params)
        .then((OrderModelListResp response) {
      if (mounted) {
        setState(() {
          wrapper = response?.data;
          models = wrapper?.data;
          isLoading = false;
        });
      }
    }).catchError((err) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  OrderModelDataWrapper wrapper;

  @override
  void deactivate() {
    super.deactivate();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController?.dispose();
  }

  void requestData() {
    OTPService.orderList(context, params: params)
        .then((OrderModelListResp response) {
      wrapper = response?.data;
      int count = wrapper?.totalCount;
      int pages = count ~/ PAGE_SIZE;
      int mod = count % PAGE_SIZE;
      totalPage = mod > 0 ? pages + 1 : pages;

      List<OrderModelData> tmp = wrapper?.data ?? [];
      if (isRefresh) {
        if (mounted) {
          setState(() {
            models = tmp;
          });
        }
        _refreshController?.refreshCompleted();
      } else {
        if (tmp?.isEmpty == true) return _refreshController?.loadNoData();
        setState(() {
          tmp.forEach((item) {
            if (models?.contains(item) == false) {
              models.addAll(tmp);
            }
          });
        });

        _refreshController?.loadComplete();
      }
    }).catchError((err) {
      if (isRefresh) {
        _refreshController?.refreshFailed();
      } else {
        _refreshController?.loadFailed();
      }
    });
  }

  Widget buildOrderListView(List<OrderModelData> models) {
    return models == null || models?.isEmpty == true
        ? NoData()
        : SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () async {
              params['page'] = 1;
              isRefresh = true;
              requestData();
            },
            onLoading: () async {
              params['page']++;
              isRefresh = false;
              requestData();
            },
            child: ListView.separated(
                itemBuilder: (BuildContext context, int i) {
                  OrderModelData item = models[i];
                  return item?.isMeasureOrder == true
                      ? MeasureOrderCard(
                          orderModelData: item,
                        )
                      : OrderCard(item);
                },
                separatorBuilder: (BuildContext context, int i) {
                  return VSpacing(20);
                },
                itemCount: models?.length ?? 0),
          );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingCircle()
        : models == null
            ? buildOrderListView(models ?? [])
            : models?.isNotEmpty != true
                ? NoData()
                : buildOrderListView(models);
  }
}
