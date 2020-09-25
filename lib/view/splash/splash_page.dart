import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 500), () {
        goPage();
      });
    });
  }

  void goPage() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    if (userProvider.isLogin) {
      userProvider.initUserInfo();
      RouteHandler.goHomePage(context);
    } else {
      RouteHandler.goLoginPage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Image.asset(
        UIKit.getAssetsImagePath('splash_img.png'),
        // width: size.width,
        // height: size.height,
        // scale: 1.0,
        // fit: BoxFit.fill,
      ),
    );
  }
}
