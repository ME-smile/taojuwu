import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluro/fluro.dart' as fluro;
import 'package:taojuwu/config/app_config.dart';
import 'package:taojuwu/providers/theme_provider.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/router/routes.dart';

import 'app.dart';
import 'application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print(AppConfig.isPro);
  fluro.Router router = fluro.Router();
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
      ],
      child: App(),
    ));
  });
}
