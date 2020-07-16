import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:fluro/fluro.dart';
import 'package:taojuwu/icon/ZYIcon.dart';

import 'package:taojuwu/providers/theme_provider.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/router/routes.dart';

import 'app.dart';
import 'application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Router router = Router();
  Routes.configureRoutes(router);
  Application.router = router;
  EasyLoading.instance
    ..successWidget = Icon(
      ZYIcon.check,
      color: Colors.white,
      size: 36,
    );
  EasyLoading.instance
    ..errorWidget = Icon(
      ZYIcon.close,
      color: Colors.white,
      size: 40,
    );
  EasyLoading.instance
    ..infoWidget = Icon(
      ZYIcon.exclamation_point,
      color: Colors.white,
      size: 30,
    );
  await Application.init();
  // 强制竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
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
}
