// import 'package:animations/animations.dart';

import 'dart:async';
import 'dart:ui';
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
    with SingleTickerProviderStateMixin {
  List get tabs => ['窗帘', '配件', '抱枕', '床品', '沙发'];
  List<List<GoodsItemBean>> goodsListWrapper = List.filled(5, []);
  CurtainProductListDataBean beanData;
  CurtainGoodsListWrapper wrapper;
  ScrollController scrollController;

  List<GoodsItemBean> goodsList = [];
  bool isRefresh = false;

  bool isLoading = true;
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

  //定时器 用于判断是否停止滚动

  double offsetY = 0;

  bool isFromSearch = false;
  double lastOffsetY = 0.0;

  @override
  void initState() {
    super.initState();
    TargetRoute.instance.context = context;
    tabController = TabController(length: tabs.length, vsync: this)
      ..addListener(() {
        params['category_type'] = tabIndex;
        fetchData();
      });

    params['keyword'] = widget.keyword;
    params['category_type'] = tabs[tabIndex];
    isFromSearch = widget.keyword.isNotEmpty;
    scrollController = ScrollController();
    Future.delayed(Constants.TRANSITION_DURATION, () {
      fetchData();
    });
  }

  static const List<String> SORT_TYPES = ['销量排序', '新品优先', '价格升序', '价格降序'];

  static const List<Map<String, dynamic>> sortParams = [
    {
      'order': 'sales',
      'sort': 'desc',
    },
    {'order': 'is_new', 'sort': 'desc'},
    {
      'order': 'price',
      'sort': 'asc',
    },
    {
      'order': 'price',
      'sort': 'desc',
    },
  ];
  GZXDropdownMenuController menuController = GZXDropdownMenuController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  RefreshController _refreshController = RefreshController(
      initialRefresh: false, initialLoadStatus: LoadStatus.idle);
  int currentSortType = 0;

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
            SORT_TYPES[currentSortType],
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
    // return InkWell(
    //   onTap: () {
    //     setState(() {
    //       menuController?.show(0);
    //       closeEndDrawer();
    //     });
    //   },
    //   child: Text.rich(TextSpan(text: SORT_TYPES[currentSortType], children: [
    //     WidgetSpan(
    //       child: Icon(
    //         ZYIcon.drop_down,
    //         size: 16,
    //       ),
    //     )
    //   ])),
    // );
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
      // hideFilterView = !hideFilterView;
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
      // child: Text.rich(TextSpan(text: '筛选', children: [
      //   WidgetSpan(
      //       child: ZYAssetImage(
      //     'filter@2x.png',
      //     width: 12,
      //   ))
      // ])),
    );
  }

  void scrollToTop() {
    scrollController?.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.bounceInOut);
  }

// // type参数代表系列
//   void checkTag(List<TagBean> tags, int type, int i) {
//     isRefresh = true;
//     TagBean bean = tags[i];
//     params['page_index'] = 1;

//     if (bean?.isChecked == true) {
//       bean?.isChecked = false;

//       if (type == 1) {
//         params['category_id'] = '';
//         Navigator.of(context).pop();
//         return;
//       }
//       if (type == 2) {
//         params['tag_id'] = '';
//         Navigator.of(context).pop();
//         return;
//       }
//     }
//     for (int m = 0; m < tags?.length; m++) {
//       TagBean tag = tags[m];
//       if (i == m) {
//         tag.isChecked = true;
//         if (type == 1) {
//           params['category_id'] = tag?.id;
//         }
//         if (type == 2) {
//           params['tag_id'] = tag?.id;
//         }
//       }
//       tag.isChecked = i == m ? true : false;
//     }

//     Navigator.of(context).pop();
//     scrollToTop();
//   }

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
    // ThemeData themeData = Theme.of(context);

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
                                    // return TagBeanActionChip(
                                    //   bean: options[i],
                                    // callback: () {
                                    //   checkTag(bean, options, item);
                                    // }
                                    // );
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
                  isRefresh = true;

                  requestGoodsData().whenComplete(() {
                    Navigator.of(context).pop();
                  });
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
    print(params);
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
      List<GoodsItemBean> beans = wrapper?.data ?? [];
      int pages = (beanData?.totalCount ?? 0) ~/ PAGE_SIZE;
      int mod = (beanData?.totalCount ?? 0) % PAGE_SIZE;
      totalPage = mod > 0 ? pages + 1 : pages;
      isLoading = false;

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
      isLoading = false;
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
        itemCount:
            goodsList != null && goodsList.isNotEmpty ? goodsList.length : 0,
        itemBuilder: (BuildContext context, int i) {
          return AnimationConfiguration.staggeredGrid(
            columnCount: goodsList == null ? 0 : (goodsList.length ~/ 2) + 1,
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

  @override
  void deactivate() {
    super.deactivate();
  }

  bool get showCartButton => TargetClient.instance.hasSelectedClient;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
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
            title: Container(
              height: 30,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
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
              // child: ClipRRect(
              //   borderRadius: BorderRadius.all(Radius.circular(5)),
              //   child: TextField(
              //     onTap: () {
              //       setState(() {
              //         showFloatingButton = false;
              //       });

              //     },

              //     // enableInteractiveSelection: false,
              //     // textAlignVertical: TextAlignVertical(y: .5),
              //     decoration: InputDecoration(
              //       // fillColor: Colors.grey,
              //       filled: true,
              //       fillColor: Color(0xFFEDEFF1),
              //       prefixIcon: Container(
              //         width: 18,
              //         height: 18,
              //         child: Icon(
              //           ZYIcon.search,
              //           size: 18,
              //           color: const Color(
              //             0xFF979797,
              //           ),
              //         ),
              //       ),
              //       contentPadding: EdgeInsets.only(top: 10, bottom: 10),
              //     ),
              //   ),
              // ),
            ),
            bottom: PreferredSize(
                child: Column(
                  children: <Widget>[
                    TabBar(
                      tabs: tabs?.map((e) => Text(e))?.toList(),
                      controller: tabController,
                      indicatorColor: Colors.transparent,
                    ),
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
            body: TabBarView(
                controller: tabController,
                children: List.generate(tabs?.length, (int index) {
                  return Container(
                    alignment: Alignment.center,
                    // margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                    child: Stack(
                      children: <Widget>[
                        isLoading
                            ? Center(
                                child: LoadingCircle(),
                              )
                            : goodsList?.isEmpty == true
                                ? NoData(
                                    isFromSearch: isFromSearch,
                                  )
                                : NotificationListener<ScrollNotification>(
                                    onNotification: (ScrollNotification
                                        scrollNotification) {
                                      if (offsetY ==
                                          scrollNotification?.metrics?.pixels) {
                                        //停止滚动

                                        showFloatingButton = true;
                                      } else {
                                        //滚动
                                        showFloatingButton = false;
                                      }
                                      // if (timer == null) {
                                      //   timer = Timer.periodic(Duration(seconds: 1),
                                      //       (timer) {
                                      //     if (offsetY ==
                                      //         scrollNotification?.metrics?.pixels) {
                                      //       timer?.cancel();

                                      //       timer = null;
                                      //       if (isAnimationRunningForwardsOrComplete) {
                                      //         animationController?.reverse();
                                      //       } else {
                                      //         animationController?.forward();
                                      //       }
                                      //       print('停止滚动');
                                      //     }
                                      //   });
                                      // }
                                      offsetY =
                                          scrollNotification?.metrics?.pixels;
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((timeStamp) {
                                        setState(() {});
                                      });
                                      return true;
                                    },
                                    child: AnimationLimiter(
                                      child: SmartRefresher(
                                        enablePullDown: true,
                                        enablePullUp: true,
                                        primary: false,
                                        onRefresh: () async {
                                          params['page_index'] = 1;
                                          isRefresh = true;
                                          requestGoodsData();
                                        },
                                        onLoading: () async {
                                          params['page_index']++;

                                          isRefresh = false;
                                          requestGoodsData();
                                        },
                                        controller: _refreshController,
                                        scrollController: scrollController,
                                        child: isGridMode
                                            ? buildGridView()
                                            : buildListView(),
                                      ),
                                    )),
                        GZXDropDownMenu(
                            controller: menuController,
                            animationMilliseconds: 400,
                            menus: [
                              GZXDropdownMenuBuilder(
                                  dropDownHeight: 30.0 * SORT_TYPES.length,
                                  dropDownWidget: Column(
                                    children: List.generate(SORT_TYPES.length,
                                        (int i) {
                                      bool isCurrentOption =
                                          currentSortType == i;
                                      return Flexible(
                                          child: InkWell(
                                        onTap: () {
                                          if (isCurrentOption) return;
                                          setState(() {
                                            currentSortType = i;
                                            params['page_index'] = 1;
                                            isRefresh = true;
                                            params['order'] =
                                                sortParams[i]['order'];
                                            params['sort'] =
                                                sortParams[i]['sort'];
                                            menuController?.hide();
                                            scrollToTop();
                                            requestGoodsData();
                                          });
                                        },
                                        child: Container(
                                            height: 30,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 50),
                                              child: Text.rich(
                                                TextSpan(
                                                    text: SORT_TYPES[i],
                                                    style: TextStyle(
                                                        color: isCurrentOption
                                                            ? textTheme
                                                                .bodyText2.color
                                                            : Colors.grey),
                                                    children: [
                                                      WidgetSpan(
                                                          child: SizedBox(
                                                              width: 20)),
                                                      WidgetSpan(
                                                          child: isCurrentOption
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
                })),
          ),
        ),
        onWillPop: () {
          Navigator.of(context).pop();
          clear();
          return Future.value(false);
        });
  }
}

class TagBeanActionChip extends StatefulWidget {
  final TagFilterOption bean;
  final Function callback;
  TagBeanActionChip({Key key, this.bean, this.callback}) : super(key: key);

  @override
  _TagBeanActionChipState createState() => _TagBeanActionChipState();
}

class _TagBeanActionChipState extends State<TagBeanActionChip> {
  TagFilterOption get bean => widget.bean;
  bool get isChecked => bean?.isChecked;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.callback,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.black,
            // borderRadius: BorderRadius.all(Radius.circular(2)),
            border: Border.all(
                width: .5,
                color: isChecked == true ? Colors.black : Color(0xFFCBCBCB))),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(isChecked ? 7.2 : 0))),
          child: Text(
            bean?.name ?? '',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12,
                color: isChecked == true ? Colors.black : Color(0xFF333333)),
          ),
        ),
      ),
    );
  }
}
