import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:taojuwu/models/shop/collect_list_model.dart';
import 'package:taojuwu/models/shop/product_bean.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/pages/curtain/curtain_detail_page.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/no_data.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class CollectPage extends StatefulWidget {
  final int id;
  final String name;
  CollectPage({Key key, this.id, this.name}) : super(key: key);

  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  final List<String> tabs = ['窗帘'];
  CollectListWrapper wrapper;
  List<ProductBean> beanList;
  // ValueNotifier<List<ProductBean>> beans;
  int get count => beanList?.length ?? 0;
  @override
  void initState() {
    super.initState();
    OTPService.collectList(context, params: {'client_uid': widget.id})
        .then((CollectListResp response) {
      setState(() {
        isLoading = false;
        wrapper = response?.data;
        beanList = wrapper?.data;
      });
    }).catchError((err) => err);
    tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
  }

  bool isLoading = true;

  cancelCollect(BuildContext context, ProductBean bean) {
    OTPService.cancelCollect(params: {
      'fav_id': bean?.goodsId ?? -1,
      'client_uid': widget.id ?? -1,
      'fav_type': 'goods'
    }).then((ZYResponse response) {
      Navigator.of(context).pop();
      if (response?.valid == true) {
        setState(() {
          beanList?.remove(bean);
        });
      }
    }).catchError((err) => err);
  }

  void remove(BuildContext ctx, ProductBean bean) {
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                '删除',
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('您确定要从收藏夹中删除该商品吗'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ZYOutlineButton('取消', () {
                        Navigator.of(context).pop();
                      }),
                      SizedBox(
                        width: 30,
                      ),
                      ZYRaisedButton('确定', () {
                        cancelCollect(context, bean);
                      }),
                    ],
                  )
                ],
              ),
            );
          });
    } else {
      showCupertinoDialog(
          context: ctx,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('删除'),
              content: Text('您确定要从收藏夹中删除该商品吗?'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('确定'),
                  onPressed: () {
                    cancelCollect(context, bean);
                  },
                ),
              ],
            );
          });
    }
  }

  Widget buildOpenContainer(ProductBean bean, int index) {
    return GestureDetector(
      onLongPress: () {
        remove(context, bean);
      },
      child: OpenContainer(
        closedBuilder: (BuildContext context, VoidCallback _) {
          TargetClient.instance.saveInfo(widget.id, widget?.name);
          return CurtainDetailPage(bean?.goodsId);
        },
        openBuilder: (BuildContext context, VoidCallback _) {
          return buildCollectCard(context, bean, index);
        },
      ),
    );
  }

  Widget buildCollectCard(BuildContext context, ProductBean bean, int index) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return GestureDetector(
      onLongPress: () {
        remove(context, bean);
      },
      child: InkWell(
        onTap: () {
          RouteHandler.goCurtainDetailPage(context, bean?.goodsId ?? -1);
        },
        child: Container(
          child: Row(
            children: <Widget>[
              ZYNetImage(
                imgPath: bean?.picCoverMicro,
                isCache: false,
                height: UIKit.height(180),
                callback: () {
                  RouteHandler.goCurtainDetailPage(
                      context, bean?.goodsId ?? -1);
                },
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                height: UIKit.height(180),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      bean?.goodsName ?? '',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      bean?.categoryName ?? '',
                      style: textTheme.caption.copyWith(fontSize: UIKit.sp(28)),
                    ),
                    Text('￥${bean?.price ?? ''}')
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingCircle()
        : Scaffold(
            appBar: AppBar(
              title: Text('收藏夹'),
              centerTitle: true,
              bottom: PreferredSize(
                  child: TabBar(
                      controller: tabController,
                      labelPadding:
                          EdgeInsets.only(bottom: 5, left: 5, right: 5),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: List.generate(tabs.length, (int i) {
                        return Text('${tabs[i]}($count)');
                      })),
                  preferredSize: Size.fromHeight(20)),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: UIKit.width(20), vertical: UIKit.height(20)),
                child: beanList == null || beanList?.isNotEmpty != true
                    ? NoData()
                    : ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return AnimationConfiguration.staggeredList(
                              position: i,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: buildCollectCard(
                                        context, beanList[i], i),
                                  )));
                          // return buildCollectCard(context, beanList[i], i);
                        },
                        separatorBuilder: (BuildContext context, int i) {
                          return Divider();
                        },
                        itemCount: beanList?.length ?? 0)),
          );
  }
}
