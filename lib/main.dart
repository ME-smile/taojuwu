/*
 * @Description: App程序入口
 * @Author: iamsmiling
 * @Date: 2020-10-31 13:34:34
 * @LastEditTime: 2021-01-25 16:22:46
 */
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:fluwx/fluwx.dart';
// import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/providers/theme_provider.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/router/routes.dart';

import 'app.dart';
import 'application.dart';

void main() {
  return FlutterBugly.postCatchedException(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Router router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    await Application.init();
    await registerWxApi(
        appId: "wx1dda23b1cd57b8c2",
        universalLink: "https://ii1vy.share2dlink.com/");
    // 强制竖屏
    SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
        .then((_) {
      // Injector.configure(Flavor.PRO);

      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(),
          ),
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ],
        child: App(),
      ));
    });
  });
  // FlutterBugly.postCatchedException(() async {

  // });
}
