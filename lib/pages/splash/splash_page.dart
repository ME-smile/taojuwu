import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/providers/client_provider.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/router/handlers.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _logoController;
  Tween _scaleTween;
  CurvedAnimation _logoAnimation;

  @override
  void initState() {
    super.initState();
    ClientProvider clientProvider = Provider.of<ClientProvider>(context,listen: false);
    clientProvider?.initClientInfo();
    _scaleTween = Tween(begin: 0, end: 1);
    _logoController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..drive(_scaleTween);
    Future.delayed(Duration(milliseconds: 500), () {
      _logoController.forward();
    });
    _logoAnimation =
        CurvedAnimation(parent: _logoController, curve: Curves.easeOutQuart);
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 500), () {
          goPage();
        });
      }
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
  void dispose() {
    super.dispose();
    _logoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: ScaleTransition(
          scale: _logoAnimation,
          child: Hero(
            tag: 'logo',
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }
}
