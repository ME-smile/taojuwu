/*
 * @Description: App程序入口
 * @Author: iamsmiling
 * @Date: 2020-10-31 13:34:34
 * @LastEditTime: 2020-11-26 17:52:27
 */
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
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
