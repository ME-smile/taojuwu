/*
 * @Description: 选品商品列表页
 * @Author: iamsmiling
 * @Date: 2020-11-20 11:05:07
 * @LastEditTime: 2020-12-31 17:35:01
 */

import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/cart_list_model.dart';
import 'package:taojuwu/repository/shop/curtain_product_list_model.dart';
import 'package:taojuwu/repository/shop/tag_model.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/view/goods/curtain/widgets/curtain_grid_view.dart';
import 'package:taojuwu/view/goods/curtain/widgets/curtain_list_view.dart';
import 'package:taojuwu/view/goods/curtain/widgets/goods_filter_header.dart';
import 'package:taojuwu/view/goods/events/filter_event.dart';
import 'package:taojuwu/widgets/animated_dropdown_drawer.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/network_error.dart';
import 'package:taojuwu/widgets/no_data.dart';
import 'package:taojuwu/widgets/scan_button.dart';
import 'package:taojuwu/widgets/triangle_clipper.dart';

import 'package:taojuwu/widgets/zy_assetImage.dart';
import 'package:taojuwu/widgets/zy_dropdown_route.dart';

class SelectProductMallPage extends StatefulWidget {
  final String keyword;
  final OrderGoodsMeasureData measureData;
  SelectProductMallPage(this.measureData, {Key key, this.keyword})
      : super(key: key);

  @override
  _SelectProductMallPageState createState() => _SelectProductMallPageState();
}

class _SelectProductMallPageState extends State<SelectProductMallPage>
    with RouteAware {
  int get orderGoodsId => widget.measureData?.orderGoodsId;
  String get height => widget.measureData?.height;
  String get keyword => widget.keyword;
  bool get isFromSearch => keyword?.isNotEmpty ?? false;
  static const int PAGE_SIZE = 20;
  bool isLoading = true;
  bool hasError = false;
  bool isGridMode = true;
  RefreshController _refreshController;
  List<GoodsItemBean> goodsList = [];
  ScrollController scrollController;
  TagFilterWrapper tagWrapper;
  CurtainProductListDataBean beanData;
  CurtainGoodsListWrapper wrapper;
  int cartCount = 0;
  int totalPage = 0;
  bool showSortPanel = false;
  ValueNotifier<bool> showFloatingButtonNotifier;
  StreamSubscription filterSubscription;
  Map<String, dynamic> extraArgs = {};
  bool isRefresh = true;
  int pageIndex = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> params = {
    'order': 'sales',
    'sort': 'desc',
    'page_size': PAGE_SIZE,
    'page_index': 1,
  };
  GlobalKey<_SelectProductMallPageState> appBarKey =
      GlobalKey<_SelectProductMallPageState>(); //设置globalkey 获取appbar的高度和位置信息

  static List<Map<String, dynamic>> sortTypes = [
    {
      'text': '默认排序',
      'is_checked': true,
      'order': '',
      'sort': '',
    },
    {
      'text': '销量排序',
      'is_checked': false,
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

  @override
  void initState() {
    fetchData();
    scrollController = ScrollController();
    showFloatingButtonNotifier = ValueNotifier<bool>(false);
    _refreshController = RefreshController(
        initialRefresh: false, initialLoadStatus: LoadStatus.idle);
    filterSubscription = Application.eventBus.on<FilterEvent>().listen((event) {
      extraArgs = event?.args;
      params?.addAll(event?.args);

      setState(() {
        isLoading = true;
      });
      refresh();
      // goodsList?.clear();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Application.routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    scrollController?.dispose();
    showFloatingButtonNotifier?.dispose();
    Application.routeObserver.unsubscribe(this);
    filterSubscription?.cancel();
    super.dispose();
  }

  void checkTag(
      TagFilter filter, List<TagFilterOption> options, TagFilterOption bean) {
    // ToastKit.showLoading();
    bean?.isChecked = !bean.isChecked;
    if (filter?.isMulti == false) {
      options?.forEach((item) {
        if (item != bean) {
          item?.isChecked = false;
        }
      });
    }

    if (bean?.shouldRefresh == true) {
      fetchTag({
        'category_type': 0,
        bean?.key: [bean?.id]
      }, callback: () {
        // ToastKit.dismiss();
      }, bean: bean);
    }
    setState(() {});
  }

  void fetchTag(Map<String, dynamic> params,
      {Function callback, TagFilterOption bean}) {
    print(params);
    OTPService.tagList(context, params: params)
        .then((TagModelListResp response) {
          tagWrapper = response?.data;

          if (bean != null) {
            tagWrapper?.filterList?.forEach((element) {
              if (element?.filterName == bean?.key) {
                element?.filterValue?.forEach((e) {
                  e?.isChecked = e.id == bean?.id;
                });
              }
            });
          }
        })
        .catchError((err) => err)
        .whenComplete(() {
          if (callback != null) callback();
          setState(() {});
        });
  }

  void fetchData() {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    OTPService.mallData(context, params: {
      'order_goods_id': orderGoodsId,
      'height': height,
      'keyword': keyword
    }).then((data) {
      CurtainProductListResp curtainProductListResp = data[0];
      TagModelListResp tagListResp = data[1];
      CartCountResp cartCountResp = data[2];
      cartCount = cartCountResp?.data ?? 0;
      beanData = curtainProductListResp?.data;

      wrapper = beanData?.goodsList;
      goodsList = wrapper?.data ?? [];
      tagWrapper = tagListResp?.data;
      int pages = (beanData?.totalCount ?? 0) ~/ PAGE_SIZE;
      int mod = (beanData?.totalCount ?? 0) % PAGE_SIZE;
      totalPage = mod > 0 ? pages + 1 : pages;
    }).catchError((err) {
      hasError = true;
      return err;
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  void filterData() {
    Map<String, dynamic> args = {};
    args.addAll(tagWrapper?.args);
    args['page_index'] = 1;
    args['category_type'] = 0;
    args['height'] = height;
    Application.eventBus.fire(
      FilterEvent(args, tab: 0, shouldRefresh: true),
    );
    showFloatingButtonNotifier.value = true;
    Navigator.of(context).pop();
  }

  void refresh() {
    isRefresh = true;
    pageIndex = 1;
    // params['page_index'] = 1;

    requestGoodsData();
  }

  Widget endDrawer(BuildContext context) {
    List<TagFilter> filters = tagWrapper?.filterList ?? [];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Drawer(
      child: Container(
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
                                      return GestureDetector(
                                        onTap: () {
                                          checkTag(bean, options, item);
                                        },
                                        child: Container(
                                          height: 28,
                                          child: AspectRatio(
                                            aspectRatio: 3,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: Text(
                                                    '${item?.name}',
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: item?.isChecked ==
                                                                true
                                                            ? Colors.black
                                                            : Color(
                                                                0xFF333333)),
                                                  ),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  2)),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: item?.isChecked ==
                                                                  true
                                                              ? Colors.black
                                                              : Color(
                                                                  0xFF979797))),
                                                ),
                                                Positioned(
                                                  child: item?.isChecked == true
                                                      ? TriAngle()
                                                      : Container(),
                                                  bottom: 0,
                                                  right: 0,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
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
                  onTap: filterData,
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
      ),
    );
  }

  void load() {
    isRefresh = false;
    pageIndex++;
    params.addAll(extraArgs);
    // params['page_index']++;

    requestGoodsData();
  }

  requestGoodsData() {
    params?.addAll({
      'page_index': pageIndex,
      'height': height,
      'keyword': keyword,
      'order_goods_id': orderGoodsId,
    });
    params.addAll(extraArgs);
    hasError = false;
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
          // return _refreshController?.refreshCompleted();
        } else {
          beans?.forEach((item) {
            if (goodsList?.contains(item) == false) {
              goodsList?.add(item);
            }
          });
        }

        // return _refreshController?.loadComplete();

        // if (beans.length < PAGE_SIZE) {
        //   _refreshController?.loadNoData();
        // } else {
        //   beans?.forEach((item) {
        //     goodsList?.add(item);
        //   });
        //   // setState(() {
        //   //   goodsList?.addAll(beans);
        //   // });

        // }_re

      }
    }).catchError((err) {
      hasError = true;
      if (isRefresh) {
        return _refreshController?.refreshFailed();
      } else {
        return _refreshController?.loadFailed();
      }
    }).whenComplete(() {
      if (mounted) {
        if (isRefresh) {
          // 清空筛选条案
          // params['filter_condition'] = '';

          _refreshController?.refreshCompleted();
        } else {
          if (totalPage >= pageIndex) {
            _refreshController?.loadComplete();
          } else {
            _refreshController?.resetNoData();
            _refreshController?.loadNoData();
          }
        }
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void didPopNext() {
    OTPService.cartCount(context, params: {
      'client_uid': TargetClient().clientId,
    })
        .then((CartCountResp cartCountResp) {
          cartCount = cartCountResp?.data;
        })
        .catchError((err) => err)
        .whenComplete(() {
          if (mounted) {
            setState(() {});
          }
        });
  }

  GridView buildGridView() {
    return GridView.builder(
        // physics: NeverScrollableScrollPhysics(),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        controller: scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .75,
          crossAxisSpacing: 10,
        ),
        itemCount: goodsList == null || goodsList?.isEmpty == true
            ? 0
            : goodsList.length,
        itemBuilder: (BuildContext context, int i) {
          return GridCard(
            goodsList[i],
            isMeasureOrderGoods: true,
          );
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
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        controller: scrollController,
        shrinkWrap: true,
        itemCount: (goodsList != null) && goodsList?.isNotEmpty == true
            ? goodsList?.length
            : 0,
        itemBuilder: (BuildContext context, int i) {
          return AnimationConfiguration.staggeredList(
            position: i,
            duration: Duration(milliseconds: 200),
            child: SlideAnimation(
                verticalOffset: 200.0,
                child: FadeInAnimation(
                  child: ListCard(
                    goodsList[i],
                    isMeasureOrderGooods: true,
                  ),
                )),
          );
        });
  }

  Widget _buildFilter1() {
    return ZYAssetImage(
      isGridMode ? 'ic_grid_h.png' : 'ic_grid.png',
      width: 16,
      height: 16,
      callback: () {
        // scrollToTop();
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
      width: 16,
      height: 16,
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

  void sort(BuildContext ctx) {
    setState(() {
      showSortPanel = !showSortPanel;
    });
    closeEndDrawer();
    RenderBox renderBox = ctx.findRenderObject();
    Rect box = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    if (showSortPanel) {
      Navigator.of(context)
          .push(PopDownRoute(
        buildSortMenu(),
        offsetY: box.bottom + UIKit.height(15),
        drawerKey: drawerKey,
      ))
          .whenComplete(() {
        setState(() {
          showSortPanel = false;
        });
      });
    } else {
      closeSortPanel();
    }
    // if (hasNotPush) {

    // } else {
    //   print(showSortPanel);
    //   print('-----¥关闭弹窗');
    //   hasNotPush = true;
    //   closeSortPanel();
    // }
    //
    // Navigator.of(context).push(ZYDropdownRoute(
    //     position: box, drawerKey: drawerKey, child: buildSortMenu()));

    // closeEndDrawer();
    // setState(() {
    //   showSortPanel = !showSortPanel;
    // });
    // if (showSortPanel) {
    // } else {}

    // setState(() {
    //   showSortPanel = !showSortPanel;
    //   menuController?.show(0);
    //   closeEndDrawer();
    // });
  }

  void closeSortPanel() {
    if (!showSortPanel && drawerKey?.currentState?.mounted == true) {
      drawerKey?.currentState?.close();
      Navigator.of(context).pop();
      setState(() {
        showSortPanel = false;
      });
    }
  }

  void sortData() {
    params['page_index'] = 1;
    params['order'] = currentSortType['order'];
    params['sort'] = currentSortType['order'];
    Application.eventBus.fire(FilterEvent({
      'page_index': 1,
      'order': currentSortType['order'],
      'sort': currentSortType['sort']
    }, tab: 1, shouldRefresh: true));
    closeSortPanel();
  }

  GlobalKey<AniamatedDropdownDrawerState> drawerKey =
      GlobalKey<AniamatedDropdownDrawerState>();
  Widget buildSortMenu() {
    Size size = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (BuildContext context, Function setState) {
      return Container(
          height: 180,
          color: Colors.white,
          child: Column(
              children: sortTypes
                  ?.map((bean) => Builder(builder: (BuildContext ctx) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            // if (bean['is_checked']) return;
                            sortTypes.forEach((element) {
                              element['is_checked'] = element == bean;
                            });
                            Navigator.of(context).pop();
                            //弹出蒙版
                            sortData();
                            await drawerKey.currentState
                                .close()
                                .whenComplete(() {});
                            // closeSortPanel();
                          },
                          child: Container(
                            width: size.width,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(bean['text']),
                                SizedBox(
                                  width: 20,
                                ),
                                Opacity(
                                  child: Icon(
                                    ZYIcon.check,
                                    color: const Color(0xFF050505),
                                  ),
                                  opacity: bean['is_checked'] ? 1.0 : 0,
                                )
                              ],
                            ),
                          ),
                        );
                      }))
                  ?.toList()));
    });
  }

  Widget _buildFilter3() {
    return Builder(
      builder: (BuildContext ctx) {
        return GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: () {
            sort(ctx);
          },
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                Text(
                  currentSortType['text'],
                  style: TextStyle(fontSize: 13),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1, left: 5),
                  child: ZYAssetImage(
                    showSortPanel == false
                        ? 'dropdown@2x.png'
                        : 'dropup@2x.png',
                    width: 12,
                    height: 12,
                    callback: () {
                      sort(ctx);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void filter() {
    // closeSortPanel();
    if (drawerKey?.currentState?.mounted == true) {
      // closeSortPanel();
      drawerKey.currentState.close();
      Navigator.of(context).pop();
    }

    ScaffoldState state = _scaffoldKey.currentState;
    if (!state.isEndDrawerOpen) {
      state.openEndDrawer();
      showFloatingButtonNotifier.value = false;
    } else {
      closeEndDrawer();
      showFloatingButtonNotifier.value = true;
    }
  }

  Widget _buildFilter4() {
    return GestureDetector(
      onTap: filter,
      behavior: HitTestBehavior.translucent,
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

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
        // floatingActionButton: ValueListenableBuilder(
        //   valueListenable: showFloatingButtonNotifier,
        //   builder: (BuildContext context, bool flag, _) {
        //     return AnimatedOpacity(
        //       opacity: flag ? 1.0 : 0.0,
        //       duration: Duration(milliseconds: 500),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: <Widget>[
        //           Offstage(
        //             offstage: TargetClient().hasSelectedClient == false,
        //             child: FloatingActionButton(
        //               heroTag: 'FloatingButtonCart',
        //               onPressed: () {
        //                 RouteHandler.goCartPage(context,
        //                     clientId: TargetClient().clientId);
        //               },
        //               backgroundColor: themeData.primaryColor,
        //               child: Container(
        //                 width: UIKit.width(60),
        //                 height: UIKit.width(60),
        //                 alignment: Alignment(1.4, -1.5),
        //                 child: Visibility(
        //                   child: Container(
        //                     width: 18,
        //                     height: 18,
        //                     alignment: Alignment.center,
        //                     child: Text(
        //                       '$cartCount',
        //                       style: TextStyle(
        //                           fontSize: cartCount > 10 ? 10 : 12,
        //                           fontFamily: 'Roboto'),
        //                     ),
        //                     decoration: BoxDecoration(
        //                         color: Colors.red,
        //                         borderRadius:
        //                             BorderRadius.all(Radius.circular(9))),
        //                   ),
        //                   visible: cartCount != 0,
        //                 ),
        //                 decoration: BoxDecoration(
        //                     image: DecorationImage(
        //                         image: AssetImage(UIKit.getAssetsImagePath(
        //                             'cart_button.png')))),
        //               ),
        //             ),
        //           ),
        //           VSpacing(20),
        //           Visibility(
        //             child: FloatingActionButton(
        //               heroTag: 'FloatingButtonMeasureOrder',
        //               onPressed: () {
        //                 RouteHandler.goMeasureOrderPage(context);
        //               },
        //               backgroundColor: themeData.primaryColor,
        //               child: ZYAssetImage(
        //                 'create_measure_order@2x.png',
        //                 width: UIKit.width(60),
        //                 height: UIKit.width(60),
        //                 callback: () {
        //                   RouteHandler.goMeasureOrderPage(context);
        //                 },
        //               ),
        //             ),
        //             visible: flag,
        //           )
        //         ],
        //       ),
        //     );
        //   },
        // ),
        appBar: AppBar(
          key: appBarKey,
          centerTitle: true,
          actions: <Widget>[ScanButton()],
          title: GestureDetector(
            onTap: () {
              if (isFromSearch) {
                Navigator.of(context).pop();
              } else {
                RouteHandler.goSearchPage(context, 1);
              }
            },
            child: Container(
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
                  isFromSearch
                      ? Text(
                          keyword,
                          style:
                              TextStyle(color: Color(0xFF333333), fontSize: 14),
                        )
                      : Text(
                          '搜索款号或关键词',
                          style:
                              TextStyle(color: Color(0xFF9F9FA5), fontSize: 14),
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
              child: GoodsFilterHeader(
                filter1: _buildFilter1(),
                filter2: _buildFilter2(),
                filter3: _buildFilter3(),
                filter4: _buildFilter4(),
              ),
              preferredSize: Size.fromHeight(32)),
        ),
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
              ? Container(
                  color: themeData.scaffoldBackgroundColor,
                  child: LoadingCircle(),
                )
              : hasError
                  ? Container(
                      color: themeData.scaffoldBackgroundColor,
                      height: double.maxFinite,
                      child: NetworkErrorWidget(callback: requestGoodsData))
                  : goodsList?.isNotEmpty != true
                      ? Scaffold(
                          body: Container(
                            color: themeData.scaffoldBackgroundColor,
                            child: NoData(
                              isFromSearch: isFromSearch,
                            ),
                          ),
                        )
                      : NotificationListener(
                          onNotification: (ScrollNotification notofication) {
                            if (notofication.depth == 0) {
                              return false;
                            }
                            if (notofication.runtimeType ==
                                ScrollStartNotification) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                showFloatingButtonNotifier.value = false;
                              });
                            }
                            if (notofication.runtimeType ==
                                ScrollEndNotification) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                showFloatingButtonNotifier.value = true;
                              });
                            }
                            return true;
                          },
                          child: Scaffold(
                            key: _scaffoldKey,
                            endDrawer: endDrawer(context),
                            body: Container(
                              alignment: Alignment.center,
                              // margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                              child: SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                primary: false,
                                onRefresh: refresh,
                                onLoading: load,
                                controller: _refreshController,
                                scrollController: scrollController,
                                child: isGridMode
                                    ? buildGridView()
                                    : buildListView(),
                              ),
                            ),
                          ),
                        ),
        ));
  }
}
