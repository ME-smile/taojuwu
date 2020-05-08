import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/shop/curtain_product_list_model.dart';
import 'package:taojuwu/models/shop/product_tag_model.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/no_data.dart';

import 'package:taojuwu/widgets/scan_button.dart';
import 'package:taojuwu/widgets/search_button.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';
import 'widgets/curtain_list_view.dart';
import 'widgets/goods_filter_header.dart';
import 'widgets/curtain_grid_view.dart';

class CurtainMallPage extends StatefulWidget {
  final String keyword;
  CurtainMallPage({Key key, this.keyword: ''}) : super(key: key);

  @override
  _CurtainMallPageState createState() => _CurtainMallPageState();
}

class _CurtainMallPageState extends State<CurtainMallPage>
    with TickerProviderStateMixin {
  List tabs = [
    '成品定制',
  ];

  CurtainProductListDataBean data;
  CurtainGoodsListWrapper wrapper;
  List<CurtainGoodItemBean> goodsList = [];
  bool isRefresh = false;
  int currentCategory = -1;
  int currentStyle = -1;
  bool isLoading = true;
  Map<String, dynamic> params = {
    // 'keyword': '',
    // 'stock': '',
    'order': '',
    'sort': '',
    // 'brand_name': '',
    // 'min_price': '',
    // 'max_price': '',
    // 'province_id': '',
    // 'province_name': '',
    // 'attr': '',
    // 'spec': '',
    // 'page_size': 10,
    'page_index': 1,
    'category_id': '',
    // 'shippingFee': 0,
    // 'type': 0
  };

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    tabController = TabController(length: tabs.length, vsync: this);

    params['keyword'] = widget.keyword;
    fetchData();
  }

  static const List<String> SORT_TYPES = ['推荐排序', '新品优先', '价格升序', '价格降序'];

  static const List<Map<String, dynamic>> sortParams = [
    {
      'order': 'sales',
      'sort': '',
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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int currentSortType = 0;
  bool hideFilterView = true;
  AnimationController animationController;
  TabController tabController;
  Animation<Offset> animation;
  bool isGridMode = true;
  double width;

  TagBeanWrapper tagWrapper;
  Widget _buildFilter1() {
    return ZYAssetImage(
      isGridMode ? 'ic_grid_h.png' : 'ic_grid.png',
      callback: () {
        if (isGridMode) return;
        setState(() {
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
          isGridMode = false;
        });
      },
    );
  }

  Widget _buildFilter3() {
    return InkWell(
      onTap: () {
        setState(() {
          menuController?.show(0);
          hideFilterView = true;
        });
      },
      child: Text.rich(TextSpan(
          text: SORT_TYPES[currentSortType],
          children: [WidgetSpan(child: ZYIcon.drop_down)])),
    );
  }

  Widget _buildFilter4() {
    return InkWell(
      onTap: () {
        setState(() {
          if (menuController?.isShow == true) {
            menuController?.hide();
          }
          hideFilterView = !hideFilterView;
        });
      },
      child: Text.rich(
          TextSpan(text: '筛选', children: [WidgetSpan(child: ZYIcon.filter)])),
    );
  }

  void fetchData() {
    OTPService.mallData(context, params: params).then((data) {
      CurtainProductListResp curtainProductListResp = data[0];
      TagListResp tagListResp = data[1];

      setState(() {
        data = curtainProductListResp.data;
        wrapper = data.goodsList;
        goodsList = wrapper.data;
        tagWrapper = tagListResp.data;
        isLoading = false;
      });
    }).catchError((err) => err);
  }

  void requestGoodsData() {
    OTPService.curtainGoodsList(context, params: params)
        .then((CurtainProductListResp curtainProductListResp) {
      data = curtainProductListResp?.data;
      wrapper = data?.goodsList;
      if (isRefresh) {
        setState(() {
          goodsList = wrapper?.data;
        });
        _refreshController?.refreshCompleted();
      } else {
        _refreshController?.loadComplete();
        setState(() {
          goodsList.addAll(wrapper?.data);
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

  @override
  void dispose() {
    super.dispose();
    animationController?.dispose();
    menuController?.dispose();
    tabController?.dispose();
    _refreshController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RouteHandler.goMeasureOrderPage(context);
        },
        child: Icon(Icons.edit),
      ),
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          SearchButton(
            type: 1,
          ),
          ScanButton()
        ],
        title: TabBar(
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            tabs: List.generate(tabs.length, (int i) {
              return Text(tabs[i]);
            })),
        bottom: PreferredSize(
            child: GoodsFilterHeader(
              filter1: _buildFilter1(),
              filter2: _buildFilter2(),
              filter3: _buildFilter3(),
              filter4: _buildFilter4(),
            ),
            preferredSize: Size.fromHeight(48)),
      ),
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
                  isRefresh = false;
                  requestGoodsData();
                },
                controller: _refreshController,
                child: isLoading
                    ? Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : goodsList?.isEmpty == true
                        ? NoData()
                        : Container(
                            margin: EdgeInsets.only(bottom: 50),
                            child: isGridMode
                                ? GoodsGridView(
                                    goodsList,
                                  )
                                : GoodsListView(
                                    goodsList,
                                  ),
                          ),
              ),
              Offstage(
                offstage: tabController.index == 0 && hideFilterView,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      hideFilterView = !hideFilterView;
                    });
                  },
                  child: Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width,
                      color: Color.fromARGB(100, 0, 0, 0),
                      child: Container(
                        width: 200,
                        color: Colors.white,
                        height: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: UIKit.width(20),
                            vertical: UIKit.height(20)),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIKit.width(15)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: themeData.accentColor,
                                          width: 5))),
                              child: Text('品类'),
                            ),
                            ListBody(
                              children: List.generate(
                                  tagWrapper?.category?.length ?? 0, (int i) {
                                TagBean item = tagWrapper?.category[i];
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentCategory = i;
                                      isRefresh = true;
                                      params['category_id'] = item?.id;
                                      hideFilterView = true;
                                      requestGoodsData();
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: UIKit.width(20),
                                        vertical: UIKit.height(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(item.name),
                                        currentCategory == i
                                            ? ZYIcon.check
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIKit.width(15)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: themeData.accentColor,
                                          width: 5))),
                              child: Text('系列'),
                            ),
                            ListBody(
                              children: List.generate(
                                  tagWrapper?.tag?.length ?? 0, (int i) {
                                TagBean item = tagWrapper?.tag[i];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: UIKit.width(20),
                                      vertical: UIKit.height(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(item.name),
                                      currentStyle == i
                                          ? ZYIcon.check
                                          : SizedBox(
                                              width: 24,
                                              height: 24,
                                            )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
              GZXDropDownMenu(
                  controller: menuController,
                  animationMilliseconds: 400,
                  menus: [
                    GZXDropdownMenuBuilder(
                        dropDownHeight: 40.0 * SORT_TYPES.length,
                        dropDownWidget: Column(
                          children: List.generate(SORT_TYPES.length, (int i) {
                            bool isCurrentOption = currentSortType == i;
                            return Flexible(
                                child: InkWell(
                              onTap: () {
                                if (isCurrentOption) return;
                                setState(() {
                                  currentSortType = i;
                                  isRefresh = true;
                                  params['order'] = sortParams[i]['order'];
                                  params['sort'] = sortParams[i]['sort'];
                                  menuController?.hide();
                                  requestGoodsData();
                                });
                              },
                              child: Container(
                                  height: 30,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    child: Text.rich(
                                      TextSpan(
                                          text: SORT_TYPES[i],
                                          style: TextStyle(
                                              color: isCurrentOption
                                                  ? textTheme.body1.color
                                                  : Colors.grey),
                                          children: [
                                            WidgetSpan(
                                                child: SizedBox(width: 20)),
                                            WidgetSpan(
                                                child: isCurrentOption
                                                    ? ZYIcon.check
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
    );
  }
}
