import 'dart:async';

import 'package:flutter/cupertino.dart';
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
import 'package:taojuwu/widgets/zy_dropdown_menu.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

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
    with SingleTickerProviderStateMixin {
  List items = Constants.ORDER_STATUS_TAB_MAP.values.toList();
  List<String> tabs = Constants.ORDER_STATUS_TAB_LIST;
  TabController _tabController;

  List nums;

  List<List<OrderModelData>> modelList =
      List(Constants.ORDER_STATUS_TAB_LIST.length);

  bool isLoading = true;
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
      'status': '4',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
    {
      'status': '5',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
    {
      'status': '6',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
    {
      'status': '15',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
    {
      'status': '7',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
    {
      'status': '8',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
  ];
  List<Map<String, dynamic>> statusOptions = [
    {'text': '全部', 'is_checked': true, 'status': '', 'count': 0, 'index': 0},
    {'text': '待审核', 'is_checked': false, 'status': '1', 'count': 0, 'index': 1},
    {'text': '待测量', 'is_checked': false, 'status': '2', 'count': 0, 'index': 2},
    {
      'text': '待选品',
      'is_checked': false,
      'status': '14',
      'count': 0,
      'index': 3
    },
    {
      'text': '付尾款',
      'is_checked': false,
      'status': '3,4',
      'count': 0,
      'index': 4
    },
    {'text': '生产中', 'is_checked': false, 'status': '5', 'count': 0, 'index': 5},
    {'text': '待发货', 'is_checked': false, 'status': '6', 'count': 0, 'index': 6},
    {
      'text': '待收货',
      'is_checked': false,
      'status': '15',
      'count': 0,
      'index': 7
    },
    {'text': '待安装', 'is_checked': false, 'status': '7', 'count': 0, 'index': 8},
    {'text': '已完成', 'is_checked': false, 'status': '8', 'count': 0, 'index': 9}
  ];
  Map<String, dynamic> get currentStatusOption =>
      statusOptions?.firstWhere((item) => item['is_checked']);
  Map<String, dynamic> get currentTimePeriodOption =>
      timePeriodOptions?.firstWhere((item) => item['is_checked']);
  List<Map<String, dynamic>> timePeriodOptions = [
    {
      'text': '全部',
      'is_checked': true,
      'index': 0,
    },
    {
      'text': '近三个月',
      'is_checked': false,
      'index': 1,
    },
    {'text': '三个月前', 'is_checked': false, 'index': 2}
  ];
  Widget buildFilterPanel(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          VSpacing(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List<Widget>.generate(timePeriodOptions?.length, (int i) {
              Map<String, dynamic> item = timePeriodOptions[i];
              return Expanded(
                child: buildButtonChip(item['text'], () {
                  checkTimePeriodOptions(i);
                }, item['is_checked']),
              );
            }),
          ),
          VSpacing(20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
            child: Text('选择状态',
                style: textTheme.caption.copyWith(
                    backgroundColor: Colors.white, fontSize: UIKit.sp(28))),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: GridView.count(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: UIKit.height(16)),
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 10,
              childAspectRatio: 4,
              children: List<Widget>.generate(
                statusOptions.length,
                (int i) {
                  Map<String, dynamic> item = statusOptions[i];

                  return buildButtonChip('${item['text']}(${item['count']})',
                      () {
                    checkStatusOptions(i);
                  }, item['is_checked']);
                },
              ),
            ),
          ),
          ZYSubmitButton('确认', closePanel)
        ],
      ),
    );
  }

  void resetTimePeriodOption() {
    for (int m = 0; m < timePeriodOptions.length; m++) {
      timePeriodOptions[m]['is_checked'] = m == 0;
    }
  }

  void checkTimePeriodOptions(int i) {
    if (currentTimePeriodOption['index'] == i) return;
    for (int m = 0; m < timePeriodOptions.length; m++) {
      timePeriodOptions[m]['is_checked'] = m == i;
    }

    setState(() {});
  }

  void checkStatusOptions(int i) {
    if (currentStatusOption['index'] == i) return;
    for (int m = 0; m < statusOptions.length; m++) {
      statusOptions[m]['is_checked'] = m == i;
    }
    setState(() {});
  }

  void closePanel() {
    currentStatus = currentStatusOption['status'];
    currentOrderTime = currentTimePeriodOption['index'];
    Future.delayed(Duration(milliseconds: 500), () {
      _tabController?.animateTo(currentStatusOption['index']);
    });
    fetchData();
    globalKey.currentState.handleTap();
  }

  Widget buildButtonChip(String text, Function callback, bool isActive) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border:
                Border.all(color: isActive ? Colors.black : Color(0xFFCBCBCB))),
        margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
        padding: EdgeInsets.symmetric(vertical: UIKit.height(12)),
        child: Text(
          text,
          style: TextStyle(color: isActive ? Colors.black : Color(0xFF464646)),
        ),
      ),
      onTap: callback,
    );
  }

  @override
  void initState() {
    super.initState();

    //对全部数据进行特殊处理
    if (mounted) {
      params?.first['client_uid'] = widget?.clientId;
      _tabController = TabController(length: tabs.length, vsync: this)
        ..addListener(() {
          setState(() {
            params?.forEach((item) {
              item['page'] = 1;
            });
            isLoading = true;
            checkStatusOptions(_tabController?.index);
            resetTimePeriodOption();
            currentStatus = '${currentStatusOption['status']}';
            // streamController?.add(currentParams);
            fetchData();
          });
        });
    }

    fetchData();
  }

  @override
  void deactivate() {
    super.deactivate();
    fetchData();
  }

  Map<String, dynamic> formatArgs() {
    Map<String, dynamic> args = {};

    currentParams?.forEach((k, v) {
      args[k] = v;
      if (v is String && v?.isNotEmpty != true) {
        args.remove(k);
      }
    });

    return args;
  }

  void fetchData() {
    Map<String, dynamic> args = formatArgs();

    OTPService.orderList(context, params: args)
        .then((OrderModelListResp response) {
      nums = response?.data?.statusNum?.values?.toList();

      modelList[_tabController?.index] = response?.data?.data;
      for (int i = 0; i < nums.length - 1; i++) {
        statusOptions[i]['count'] = nums[i];
      }
      if (mounted) {
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

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  String currentStatus = '';
  int currentOrderTime = 0;
  Map<String, dynamic> get currentParams => {
        'status': currentStatus,
        'page_size': PAGE_SIZE,
        'page': 1,
        'order_time': currentOrderTime,
        'client_uid': widget.clientId ?? '',
      };

  bool showFilterHeader = false;
  GlobalKey<ZYDropdownMenuState> globalKey = GlobalKey<ZYDropdownMenuState>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            appBar: AppBar(
              title: Text('订单管理'),
              actions: <Widget>[SearchButton(type: 3)],
              centerTitle: true,
              bottom: PreferredSize(
                  child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: TextStyle(fontSize: UIKit.sp(28)),
                      labelPadding: EdgeInsets.only(
                          bottom: UIKit.height(10),
                          left: UIKit.width(10),
                          right: UIKit.width(10)),
                      tabs: List.generate(tabs.length, (int i) {
                        return Text(
                          '${tabs[i]}(${nums == null ? 0 : nums[i]})',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(fontSize: UIKit.sp(28)),
                        );
                      })),
                  preferredSize: Size.fromHeight(UIKit.height(60))),
            ),
            body: TabBarView(
                controller: _tabController,
                children: List.generate(tabs.length ?? 0, (int i) {
                  params[i]['order_time'] = currentTimePeriodOption['index'];
                  params[i] = currentParams;
                  return OrderTabView(
                    tab: i,
                    clientId: widget.clientId,
                    params: params[i],
                    models: modelList[i],
                  );
                }))),
        Positioned(
          child: Offstage(
            offstage: !showFilterHeader,
            child: GestureDetector(
              onTap: () {
                globalKey.currentState.handleTap();
              },
              child: Container(
                color: showFilterHeader
                    ? Color.fromARGB(125, 0, 0, 0)
                    : Colors.transparent,
              ),
            ),
          ),
          top: 80,
          bottom: 0,
          left: 0,
          right: 0,
        ),
        Positioned(
            top: 80,
            right: 0,
            child: Container(
              color: showFilterHeader ? Colors.white : Colors.transparent,
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.width,
              child: Material(
                color: showFilterHeader ? Colors.white : Colors.transparent,
                shadowColor: Colors.transparent,
                child: ZYDropdownMenu(
                  key: globalKey,
                  showPanel: showFilterHeader,
                  title: '选择日期范围',
                  children: <Widget>[buildFilterPanel(context)],
                  onExpansionChanged: (bool flag) {
                    setState(() {
                      showFilterHeader = flag;
                    });
                  },
                ),
              ),
            )),
      ],
    );
  }
}

class OrderTabView extends StatefulWidget {
  final int clientId;
  final int tab;
  final StreamController streamController;
  final Map<String, dynamic> params;
  final String status;
  final List<OrderModelData> models;
  const OrderTabView(
      {Key key,
      this.clientId,
      this.status,
      this.tab,
      this.streamController,
      this.params,
      this.models: const []})
      : super(key: key);

  @override
  _OrderTabViewState createState() => _OrderTabViewState();
}

class _OrderTabViewState extends State<OrderTabView>
    with AutomaticKeepAliveClientMixin {
  Map<String, dynamic> params = {};
  List<OrderModelData> get models => widget.models;
  int totalPage = 0;

  static const PAGE_SIZE = 10;

  bool get isStatusEmpty =>
      params['status'] == null || params['status']?.isNotEmpty != true;
  bool hasMoreData = true;
  RefreshController _refreshController;
  bool isRefresh = true;
  bool isLoading = true;
  OrderModelDataWrapper wrapper;

  @override
  void dispose() {
    super.dispose();
    if (mounted) _refreshController?.dispose();
  }

  @override
  void initState() {
    super.initState();

    _refreshController = RefreshController(initialRefresh: false);
    isLoading = true;
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        isLoading = false;
      });
    });

    // WidgetsBinding.instance.addPostFrameCallback((callback))
  }

  void formatParams(Map<String, dynamic> args) {
    if (isRefresh) args['page'] = 1;
    if (args['status'] != null || args['status']?.isNotEmpty != true)
      args?.remove('status');
  }

  void requestData(Map<String, dynamic> args) {
    formatParams(args);
    print(args);
    OTPService.orderList(context, params: args)
        .then((OrderModelListResp response) {
      wrapper = response?.data;
      int count = wrapper?.totalCount;
      int pages = count ~/ PAGE_SIZE;
      int mod = count % PAGE_SIZE;
      totalPage = mod > 0 ? pages + 1 : pages;

      List<OrderModelData> tmp = wrapper?.data ?? [];
      if (isRefresh) {
        models?.clear();
        models?.addAll(tmp);

        if (mounted) {
          setState(() {});
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return isLoading
        ? LoadingCircle()
        : SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () {
              params['page'] = 1;
              isRefresh = true;
              requestData(params);
            },
            onLoading: () {
              params['page']++;
              isRefresh = false;
              requestData(params);
            },
            child: models?.isEmpty == true
                ? NoData()
                : ListView.separated(
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
  bool get wantKeepAlive => true;
}
