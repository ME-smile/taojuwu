import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/pages/order/order_detail_page.dart';
import 'package:taojuwu/pages/order/widgets/measure_order_card.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/animated_dropdown_drawer.dart';
import 'package:taojuwu/widgets/loading.dart';

import 'package:taojuwu/widgets/no_data.dart';
import 'package:taojuwu/widgets/search_button.dart';

import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_action_chip.dart';

import 'package:taojuwu/widgets/zy_dropdown_route.dart';
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
    with TickerProviderStateMixin, RouteAware {
  List items = Constants.ORDER_STATUS_TAB_MAP.values.toList();
  List<String> tabs = Constants.ORDER_STATUS_TAB_LIST;
  TabController _tabController;

  List nums;

  Animation<double> _iconTurns;
  AnimationController _controller;
  List<List<OrderModelData>> modelList =
      List(Constants.ORDER_STATUS_TAB_LIST.length);

  bool isLoading = true;
  static const PAGE_SIZE = 10;
  List<Map<String, dynamic>> params = [
    {
      'page_size': PAGE_SIZE,
      'page': 1,
      'status': 'ing',
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
    {
      'status': '9',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
    {
      'status': '0',
      'page_size': PAGE_SIZE,
      'page': 1,
    },
  ];
  List<Map<String, dynamic>> statusOptions = [
    {
      'text': '进行中',
      'is_checked': true,
      'status': 'ing',
      'count': 0,
      'index': 0
    },
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
      'text': '待付款',
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
    {'text': '已完成', 'is_checked': false, 'status': '8', 'count': 0, 'index': 9},
    {
      'text': '已取消',
      'is_checked': false,
      'status': '9',
      'count': 0,
      'index': 10
    },
    {'text': '全部', 'is_checked': false, 'status': '', 'count': 0, 'index': 11},
  ];
  Map<String, dynamic> get currentStatusOption =>
      statusOptions?.firstWhere((item) => item['is_checked']);
  Map<String, dynamic> get currentTimePeriodOption =>
      timePeriodOptions?.firstWhere((item) => item['is_checked']);
  List<Map<String, dynamic>> timePeriodOptions = [
    {
      'text': '全部时间',
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

    return StatefulBuilder(builder: (BuildContext ctx, Function setState) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          setState(() {
            showFilterHeader = false;
            hasNotPush = true;
          });
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          color: themeData.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10),
                // decoration: BoxDecoration(
                //   color: themeData.primaryColor,
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      List<Widget>.generate(timePeriodOptions?.length, (int i) {
                    Map<String, dynamic> item = timePeriodOptions[i];

                    return Expanded(
                      child: AspectRatio(
                        aspectRatio: 4,
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                          child: ZYActionChip(
                            showNumber: false,
                            bean: ActionBean.fromJson(item),
                            callback: () {
                              checkTimePeriodOptions(i);
                              setState(() {});
                            },
                          ),
                        ),
                        // child: buildButtonChip(item['text'], () {
                        //   checkTimePeriodOptions(i);
                        // }, item['is_checked']),
                      ),
                    );
                  }),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: UIKit.width(20), top: 16),
                    child: Text('选择状态',
                        style: textTheme.caption.copyWith(
                            backgroundColor: Colors.white,
                            fontSize: UIKit.sp(28))),
                  ),
                ),
              ),
              Container(
                color: themeData.primaryColor,
                alignment: Alignment.topCenter,
                child: GridView.count(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 8),
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 10,
                  childAspectRatio: 4,
                  children: List<Widget>.generate(
                    statusOptions.length,
                    (int i) {
                      Map<String, dynamic> item = statusOptions[i];

                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                        child: ZYActionChip(
                          showNumber: true,
                          bean: ActionBean.fromJson(item),
                          callback: () {
                            checkStatusOptions(i);
                            setState(() {});
                          },
                        ),
                      );
                      // return buildButtonChip('${item['text']}(${item['count']})',
                      //     () {
                      //   checkStatusOptions(i);
                      // }, item['is_checked']);
                    },
                  ),
                ),
              ),
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: closeDropdownDrawer,
                  child: Container(
                    color: themeData.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: ZYSubmitButton('确认', closeDropdownDrawer),
                  ))
            ],
          ),
        ),
      );
    });
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

  Future rotateArrow({BuildContext ctx}) async {
    print(_controller.status);
    if (_controller.status == AnimationStatus.dismissed) {
      _controller
        ..reset()
        ..forward()?.then<void>((void value) {});
    } else {
      _controller.reverse().then<void>((void value) {
        // Navigator.of(context).pop();
      });
    }
  }

  void closeDropdownDrawer() {
    currentStatus = currentStatusOption['status'];
    currentOrderTime = currentTimePeriodOption['index'];

    showFilterHeader = false;

    hasNotPush = true;
    Navigator.of(context).pop();
    Future.delayed(Duration(milliseconds: 500), () {
      _tabController?.animateTo(currentStatusOption['index']);
    });
    // rotateArrow();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    Application.routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  int get tabIndex => _tabController?.index;

  void updateTabNums() {
    Map<String, dynamic> args = formatArgs();

    OTPService.orderList(context, params: args)
        .then((OrderModelListResp response) {
      nums = response?.data?.statusNum?.values?.toList();

      for (int i = 0; i < nums.length; i++) {
        Map<String, dynamic> item = statusOptions[i];
        item['count'] = nums[i];
        // RegExp reg = new RegExp(r'(\d+)');
        // if (reg.hasMatch(item['text'])) return;
        // String str = item['text'];

      }
    }).catchError((err) {
      return err;
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void didPopNext() {
    if (tabIndex == 3) updateTabNums();
  }

  Widget buildButtonChip(String text, Function callback, bool isActive) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            border:
                Border.all(color: isActive ? Colors.black : Color(0xFFCBCBCB))),
        margin: EdgeInsets.symmetric(horizontal: 10),
        // padding: EdgeInsets.symmetric(vertical: 6),
        child: Text(
          text,
          style: TextStyle(color: isActive ? Colors.black : Color(0xFF464646)),
        ),
      ),
      onTap: callback,
    );
  }

  double tabBarHeight = 0.0;
  double tabBarDy = 0.0;
  @override
  void initState() {
    super.initState();
    Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);
    Animatable<double> _easeInTween = CurveTween(curve: Curves.linear);
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      RenderObject renderObject = tabBarKey.currentContext.findRenderObject();
      Size size = renderObject.paintBounds.size;
      var vector3 = renderObject.getTransformTo(null)?.getTranslation();
      final double dy = vector3[1];
      setState(() {
        tabBarDy = dy;
        tabBarHeight = size.height;
      });
    });
    //对全部数据进行���殊处理
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

  Map<String, dynamic> formatArgs() {
    Map<String, dynamic> args = {};
    print(currentParams);
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
      for (int i = 0; i < nums.length; i++) {
        Map<String, dynamic> item = statusOptions[i];
        item['count'] = nums[i];
        // RegExp reg = new RegExp(r'(\d+)');
        // if (reg.hasMatch(item['text'])) return;
        // String str = item['text'];
        // item['text'] = '${item['text']}(${item['count']})';
      }
    }).catchError((err) {
      return err;
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
    _controller?.dispose();
    Application.routeObserver.unsubscribe(this);
  }

  GlobalKey<AniamatedDropdownDrawerState> drawerKey =
      GlobalKey<AniamatedDropdownDrawerState>();
  Future openDropdownDrawer(BuildContext ctx) {
    RenderBox renderBox = ctx.findRenderObject();
    Rect box = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    hasNotPush = false;
    return Navigator.of(context)
        .push(PopDownRoute(
      buildFilterPanel(context),
      offsetY: box.bottom - 10,
      drawerKey: drawerKey,
    ))
        .whenComplete(() {
      setState(() {
        hasNotPush = true;
        showFilterHeader = false;
        rotateArrow();
      });
    });
  }

  String currentStatus = 'ing';
  int currentOrderTime = 0;
  bool hasNotPush = true; // 是否已经打开筛选弹窗
  Map<String, dynamic> get currentParams => {
        'status': currentStatus,
        'page_size': PAGE_SIZE,
        'page': 1,
        'order_time': currentOrderTime,
        'client_uid': widget.clientId ?? '',
      };

  bool showFilterHeader = false;
  // GlobalKey<ZYDropdownMenuState> globalKey = GlobalKey<ZYDropdownMenuState>();
  GlobalKey tabBarKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('订单管理'),
        actions: <Widget>[SearchButton(type: 3)],
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
            child: Container(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Visibility(
                      child: Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                        child: Text('选择日期范围',
                            style: textTheme.caption.copyWith(
                                backgroundColor: Colors.white,
                                fontSize: UIKit.sp(28))),
                      ),
                      visible: showFilterHeader,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 48),
                    child: TabBar(
                        key: tabBarKey,
                        controller: _tabController,
                        isScrollable: true,
                        indicatorColor: !showFilterHeader
                            ? Colors.black
                            : Colors.transparent,
                        unselectedLabelColor: Colors.grey,
                        indicatorSize: TabBarIndicatorSize.label,
                        // labelStyle: TextStyle(fontSize: UIKit.sp(28)),
                        labelPadding:
                            EdgeInsets.only(bottom: 5, left: 10, right: 10),
                        tabs: List.generate(tabs.length, (int i) {
                          return Opacity(
                            child: Text(
                              '${tabs[i]}(${nums == null ? 0 : nums[i]})',
                              textDirection: TextDirection.ltr,
                            ),
                            opacity: !showFilterHeader ? 1.0 : 0.0,
                          );
                        })),
                  ),
                  Positioned(
                    child: Visibility(
                      child: Container(
                        alignment: Alignment.center,
                        width: 2,
                        height: 16,
                        color: const Color(0xFFD4D4D4),
                      ),
                      visible: !showFilterHeader,
                    ),
                    top: 3,
                    right: 48,
                  ),
                  Positioned(
                    child: Builder(builder: (BuildContext ctx) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          setState(() {
                            showFilterHeader = !showFilterHeader;
                          });
                          rotateArrow();
                          if (hasNotPush) {
                            openDropdownDrawer(ctx);
                          } else {
                            closeDropdownDrawer();
                          }
                        },
                        child: Container(
                          width: 48,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey))),
                          padding:
                              EdgeInsets.only(left: 5, right: 5, bottom: 9),
                          child: RotationTransition(
                            turns: _iconTurns,
                            child: const Icon(
                              Icons.expand_more,
                              size: 24,
                            ),
                          ),
                        ),
                      );
                    }),
                    top: 0,
                    right: 0,
                  )
                ],
              ),
            ),
            preferredSize: Size.fromHeight(20)),
      ),
      body: TabBarView(
          controller: _tabController,
          children: List.generate(tabs.length ?? 0, (int i) {
            params[i]['order_time'] = currentTimePeriodOption['index'];
            print(params[i]);

            return OrderTabView(
              tab: i,
              clientId: widget.clientId,
              params: params[i],
              models: modelList[i],
            );
          })),
    );
    // return Stack(
    //   children: <Widget>[
    //     Positioned(
    //       child: Offstage(
    //         offstage: !showFilterHeader,
    //         child: GestureDetector(
    //           onTap: () {
    //             globalKey.currentState.handleTap();
    //             _controller.reverse().then<void>((void value) {
    //               if (!mounted) return;
    //               setState(() {
    //                 // Rebuild without widget.children.
    //                 showFilterHeader = false;
    //               });
    //             });
    //           },
    //           child: Container(
    //             color: showFilterHeader
    //                 ? Color.fromARGB(125, 0, 0, 0)
    //                 : Colors.transparent,
    //           ),
    //         ),
    //       ),
    //       top: tabBarDy + tabBarHeight,
    //       bottom: 0,
    //       left: 0,
    //       right: 0,
    //     ),
    //     Positioned(
    //       top: tabBarDy,
    //       left: 0,
    //       child: Offstage(
    //         offstage: !showFilterHeader,
    //         child: Material(
    //           child: Container(
    //             height: 30,
    //             alignment: Alignment.centerLeft,
    //             width: MediaQuery.of(context).size.width,
    //             padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
    //             color: Colors.white,
    //             child: Text(
    //               '选择日期范围',
    //               style: textTheme.caption.copyWith(
    //                   backgroundColor: Colors.white, fontSize: UIKit.sp(28)),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     Positioned(
    //       top: tabBarDy,
    //       right: 0,
    //       child: Builder(builder: (BuildContext ctx) {
    //         return GestureDetector(
    //           onTap: () {
    //             RenderBox renderBox = ctx.findRenderObject();
    //             Rect box =
    //                 renderBox.localToGlobal(Offset.zero) & renderBox.size;
    //             Navigator.of(context).push(ZYDropdownRoute(
    //                 position: box,
    //                 child: Container(
    //                   color:
    //                       showFilterHeader ? Colors.white : Colors.transparent,
    //                   alignment: Alignment.centerRight,
    //                   width: MediaQuery.of(context).size.width,
    //                   // height: MediaQuery.of(context).size.width,
    //                   child: Material(
    //                     color: showFilterHeader
    //                         ? Colors.white
    //                         : Colors.transparent,
    //                     shadowColor: Colors.transparent,
    //                     child: ZYDropdownMenu(
    //                       key: globalKey,
    //                       showPanel: showFilterHeader,
    //                       title: '选择日期范围',
    //                       children: <Widget>[buildFilterPanel(context)],
    //                       onExpansionChanged: (bool flag) {
    //                         setState(() {
    //                           showFilterHeader = flag;
    //                         });
    //                       },
    //                     ),
    //                   ),
    //                 )));
    //             rotateArrow();
    //             globalKey.currentState?.handleTap();
    //           },
    //           child: Container(
    //             alignment: Alignment.center,
    //             height: tabBarHeight,
    //             color: Colors.white,
    //             width: 40,
    //             child: Row(
    //               children: <Widget>[
    //                 Container(
    //                   width: 1,
    //                   // height: tabBarHeight - 10,
    //                   color: showFilterHeader
    //                       ? Colors.transparent
    //                       : Color(0xFFD4D4D4),
    //                   // padding: EdgeInsets.symmetric(vertical: 10),
    //                   margin: EdgeInsets.only(bottom: 9, top: 3),
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(left: 5, right: 5, bottom: 9),
    //                   child: RotationTransition(
    //                     turns: _iconTurns,
    //                     child: const Icon(Icons.expand_more),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         );
    //       }),
    //     ),
    // Positioned(
    //     top: tabBarDy + tabBarHeight,
    //     right: 0,
    //     child: Container(
    //       color: showFilterHeader ? Colors.white : Colors.transparent,
    //       alignment: Alignment.centerRight,
    //       width: MediaQuery.of(context).size.width,
    //       // height: MediaQuery.of(context).size.width,
    //       child: Material(
    //         color: showFilterHeader ? Colors.white : Colors.transparent,
    //         shadowColor: Colors.transparent,
    //         child: ZYDropdownMenu(
    //           key: globalKey,
    //           showPanel: showFilterHeader,
    //           title: '选择日期范围',
    //           children: <Widget>[buildFilterPanel(context)],
    //           onExpansionChanged: (bool flag) {
    //             setState(() {
    //               showFilterHeader = flag;
    //             });
    //           },
    //         ),
    //       ),
    //     )),
    //   ],
    // );
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
    with AutomaticKeepAliveClientMixin, RouteAware {
  Map<String, dynamic> get params => widget.params;
  List<OrderModelData> get models => widget.models;
  String get orderStatus {
    if (tab == 4) {
      params['status'] = '3';
    }
    return params['status'];
  }

  int get tab => widget.tab;
  int get clientId => widget.clientId;
  int totalPage = 0;

  static const PAGE_SIZE = 10;

  bool get isStatusEmpty => orderStatus?.isNotEmpty != true;
  bool hasMoreData = true;
  RefreshController _refreshController;
  bool isRefresh = true;
  bool isLoading = true;
  OrderModelDataWrapper wrapper;

  @override
  void dispose() {
    super.dispose();
    Application.routeObserver.unsubscribe(this);
    if (mounted) _refreshController?.dispose();
  }

  @override
  void didPopNext() {
    //当处于待选品状态时
    if (mounted && tab == 3) {
      isRefresh = true;
      params['page'] = 1;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _refreshController?.requestRefresh();
      });
    }
    super.didPopNext();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Application.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void initState() {
    super.initState();

    _refreshController = RefreshController(initialRefresh: false);
    isLoading = true;
    Future.delayed(Duration(milliseconds: 375), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((callback))
  }

  void requestData(Map<String, dynamic> args) {
    params.addAll({'client_uid': clientId});
    print(params);
    OTPService.orderList(context, params: params)
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

    return PageTransitionSwitcher(
      duration: Duration(milliseconds: 500),
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: isLoading
          ? LoadingCircle()
          : models?.isEmpty == true
              ? NoData()
              : AnimationLimiter(
                  child: SmartRefresher(
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
                  child: ListView.separated(
                      itemBuilder: (BuildContext context, int i) {
                        OrderModelData item = models[i];
                        Widget child;
                        if (item?.hasMoreThanTwoItems == true) {
                          child = item?.isMeasureOrder == true
                              ? MeasureOrderCard(
                                  orderModelData: item,
                                  canClick: true,
                                  orderStatus: orderStatus,
                                )
                              : OrderCard(
                                  item,
                                  canClick: true,
                                  orderStatus: orderStatus,
                                );
                        } else {
                          child = OpenContainer<bool>(
                            transitionDuration: Constants.TRANSITION_DURATION,
                            closedBuilder:
                                (BuildContext context, VoidCallback _) {
                              return item?.isMeasureOrder == true
                                  ? MeasureOrderCard(
                                      orderModelData: item,
                                      orderStatus: orderStatus,
                                    )
                                  : OrderCard(
                                      item,
                                      orderStatus: orderStatus,
                                    );
                            },
                            closedElevation: 0,
                            openElevation: 0,
                            openBuilder:
                                (BuildContext context, VoidCallback _) {
                              return OrderDetailPage(
                                id: item?.orderId,
                                orderStatus: orderStatus,
                              );
                            },
                          );
                        }
                        return AnimationConfiguration.staggeredList(
                            duration: const Duration(milliseconds: 375),
                            position: i,
                            child: SlideAnimation(
                              verticalOffset: 100.0,
                              child: FadeInAnimation(child: child),
                            ));
                      },
                      separatorBuilder: (BuildContext context, int i) {
                        return VSpacing(20);
                      },
                      itemCount: models?.length ?? 0),
                )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
