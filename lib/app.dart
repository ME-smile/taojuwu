/*
 * @Description: 应用根节点
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-09-25 17:57:56
 */
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:taojuwu/event_bus/events/login_event.dart';
import 'package:taojuwu/view/home/home_page.dart';
import 'package:taojuwu/view/login/login_page.dart';

import 'package:taojuwu/providers/theme_provider.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/utils/toast_kit.dart';

import 'application.dart';
import 'services/base/xhr.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  StreamSubscription mSubscription;

  /*
   * @Author: iamsmiling
   * @description:监听登录登出事件
   * @param : 
   * @return {type} 
   * @Date: 2020-09-25 14:32:00
   */
  @override
  void initState() {
    super.initState();
    ImageCache imageCache = PaintingBinding.instance.imageCache;
    imageCache.maximumSize = 8;
    imageCache.maximumSizeBytes = 50 << 20;
    mSubscription = Application.eventBus.on<LoginEvent>().listen((event) {
      if (event.code == 1) {
        Xhr.refreshToken();
      } else {
        Xhr.clearToken();
        Application.clearSpCache();
      }
    });
  }

  @override
  void dispose() {
    mSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Application.context = context;
    return Consumer2<ThemeProvider, UserProvider>(builder:
        (BuildContext context, ThemeProvider provider,
            UserProvider userProvider, _) {
      if (userProvider?.isLogin == true) {
        userProvider?.initUserInfo();
      }
      return RefreshConfiguration(
        headerBuilder: () => WaterDropHeader(
          refresh: Text(
            '正在刷新',
            style: TextStyle(color: Colors.grey),
          ),
          complete: Text('刷新成功', style: TextStyle(color: Colors.grey)),
          failed: Text('刷新失败', style: TextStyle(color: Colors.grey)),
        ), // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
        footerBuilder: () => ClassicFooter(
          loadingText: '正在加载',
          noDataText: '我也是有底线的哦',
          failedText: '加载失败',
          canLoadingText: '上拉加载更多',
          idleText: '上拉加载更多',
          // noMoreIcon: SizedBox(
          //   width: 30,
          //   height: 30,
          //   child: FlareActor(
          //     'sad_emoji.flr',
          //     animation: 'no_more_data',
          //   ),
          // ),
          height: 50,
          loadingIcon: SizedBox(
            width: 25,
            height: 25,
            child: CupertinoActivityIndicator(),
          ),
        ), // Configure default bottom indicator
        headerTriggerDistance: 80.0, // header trigger refresh trigger distance
        springDescription: SpringDescription(
            stiffness: 170,
            damping: 16,
            mass:
                1.9), // custom spring back animate,the props meaning see the flutter api
        maxOverScrollExtent:
            100, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
        maxUnderScrollExtent: 0, // Maximum dragging range at the bottom
        enableScrollWhenRefreshCompleted:
            true, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
        enableLoadingWhenFailed:
            true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
        hideFooterWhenNotFull:
            true, // Disable pull-up to load more functionality when Viewport is less than one screen
        enableBallisticLoad: true,
        child: MaterialApp(
            title: Application.appName,
            // initialRoute: userProvider?.isLogin == true ? Routes.home : null,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: Application.router.generator,
            darkTheme: ThemeProvider.lightTheme,
            theme: ThemeProvider.lightTheme,
            navigatorObservers: [Application.routeObserver],
            home: userProvider?.isLogin == true ? HomePage() : LoginPage(),
            builder: (BuildContext context, Widget child) {
              ToastKit.initEasyLoading();
              return Material(
                child: FlutterEasyLoading(
                  child: child,
                ),
              );
            },
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('zh', 'CN'),
              const Locale('en', 'US'),
            ]),
      );
    });
  }
}
