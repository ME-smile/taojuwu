import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluro/fluro.dart';
import 'package:taojuwu/providers/client_provider.dart';
import 'package:taojuwu/providers/goods_provider.dart';

import 'package:taojuwu/providers/theme_provider.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/router/routes.dart';

import 'app.dart';
import 'application.dart';
// import 'package:taojuwu/myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Router router = Router();
  Routes.configureRoutes(router);
  Application.router = router;
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
        ChangeNotifierProvider<ClientProvider>(
          create: (_) => ClientProvider(),
        ),
        ChangeNotifierProvider<GoodsProvider>(
          create: (_) => GoodsProvider(),
        )
      ],
      child: App(),
    ));
  });
}
