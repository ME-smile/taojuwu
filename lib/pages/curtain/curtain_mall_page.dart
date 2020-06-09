import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/shop/curtain_product_list_model.dart';
import 'package:taojuwu/models/shop/product_tag_model.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/no_data.dart';

import 'package:taojuwu/widgets/scan_button.dart';
import 'package:taojuwu/widgets/search_button.dart';
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
    with TickerProviderStateMixin {
  List tabs = [
    '成品定制',
  ];

  CurtainProductListDataBean beanData;
  CurtainGoodsListWrapper wrapper;
  List<CurtainGoodItemBean> goodsList = [];
  bool isRefresh = false;

  bool isLoading = true;
  int totalPage = 0;
  static const int PAGE_SIZE = 10;

  Map<String, dynamic> params = {
    // 'keyword': '',
    // 'stock': '',
    'order': 'sales',
    'sort': '',
    // 'brand_name': '',
    // 'min_price': '',
    // 'max_price': '',
    // 'province_id': '',
    // 'province_name': '',
    // 'attr': '',
    // 'spec': '',
    'page_size': PAGE_SIZE,
    'page_index': 1,
    'category_id': '',
    'tag_id': ''

    // 'shippingFee': 0,
    // 'type': 0
  };
  bool isFromSearch = false;
  @override
  void initState() {
    super.initState();

    tabController = TabController(length: tabs.length, vsync: this);

    params['keyword'] = widget.keyword;
    isFromSearch = widget.keyword.isNotEmpty;
    fetchData();
  }

  static const List<String> SORT_TYPES = ['销量排序', '新品优先', '价格升序', '价格降序'];

  static const List<Map<String, dynamic>> sortParams = [
    {
      'order': 'sales',
      'sort': 'desc',
    },
    {'order': 'is_new', 'sort': ''},
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
  bool get hasMoreData => params['page_index'] < totalPage;
  TagBeanWrapper tagWrapper;
  Widget _buildFilter1() {
    return ZYAssetImage(
      isGridMode ? 'ic_grid_h.png' : 'ic_grid.png',
      callback: () {
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
      callback: () {
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

  Widget _buildFilter3() {
    return InkWell(
      onTap: () {
        params['page_index'] = 1;
        setState(() {
          menuController?.show(0);
          closeEndDrawer();
        });
      },
      child: Text.rich(TextSpan(
          text: SORT_TYPES[currentSortType],
          children: [WidgetSpan(child: Icon(ZYIcon.drop_down))])),
    );
  }

  Widget _buildFilter4() {
    return InkWell(
      onTap: () {
        setState(() {
          if (menuController?.isShow == true) {
            menuController?.hide();
          }
          ScaffoldState state = _scaffoldKey.currentState;
          if (!state.isEndDrawerOpen) {
            state.openEndDrawer();
          } else {
            closeEndDrawer();
          }
          // hideFilterView = !hideFilterView;
        });
      },
      child: Text.rich(TextSpan(text: '筛选', children: [
        WidgetSpan(
            child: Icon(
          ZYIcon.filter,
        ))
      ])),
    );
  }

// type参数代表系列
  void checkTag(List<TagBean> tags, int type, int i) {
    isRefresh = true;
    TagBean bean = tags[i];
    params['page_index'] = 1;
    if (bean?.isChecked == true) {
      bean?.isChecked = false;

      if (type == 1) {
        params['category_id'] = '';
        Navigator.of(context).pop();
        return;
      }
      if (type == 2) {
        params['tag_id'] = '';
        Navigator.of(context).pop();
        return;
      }
    }
    for (int m = 0; m < tags?.length; m++) {
      TagBean tag = tags[m];
      if (i == m) {
        tag.isChecked = true;
        if (type == 1) {
          params['category_id'] = tag?.id;
        }
        if (type == 2) {
          params['tag_id'] = tag?.id;
        }
      }
      tag.isChecked = i == m ? true : false;
    }

    Navigator.of(context).pop();
  }

  Widget endDrawer(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Container(
      width: 200,
      color: Colors.white,
      height: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(15)),
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(color: themeData.accentColor, width: 5))),
            child: Text('品类'),
          ),
          ListBody(
            children: List.generate(tagWrapper?.category?.length ?? 0, (int i) {
              TagBean item = tagWrapper?.category[i];
              return InkWell(
                onTap: () {
                  setState(() {
                    checkTag(tagWrapper?.category, 1, i);
                    requestGoodsData();
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: UIKit.width(20), vertical: UIKit.height(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(item?.name ?? ''),
                      item?.isChecked == true
                          ? Icon(
                              ZYIcon.check,
                              color: const Color(0xFF050505),
                            )
                          : SizedBox(
                              width: 24,
                              height: 24,
                            )
                    ],
                  ),
                ),
              );
            }),
          ),
          Divider(),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(15)),
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(color: themeData.accentColor, width: 5))),
            child: Text('系列'),
          ),
          ListBody(
            children: List.generate(tagWrapper?.tag?.length ?? 0, (int i) {
              TagBean item = tagWrapper?.tag[i];
              return InkWell(
                onTap: () {
                  setState(() {
                    checkTag(tagWrapper?.tag, 2, i);

                    // params['tag_id'] = item?.id;

                    requestGoodsData();
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: UIKit.width(20), vertical: UIKit.height(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(item?.name),
                      item?.isChecked == true
                          ? Icon(
                              ZYIcon.check,
                              color: const Color(0xFF050505),
                            )
                          : SizedBox(
                              width: 24,
                              height: 24,
                            )
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void fetchData() {
    OTPService.mallData(context, params: params).then((data) {
      CurtainProductListResp curtainProductListResp = data[0];
      TagListResp tagListResp = data[1];

      if (mounted) {
        setState(() {
          beanData = curtainProductListResp?.data;
          wrapper = beanData?.goodsList;
          goodsList = wrapper?.data;
          tagWrapper = tagListResp?.data;
          isLoading = false;
          int pages = (beanData?.totalCount ?? 0) ~/ PAGE_SIZE;
          int mod = (beanData?.totalCount ?? 0) % PAGE_SIZE;
          totalPage = mod > 0 ? pages + 1 : pages;
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

  void requestGoodsData() {
    OTPService.curtainGoodsList(context, params: params)
        .then((CurtainProductListResp curtainProductListResp) {
      beanData = curtainProductListResp?.data;
      wrapper = beanData?.goodsList;
      if (isRefresh) {
        setState(() {
          goodsList = wrapper?.data;
        });
        _refreshController?.refreshCompleted();
      } else {
        setState(() {
          wrapper?.data?.forEach((item) {
            if (goodsList?.contains(item) == false) {
              goodsList.add(item);
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
  void dispose() {
    super.dispose();
    menuController?.dispose();
    tabController?.dispose();
    _refreshController?.dispose();
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
          return GridCard(goodsList[i]);
        });
  }

  ListView buildListView() {
    return ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:
            goodsList != null && goodsList.isNotEmpty ? goodsList?.length : 0,
        itemBuilder: (BuildContext context, int i) {
          return ListCard(goodsList[i]);
        });
  }

  void clear() {
    TargetOrderGoods.instance.clear();
    TargetClient.instance.clear();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: themeData.primaryColor,
            onPressed: () {
              RouteHandler.goMeasureOrderPage(context);
            },
            child: ZYAssetImage(
              'create_measure_order@2x.png',
              width: UIKit.width(60),
              height: UIKit.height(60),
              callback: () {
                RouteHandler.goMeasureOrderPage(context);
              },
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            actions: <Widget>[
              SearchButton(
                type: 1,
              ),
              ScanButton()
            ],
            title: Center(
              child: TabBar(
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  tabs: List.generate(tabs.length, (int i) {
                    return Text(tabs[i]);
                  })),
            ),
            bottom: PreferredSize(
                child: GoodsFilterHeader(
                  filter1: _buildFilter1(),
                  filter2: _buildFilter2(),
                  filter3: _buildFilter3(),
                  filter4: _buildFilter4(),
                ),
                preferredSize: Size.fromHeight(48)),
          ),
          body: Scaffold(
            key: _scaffoldKey,
            endDrawer: endDrawer(context),
            body: TabBarView(controller: tabController, children: [
              Container(
                alignment: Alignment.center,
                // margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                child: Stack(
                  children: <Widget>[
                    SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      onRefresh: () async {
                        params['page_index'] = 1;
                        isRefresh = true;
                        requestGoodsData();
                      },
                      onLoading: () async {
                        params['page_index']++;
                        if (hasMoreData == false) {
                          setState(() {
                            _refreshController?.loadNoData();
                          });
                          return;
                        }

                        isRefresh = false;
                        requestGoodsData();
                      },
                      controller: _refreshController,
                      child: isLoading
                          ? Center(
                              child: LoadingCircle(),
                            )
                          : goodsList?.isEmpty == true
                              ? NoData(
                                  isFromSearch: isFromSearch,
                                )
                              : isGridMode ? buildGridView() : buildListView(),
                    ),
                    GZXDropDownMenu(
                        controller: menuController,
                        animationMilliseconds: 400,
                        menus: [
                          GZXDropdownMenuBuilder(
                              dropDownHeight: 40.0 * SORT_TYPES.length,
                              dropDownWidget: Column(
                                children:
                                    List.generate(SORT_TYPES.length, (int i) {
                                  bool isCurrentOption = currentSortType == i;
                                  return Flexible(
                                      child: InkWell(
                                    onTap: () {
                                      if (isCurrentOption) return;
                                      setState(() {
                                        currentSortType = i;
                                        isRefresh = true;
                                        params['order'] =
                                            sortParams[i]['order'];
                                        params['sort'] = sortParams[i]['sort'];
                                        menuController?.hide();
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
                                                        ? textTheme.body1.color
                                                        : Colors.grey),
                                                children: [
                                                  WidgetSpan(
                                                      child:
                                                          SizedBox(width: 20)),
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
              )
            ]),
          ),
        ),
        onWillPop: () {
          Navigator.of(context).pop();
          clear();
          return Future.value(false);
        });
  }
}
