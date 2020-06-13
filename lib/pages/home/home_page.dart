import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List items;
  Timer timer;
  StreamController _streamController;

  @override
  void initState() {
    super.initState();

    items = [
      {
        'title': '套餐搭配',
        'subtitle': '一起买，价格更优惠',
        'icon': 'combo@2x.png',
        'callback': () {
          CommonKit.showInfo('暂未开放');
        },
        'color': const Color(0xFFC9BCA9),
      },
      {
        'title': '预约测量',
        'subtitle': '上门测量，更准确',
        'icon': 'measure@2x.png',
        'callback': () {
          RouteHandler.goMeasureOrderPage(context);
        },
        'color': const Color(0xFFC9BCA9),
      },
      {
        'title': '订单管理',
        'subtitle': '订单进度一目了然',
        'icon': 'order@2x.png',
        'callback': () {
          RouteHandler.goOrderPage(
            context,
          );
        },
        'color': const Color(0xFF192538)
      },
      {
        'title': '客户管理',
        'subtitle': '把握客户，把握机会',
        'icon': 'customer_manage@2x.png',
        'callback': () {
          RouteHandler.goCustomerPage(
            context,
          );
        },
        'color': const Color(0xffDDE0E1)
      },
      {
        'title': '数据中心',
        'subtitle': '销售统计，清晰明了',
        'icon': 'data@2x.png',
        'callback': () {
          CommonKit.showInfo('暂未开放');
          // RouteHandler.goDataCenterPage(context);
        },
        'color': const Color(0xff0D0B14)
      },
      {
        'title': '设置',
        'subtitle': '问题反馈，软件帮助',
        'icon': 'setting@2x.png',
        'callback': () {
          RouteHandler.goProfilePage(context);
        },
        'color': const Color(0xffE4B1AB)
      },
    ];

    _streamController = StreamController();
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _streamController.add(DateTime.now());
    });
  }

  @override
  void dispose() {
    _streamController?.close();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    ThemeData themeData = Theme.of(context);
    TextTheme accentTextTheme = themeData.accentTextTheme;
    TextTheme textTheme = themeData.textTheme;

    return Container(
      color: themeData.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
            margin: EdgeInsets.only(bottom: UIKit.height(50)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Consumer<UserProvider>(
                  builder: (BuildContext context, UserProvider provider, _) {
                    return StreamBuilder(
                        initialData: DateTime.now(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text.rich(
                              TextSpan(
                                  text:
                                      '${UIKit.getGreetWord(snapshot.data) ?? ""},${provider?.userInfo?.nickName ?? ""}',
                                  style: textTheme.headline6,
                                  children: [
                                    TextSpan(text: '\n'),
                                    TextSpan(
                                        text: provider?.userInfo?.shopName,
                                        style: textTheme.subtitle2)
                                  ]),
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                              textWidthBasis: TextWidthBasis.longestLine,
                            ),
                          );
                        });
                  },
                ),
                VSpacing(20),
                InkWell(
                  onTap: () {
                    RouteHandler.goCurtainMallPage(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: UIKit.height(500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '窗帘定制',
                          style: accentTextTheme.headline6,
                        ),
                        Text(
                          'curtain',
                          style: accentTextTheme.subtitle2,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(UIKit.getAssetsImagePath(
                                'home_top_cover_origin.png')))),
                  ),
                ),
                VSpacing(20),
                GridView.builder(
                  shrinkWrap: true,
                  // controller: controller,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1.2),
                  itemBuilder: (BuildContext context, int i) {
                    var item = items[i];
                    return InkWell(
                        onTap: item['callback'],
                        child: Card(
                            child: Container(
                          alignment: Alignment.center,
                          color: Color(0xFFF3F4F5),
                          padding:
                              EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: UIKit.width(20)),
                                child: Image.asset(
                                  UIKit.getAssetsImagePath(item['icon']),
                                  width: UIKit.width(60),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      item['title'],
                                      style: textTheme.headline6.copyWith(
                                          fontSize: UIKit.sp(28),
                                          fontWeight: FontWeight.w400),
                                    ),
                                    VSpacing(10),
                                    Text(
                                      item['subtitle'],
                                      style: textTheme.subtitle2
                                          .copyWith(fontSize: UIKit.sp(22)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )));
                  },
                  itemCount: items.length,
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
