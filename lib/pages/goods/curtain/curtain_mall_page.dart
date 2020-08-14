// import 'package:animations/animations.dart';

import 'dart:async';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:taojuwu/application.dart';

import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/shop/cart_list_model.dart';
import 'package:taojuwu/models/shop/curtain_product_list_model.dart';

import 'package:taojuwu/models/shop/tag_model.dart';
// import 'package:taojuwu/pages/order/measure_order_page.dart';
import 'package:taojuwu/router/handlers.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';
import 'package:taojuwu/singleton/target_route.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/loading.dart';

import 'package:taojuwu/widgets/no_data.dart';

import 'package:taojuwu/widgets/scan_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_action_chip.dart';

import 'package:taojuwu/widgets/zy_assetImage.dart';
import 'widgets/curtain_list_view.dart';
import 'widgets/goods_filter_header.dart';
import 'widgets/curtain_grid_view.dart';

class CurtainMallPage extends StatefulWidget {
  final String keyword;

  CurtainMallPage({
    Key key,
    this.keyword: '',
  }) : super(key: key);

  @override
  _CurtainMallPageState createState() => _CurtainMallPageState();
}

class _CurtainMallPageState extends State<CurtainMallPage>
    with TickerProviderStateMixin, RouteAware {
  List get tabs => ['窗帘', '配件', '抱枕', '床品', '沙发'];
  List<List<GoodsItemBean>> goodsListWrapper = List(5);
  List<BuildContext> contextList = List(5);
  BuildContext get curTabContext => contextList[tabIndex];
  CurtainProductListDataBean beanData;
  CurtainGoodsListWrapper wrapper;
  ScrollController scrollController;
  GZXDropdownMenuController menuController;

  List<GoodsItemBean> get goodsList => goodsListWrapper[tabIndex];

  int totalPage = 0;

  static const int PAGE_SIZE = 20;

  Map<String, dynamic> params = {
    // 'keyword': '',
    // 'stock': '',
    'order': 'sales',
    'sort': 'desc',
    'page_size': PAGE_SIZE,
    'page_index': 1,

    // 'shippingFee': 0,
    // 'type': 0
  };
  String get keyword => widget.keyword;
  bool get isFromSearch => widget.keyword.isNotEmpty ?? false;

  @override
  void initState() {
    super.initState();
    TargetRoute.instance.context = context;
    params['keyword'] = keyword;
    tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
    menuController = GZXDropdownMenuController();
    scrollController = ScrollController();
    fetchData();
  }

  @override
  void didPopNext() {
    OTPService.cartCount(context, params: {
      'client_uid': TargetClient.instance.clientId,
    })
        .then((CartCountResp cartCountResp) {
          cartCount = cartCountResp?.data;
        })
        .catchError((err) => err)
        .whenComplete(() {
          setState(() {});
        });
  }

  @override
  void didChangeDependencies() {
    Application.routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  List<Map<String, dynamic>> sortTypes = [
    {
      'text': '销量排序',
      'is_checked': true,
      'order': 'sales',
      'sort': 'desc',
    },
    {'text': '新品优先', 'is_checked': false, 'order': 'is_new', 'sort': 'desc'},
    {
      'text': '价格升序',
      'is_checked': false,
      'order': 'price',
      'sort': 'asc',
    },
    {
      'text': '价格降序',
      'is_checked': false,
      'order': 'price',
      'sort': 'desc',
    }
  ];
  Map<String, dynamic> get currentSortType =>
      sortTypes.firstWhere((element) => element['is_checked']);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  RefreshController _refreshController;

  TabController tabController;
  Animation<Offset> animation;
  bool isGridMode = true;
  double width;
  int get tabIndex => tabController?.index ?? 0;
  bool get hasMoreData => params['page_index'] < totalPage;
  TagFilterWrapper tagWrapper;

  Widget _buildFilter1() {
    return ZYAssetImage(
      isGridMode ? 'ic_grid_h.png' : 'ic_grid.png',
      width: 12,
      height: 12,
      callback: () {
        scrollToTop();
        if (isGridMode) return;
        setState(() {
          params['page_index'] = 1;
          isGridMode = true;
        });
      },
    );
  }

  Widget _buildFilter2() {
    return ZYAssetImage(
      isGridMode ? 'ic_list.png' : 'ic_list_h.png',
      width: 12.5,
      height: 12.5,
      callback: () {
        scrollToTop();
        if (!isGridMode) return;
        setState(() {
          params['page_index'] = 1;
          isGridMode = false;
        });
      },
    );
  }

  bool showFloatingButton = true;
  closeEndDrawer() {
    if (_scaffoldKey.currentState.isEndDrawerOpen) {
      return Navigator.of(context).pop();
    }
    return;
  }

  bool showSortPanel = false;

  void sort() {
    setState(() {
      showSortPanel = !showSortPanel;
      menuController?.show(0);
      closeEndDrawer();
    });
  }

  Widget _buildFilter3() {
    return InkWell(
      onTap: sort,
      child: Row(
        children: <Widget>[
          Text(
            currentSortType['text'],
            style: TextStyle(fontSize: 13),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1, left: 5),
            child: ZYAssetImage(
              showSortPanel == false ? 'dropdown@2x.png' : 'dropup@2x.png',
              width: 12,
              height: 12,
              callback: sort,
            ),
          ),
        ],
      ),
    );
  }

  void filter() {
    setState(() {
      if (menuController?.isShow == true) {
        menuController?.hide();
      }
      ScaffoldState state = _scaffoldKey.currentState;
      if (!state.isEndDrawerOpen) {
        state.openEndDrawer();
        showFloatingButton = false;
      } else {
        closeEndDrawer();
        showFloatingButton = true;
      }
    });
  }

  Widget _buildFilter4() {
    return InkWell(
      onTap: filter,
      child: Container(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '筛选',
              style: TextStyle(fontSize: 13),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, top: 1),
              child: ZYAssetImage(
                'filter@2x.png',
                width: 12,
                height: 12,
                callback: filter,
              ),
            )
          ],
        ),
      ),
    );
  }

  void scrollToTop() {
    // if (goodsList == null || goodsList?.isEmpty == true) return;
    // scrollController?.animateTo(0,
    //     duration: Duration(milliseconds: 300), curve: Curves.bounceInOut);
  }

  void checkTag(
      TagFilter filter, List<TagFilterOption> options, TagFilterOption bean) {
    bean?.isChecked = !bean.isChecked;
    if (filter?.isMulti == false) {
      options?.forEach((item) {
        if (item != bean) {
          item?.isChecked = false;
        }
      });
    }
    setState(() {});
  }

  Widget endDrawer(BuildContext context) {
    List<TagFilter> filters = tagWrapper?.filterList ?? [];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 2 / 3,
      height: double.infinity,
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: height,
          padding: EdgeInsets.only(
              top: UIKit.height(10),
              bottom: UIKit.height(10),
              right: UIKit.width(24),
              left: UIKit.width(24)),
          child: AnimationLimiter(
              child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int i) {
              return SizedBox(
                height: 12,
              );
            },
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              TagFilter bean = filters[index];
              List<TagFilterOption> options = bean?.filterValue;

              return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text('${bean?.showName ?? ''}'),
                            ),
                            Container(
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 2.8,
                                          crossAxisCount: 3,
                                          crossAxisSpacing: UIKit.width(24),
                                          mainAxisSpacing: UIKit.height(24)),
                                  itemCount: options?.length ?? 0,
                                  itemBuilder: (BuildContext context, int i) {
                                    TagFilterOption item = options[i];
                                    return ZYActionChip(
                                        bean: ActionBean.fromJson({
                                          'text': item?.name ?? '',
                                          'is_checked': item?.isChecked
                                        }),
                                        callback: () {
                                          checkTag(bean, options, item);
                                        });
                                  }),
                            ),
                          ],
                        ),
                      )));
            },
            itemCount: filters?.length ?? 0,
          )),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
          padding: EdgeInsets.symmetric(vertical: UIKit.height(11)),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: InkWell(
                onTap: () {
                  tagWrapper?.reset();

                  setState(() {});
                  params?.addAll(tagWrapper?.args);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF979797))),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    '重置',
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {
                  params?.addAll(tagWrapper?.args);
                  params['page'] = 1;
                  params['category_type'] = tabIndex;
                  setState(() {
                    showFloatingButton = true;
                  });
                  fetchData();
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(width: 1, color: Colors.black),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    '确认',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void requestGoodsList() {
    OTPService.productGoodsList(context, params: params)
        .then((CurtainProductListResp response) {
      goodsListWrapper[tabIndex] = response?.data?.goodsList?.data ?? [];
    }).whenComplete(() {});
  }

  int cartCount = 0;
  void fetchData() {
    OTPService.mallData(context, params: params).then((data) {
      CurtainProductListResp curtainProductListResp = data[0];

      TagModelListResp tagListResp = data[1];
      CartCountResp cartCountResp = data[2];
      cartCount = cartCountResp?.data;
      beanData = curtainProductListResp?.data;

      tabController?.index = beanData?.categoryType;

      wrapper = beanData?.goodsList;
      goodsListWrapper[tabIndex] = wrapper?.data ?? [];
      tagWrapper = tagListResp?.data;
      int pages = (beanData?.totalCount ?? 0) ~/ PAGE_SIZE;
      int mod = (beanData?.totalCount ?? 0) % PAGE_SIZE;
      totalPage = mod > 0 ? pages + 1 : pages;
    }).catchError((err) {
      return err;
    }).whenComplete(() {
      print('刷新=================++++++++++++++++++');
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    menuController?.dispose();
    tabController?.dispose();
    _refreshController?.dispose();
    scrollController?.dispose();
  }

  GridView buildGridView() {
    return GridView.builder(
        // physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .8,
          crossAxisSpacing: 10,
        ),
        itemCount: goodsList == null || goodsList?.isEmpty == true
            ? 0
            : goodsList.length,
        itemBuilder: (BuildContext context, int i) {
          return AnimationConfiguration.staggeredGrid(
            columnCount: goodsList == null || goodsList?.isEmpty == true
                ? 0
                : (goodsList.length ~/ 2) + 1,
            position: i,
            duration: Duration(milliseconds: 600),
            child: SlideAnimation(
                verticalOffset: 200.0,
                child: FadeInAnimation(
                  child: GridCard(goodsList[i]),
                )),
          );
        });
  }

  ListView buildListView() {
    return ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:
            goodsList != null && goodsList.isNotEmpty ? goodsList?.length : 0,
        itemBuilder: (BuildContext context, int i) {
          return AnimationConfiguration.staggeredList(
            position: i,
            duration: Duration(milliseconds: 700),
            child: SlideAnimation(
                verticalOffset: 200.0,
                child: FadeInAnimation(
                  child: ListCard(goodsList[i]),
                )),
          );
        });
  }

  void clear() {
    TargetOrderGoods.instance.clear();
    TargetClient.instance.clear();
  }

  void sortData() {
    params['page_index'] = 1;
    params['order'] = currentSortType['order'];
    params['sort'] = currentSortType['sort'];
    menuController?.hide();
    scrollToTop();
  }

  bool get showCartButton => TargetClient.instance.hasSelectedClient;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    width = MediaQuery.of(context).size.width;

    return WillPopScope(
        child: Scaffold(
          floatingActionButton: AnimatedOpacity(
            opacity: showFloatingButton ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Offstage(
                  offstage: TargetClient.instance.hasSelectedClient == false,
                  child: FloatingActionButton(
                    heroTag: 'FloatingButtonCart',
                    onPressed: () {
                      RouteHandler.goCartPage(context,
                          clientId: TargetClient.instance.clientId);
                    },
                    backgroundColor: themeData.primaryColor,
                    child: Container(
                      width: UIKit.width(60),
                      height: UIKit.width(60),
                      alignment: Alignment(1.2, -1.5),
                      child: Container(
                        width: 16,
                        height: 16,
                        child: Text(
                          '$cartCount',
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(UIKit.getAssetsImagePath(
                                  'cart_button@2x.png')))),
                    ),
                  ),
                ),
                VSpacing(20),
                Visibility(
                  child: FloatingActionButton(
                    heroTag: 'FloatingButtonMeasureOrder',
                    onPressed: () {
                      RouteHandler.goMeasureOrderPage(context);
                    },
                    backgroundColor: themeData.primaryColor,
                    child: ZYAssetImage(
                      'create_measure_order@2x.png',
                      width: UIKit.width(60),
                      height: UIKit.width(60),
                      callback: () {
                        RouteHandler.goMeasureOrderPage(context);
                      },
                    ),
                  ),
                  visible: showFloatingButton,
                )
              ],
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            actions: <Widget>[ScanButton()],
            title: GestureDetector(
              onTap: () {
                RouteHandler.goSearchPage(context, 1);
              },
              child: Container(
                height: 30,
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                      child: Icon(
                        ZYIcon.search,
                        color: Color(0xFF9F9FA5),
                        size: 16,
                      ),
                    ),
                    isFromSearch
                        ? Text(
                            '搜索款号或关键词',
                            style: TextStyle(
                                color: Color(0xFF9F9FA5), fontSize: 14),
                          )
                        : Text(keyword)
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFEDEFF1),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
            bottom: PreferredSize(
                child: Column(
                  children: <Widget>[
                    TabBar(
                        tabs: tabs?.map((e) => Text(e))?.toList(),
                        controller: tabController,
                        indicatorColor: Colors.transparent,
                        labelColor: const Color(0xFF1B1B1B),
                        unselectedLabelColor: const Color(0xFF6D6D6D),
                        unselectedLabelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    GoodsFilterHeader(
                      filter1: _buildFilter1(),
                      filter2: _buildFilter2(),
                      filter3: _buildFilter3(),
                      filter4: _buildFilter4(),
                    )
                  ],
                ),
                preferredSize: Size.fromHeight(50)),
          ),
          body: Scaffold(
            key: _scaffoldKey,
            endDrawer: endDrawer(context),
            body: NotificationListener(
                onNotification: (ScrollNotification notofication) {
                  if (notofication.runtimeType == ScrollStartNotification) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      setState(() {
                        showFloatingButton = false;
                      });
                    });
                  }
                  if (notofication.runtimeType == ScrollEndNotification) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      setState(() {
                        showFloatingButton = true;
                      });
                    });
                  }
                  return true;
                },
                child: TabBarView(
                  children: List.generate(tabs?.length ?? 0, (int index) {
                    return GoodsTabBarView(
                      menuController: menuController,
                      sort: sortData,
                      isGridMode: isGridMode,
                      params: {
                        'category_type': index,
                        'page_size': PAGE_SIZE,
                        'keyword': keyword,
                        'page_index': 1,
                        'order': currentSortType['order'],
                        'sort': currentSortType['sort']
                      },
                    );
                  }),
                  controller: tabController,
                )),
          ),
        ),
        onWillPop: () {
          Navigator.of(context).pop();
          clear();
          return Future.value(false);
        });
  }
}

class GoodsTabBarView extends StatefulWidget {
  final Function sort;

  final GZXDropdownMenuController menuController;

  final bool isGridMode;

  final Map<String, dynamic> params;
  GoodsTabBarView(
      {Key key,
      this.sort,
      this.menuController,
      this.params,
      this.isGridMode = true})
      : super(key: key);

  @override
  _GoodsTabBarViewState createState() => _GoodsTabBarViewState();
}

class _GoodsTabBarViewState extends State<GoodsTabBarView>
    with AutomaticKeepAliveClientMixin {
  Function get sort => widget.sort;

  GZXDropdownMenuController get menuController => widget.menuController;
  Map<String, dynamic> get params => widget.params;
  bool get isGridMode => widget.isGridMode;
  bool get isFromSearch => widget.params['keyword']?.isNotEmpty ?? false;
  static List<Map<String, dynamic>> sortTypes = [
    {
      'text': '销量排序',
      'is_checked': true,
    },
    {
      'text': '新品优先',
      'is_checked': false,
    },
    {
      'text': '价格升序',
      'is_checked': false,
    },
    {
      'text': '价格降序',
      'is_checked': false,
    }
  ];
  bool isLoading = true;
  RefreshController _refreshController;
  ScrollController scrollController;
  List<GoodsItemBean> goodsList = [];
  @override
  void initState() {
    _refreshController = RefreshController(
        initialRefresh: false, initialLoadStatus: LoadStatus.idle);
    scrollController = ScrollController();

    requestGoodsData();
    // Future.delayed(Constants.TRANSITION_DURATION, () {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    scrollController?.dispose();
    super.dispose();
  }

  bool isRefresh = true;
  CurtainProductListDataBean beanData;
  CurtainGoodsListWrapper wrapper;
  int totalPage = 0;
  static const int PAGE_SIZE = 20;

  void refresh() {
    params['page_index'] = 1;
    isRefresh = true;
    requestGoodsData();
  }

  void load() {
    params['page_index']++;
    isRefresh = false;
    requestGoodsData();
  }

  void sortData() {
    sort();
    requestGoodsData();
    setState(() {});
  }

  requestGoodsData() {
    OTPService.productGoodsList(context, params: params)
        .then((CurtainProductListResp curtainProductListResp) {
      if (curtainProductListResp?.valid == true) {
        beanData = curtainProductListResp?.data;
        wrapper = beanData?.goodsList;

        List<GoodsItemBean> beans = wrapper?.data ?? [];
        int pages = (beanData?.totalCount ?? 0) ~/ PAGE_SIZE;
        int mod = (beanData?.totalCount ?? 0) % PAGE_SIZE;
        totalPage = mod > 0 ? pages + 1 : pages;

        if (isRefresh) {
          goodsList = wrapper?.data;
          return _refreshController?.refreshCompleted();
        } else {
          if (beans?.isEmpty == true) {
            return _refreshController?.loadNoData();
          } else {
            beans?.forEach((item) {
              if (goodsList?.contains(item) == false) {
                goodsList?.add(item);
              }
            });
            // setState(() {
            //   goodsList?.addAll(beans);
            // });
            return _refreshController?.loadComplete();
          }
        }
      }

      if (isRefresh) {
        return _refreshController?.refreshFailed();
      } else {
        return _refreshController?.loadFailed();
      }
    }).catchError((err) {
      print('出现异常');
      return err;
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  GridView buildGridView() {
    return GridView.builder(
        // physics: NeverScrollableScrollPhysics(),
        controller: scrollController,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .8,
          crossAxisSpacing: 10,
        ),
        itemCount: goodsList == null || goodsList?.isEmpty == true
            ? 0
            : goodsList.length,
        itemBuilder: (BuildContext context, int i) {
          return GridCard(goodsList[i]);
          // return AnimationConfiguration.staggeredGrid(
          //   columnCount: goodsList == null || goodsList?.isEmpty == true
          //       ? 0
          //       : (goodsList.length ~/ 2) + 1,
          //   position: i,
          //   duration: Duration(milliseconds: 600),
          //   child: SlideAnimation(
          //       verticalOffset: 200.0,
          //       child: FadeInAnimation(
          //         child: GridCard(goodsList[i]),
          //       )),
          // );
        });
  }

  ListView buildListView() {
    return ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        controller: scrollController,
        shrinkWrap: true,
        itemCount:
            goodsList != null && goodsList.isNotEmpty ? goodsList?.length : 0,
        itemBuilder: (BuildContext context, int i) {
          return AnimationConfiguration.staggeredList(
            position: i,
            duration: Duration(milliseconds: 700),
            child: SlideAnimation(
                verticalOffset: 200.0,
                child: FadeInAnimation(
                  child: ListCard(goodsList[i]),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
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
          ? Container(
              color: themeData.scaffoldBackgroundColor,
              child: LoadingCircle(),
            )
          : goodsList?.isNotEmpty != true
              ? Container(
                  color: themeData.scaffoldBackgroundColor,
                  child: NoData(
                    isFromSearch: isFromSearch,
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  // margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                  child: Stack(
                    children: <Widget>[
                      SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        primary: false,
                        onRefresh: refresh,
                        onLoading: load,
                        controller: _refreshController,
                        scrollController: scrollController,
                        child: isGridMode ? buildGridView() : buildListView(),
                      ),
                      GZXDropDownMenu(
                          controller: menuController,
                          animationMilliseconds: 400,
                          menus: [
                            GZXDropdownMenuBuilder(
                                dropDownHeight: 30.0 * sortTypes.length,
                                dropDownWidget: Column(
                                  children:
                                      List.generate(sortTypes.length, (int i) {
                                    Map<String, dynamic> bean = sortTypes[i];
                                    return Flexible(
                                        child: InkWell(
                                      onTap: () {
                                        if (bean['is_checked']) return;
                                        sortTypes.forEach((element) {
                                          element['is_checked'] =
                                              element == bean;
                                        });
                                        sort();
                                      },
                                      child: Container(
                                          height: 30,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 50),
                                            child: Text.rich(
                                              TextSpan(
                                                  text: bean['text'],
                                                  style: TextStyle(
                                                      color: bean['is_checked']
                                                          ? textTheme
                                                              .bodyText2.color
                                                          : Colors.grey),
                                                  children: [
                                                    WidgetSpan(
                                                        child: SizedBox(
                                                            width: 20)),
                                                    WidgetSpan(
                                                        child:
                                                            bean['is_checked']
                                                                ? Icon(
                                                                    ZYIcon
                                                                        .check,
                                                                    color: const Color(
                                                                        0xFF050505),
                                                                  )
                                                                : SizedBox(
                                                                    width: 24,
                                                                    height: 24,
                                                                  ))
                                                  ]),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                    ));
                                  }),
                                ))
                          ])
                    ],
                  ),
                ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
