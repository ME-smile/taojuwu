import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:taojuwu/pages/splash/splash_page.dart';
import 'package:taojuwu/providers/theme_provider.dart';
// import 'package:taojuwu/utils/translations.dart';

import 'application.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (BuildContext context, ThemeProvider provider, _) {
      return RefreshConfiguration(
          headerBuilder: () => WaterDropHeader(
                refresh: Text('正在刷新'),
                complete: Text('刷新成功'),
                failed: Text('刷新失败'),
              ), // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
          footerBuilder: () => ClassicFooter(
                loadingText: '正在加载',
                noDataText: '我也是有底线的哦',
                failedText: '加载失败',
                canLoadingText: '下拉加载更多',
                idleText: '加载更多数据',
                idleIcon: Text(''),
              ), // Configure default bottom indicator
          headerTriggerDistance:
              80.0, // header trigger refresh trigger distance
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
              false, // Disable pull-up to load more functionality when Viewport is less than one screen
          enableBallisticLoad: true,
          child: FlutterEasyLoading(
              child: MaterialApp(
            title: '淘居屋',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: Application.router.generator,
            darkTheme:
                provider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            theme: ThemeProvider.lightTheme,
            home: SplashPage(),
            // localizationsDelegates: [
            //   const TranslationsDelegate(),
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            // ],
          )));
    });
  }
}
