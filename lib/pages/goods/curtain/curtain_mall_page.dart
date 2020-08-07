// import 'package:animations/animations.dart';

import 'dart:async';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
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
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List get tabs => ['窗帘', '配件', '抱枕', '床品', '沙发'];

  CurtainProductListDataBean beanData;
  CurtainGoodsListWrapper wrapper;
  ScrollController scrollController;
  GZXDropdownMenuController menuController;
  List<GoodsItemBean> goodsList = [];

  int totalPage = 0;

  bool isLoading = true;
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

  //定时器 用于判断是否停止滚动

  bool get isFromSearch => widget.keyword.isNotEmpty ?? false;
  @override
  void initState() {
    super.initState();
    TargetRoute.instance.context = context;
    tabController = TabController(length: tabs.length, vsync: this);

    params['keyword'] = widget.keyword;
    params['category_type'] = tabIndex;
    menuController = GZXDropdownMenuController();
    scrollController = ScrollController();
    Future.delayed(Constants.TRANSITION_DURATION, () {
      fetchData();
    });
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
  RefreshController _refreshController = RefreshController(
      initialRefresh: false, initialLoadStatus: LoadStatus.idle);

  TabController tabController;
  Animation<Offset> animation;
  bool isGridMode = true;
  double width;
  int get tabIndex => tabController?.index ?? 0;
  bool get hasMoreData => params['page_index'] < totalPage;
  TagFilterWrapper tagWrapper;
  bool showFloatingButton = true;
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
    if (goodsList == null || goodsList.isEmpty) return;
    scrollController?.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.bounceInOut);
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

  void fetchData() {
    OTPService.mallData(context, params: params).then((data) {
      CurtainProductListResp curtainProductListResp = data[0];
      TagModelListResp tagListResp = data[1];
      beanData = curtainProductListResp?.data;
      wrapper = beanData?.goodsList;
      goodsList = wrapper?.data;
      tagWrapper = tagListResp?.data;
      int pages = (beanData?.totalCount ?? 0) ~/ PAGE_SIZE;
      int mod = (beanData?.totalCount ?? 0) % PAGE_SIZE;
      totalPage = mod > 0 ? pages + 1 : pages;
    }).catchError((err) {
      return err;
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
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
    super.build(context);
    ThemeData themeData = Theme.of(context);

    width = MediaQuery.of(context).size.width;
    return WillPopScope(
        child: Scaffold(
          floatingActionButton: AnimatedOpacity(
            opacity: showFloatingButton ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: 'FloatingButtonCart',
                  onPressed: () {
                    RouteHandler.goMeasureOrderPage(context);
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
                        '3',
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
                VSpacing(20),
                FloatingActionButton(
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
                    Text(
                      '搜索款号或关键词',
                      style: TextStyle(color: Color(0xFF9F9FA5), fontSize: 14),
                    )
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
              body: PageTransitionSwitcher(
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
                    : TabBarView(
                        children: List.generate(tabs?.length ?? 0, (int index) {
                          return GoodsTabBarView(
                            menuController: menuController,
                            sort: sortData,
                            isGridMode: isGridMode,
                            goodsList: index == 0 ? goodsList : null,
                            requestData: index != 0,
                            params: {
                              'category_type': index,
                              'page_size': PAGE_SIZE,
                              'page_index': 1,
                              'order': currentSortType['order'],
                              'sort': currentSortType['sort']
                            },
                          );
                        }),
                        controller: tabController,
                      ),
              )),
        ),
        onWillPop: () {
          Navigator.of(context).pop();
          clear();
          return Future.value(false);
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class GoodsTabBarView extends StatefulWidget {
  final List<GoodsItemBean> goodsList;

  final Function sort;

  final GZXDropdownMenuController menuController;
  final bool requestData;
  final bool isGridMode;
  final bool isFromSearch;
  final Map<String, dynamic> params;
  GoodsTabBarView(
      {Key key,
      this.goodsList = const [],
      this.sort,
      this.menuController,
      this.params,
      this.isFromSearch = false,
      this.requestData = true,
      this.isGridMode = true})
      : super(key: key);

  @override
  _GoodsTabBarViewState createState() => _GoodsTabBarViewState();
}

class _GoodsTabBarViewState extends State<GoodsTabBarView> {
  List<GoodsItemBean> get goodsList => widget.goodsList;
  set goodsList(List<GoodsItemBean> list) {
    goodsList = list;
  }

  Function get sort => widget.sort;
  GZXDropdownMenuController get menuController => widget.menuController;
  Map<String, dynamic> get params => widget.params;
  bool get isGridMode => widget.isGridMode;
  bool get requestData => widget.requestData;
  bool get isFromSearch => widget.isFromSearch;
  static const List<Map<String, dynamic>> SORT_TYPES = [
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
  double offsetY = 0.0;
  double lastOffsetY = 0.0;

  RefreshController _refreshController;
  ScrollController scrollController;
  @override
  void initState() {
    _refreshController = RefreshController(
        initialRefresh: false, initialLoadStatus: LoadStatus.idle);
    scrollController = ScrollController();

    if (requestData) {
      requestGoodsData();
    }
    super.initState();
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    scrollController?.dispose();
    super.dispose();
  }

  bool isLoading = false;
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
    setState(() {
      sort();
      requestGoodsData();
    });
  }

  Future requestGoodsData() async {
    if (isRefresh)
      setState(() {
        isLoading = true;
      });
    OTPService.productGoodsList(context, params: params)
        .then((CurtainProductListResp curtainProductListResp) {
      _refreshController?.resetNoData();
      beanData = curtainProductListResp?.data;
      wrapper = beanData?.goodsList;

      goodsList = wrapper?.data;
      List<GoodsItemBean> beans = wrapper?.data ?? [];
      int pages = (beanData?.totalCount ?? 0) ~/ PAGE_SIZE;
      int mod = (beanData?.totalCount ?? 0) % PAGE_SIZE;
      totalPage = mod > 0 ? pages + 1 : pages;

      if (isRefresh) {
        setState(() {
          goodsList = wrapper?.data;
        });
        _refreshController?.refreshCompleted();
      } else {
        if (beans?.isEmpty == true) {
          _refreshController?.loadNoData();
        } else {
          setState(() {
            beans?.forEach((item) {
              if (goodsList?.contains(item) == false) {
                goodsList.add(item);
              }
            });
            _refreshController?.loadComplete();
          });
        }
      }
    }).catchError((err) {
      if (isRefresh) {
        _refreshController?.refreshFailed();
      } else {
        _refreshController?.loadFailed();
      }
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
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
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return isLoading
        ? Container(
            color: themeData.scaffoldBackgroundColor,
            child: LoadingCircle(),
          )
        : goodsList?.isNotEmpty != true
            ? Container(
                color: themeData.scaffoldBackgroundColor,
                child: NoData(),
              )
            : Container(
                alignment: Alignment.center,
                // margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                child: Stack(
                  children: <Widget>[
                    NotificationListener<ScrollNotification>(
                        onNotification:
                            (ScrollNotification scrollNotification) {
                          switch (scrollNotification.runtimeType) {
                            case ScrollStartNotification:
                              print("开始滚动");
                              break;
                            case ScrollUpdateNotification:
                              print("正在滚动");
                              break;
                            case ScrollEndNotification:
                              print("滚动停止");
                              break;
                            case OverscrollNotification:
                              print("滚动到边界");
                              break;
                          }
                          if (offsetY == scrollNotification?.metrics?.pixels) {
                            //停止滚动
                            // showFloatingButton = true;
                          } else {
                            //滚动
                            // showFloatingButton = false;
                          }
                          offsetY = scrollNotification?.metrics?.pixels;
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            setState(() {});
                          });
                          return true;
                        },
                        child: SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          primary: false,
                          onRefresh: refresh,
                          onLoading: load,
                          controller: _refreshController,
                          scrollController: scrollController,
                          child: isGridMode ? buildGridView() : buildListView(),
                        )),
                    GZXDropDownMenu(
                        controller: menuController,
                        animationMilliseconds: 400,
                        menus: [
                          GZXDropdownMenuBuilder(
                              dropDownHeight: 30.0 * SORT_TYPES.length,
                              dropDownWidget: Column(
                                children:
                                    List.generate(SORT_TYPES.length, (int i) {
                                  Map<String, dynamic> bean = SORT_TYPES[i];
                                  return Flexible(
                                      child: InkWell(
                                    onTap: () {
                                      if (bean['is_checked']) return;
                                      SORT_TYPES.forEach((element) {
                                        element['is_checked'] = element == bean;
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
                                                      child:
                                                          SizedBox(width: 20)),
                                                  WidgetSpan(
                                                      child: bean['is_checked']
                                                          ? Icon(
                                                              ZYIcon.check,
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
              );
  }
}
