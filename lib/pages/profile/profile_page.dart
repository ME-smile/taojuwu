import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';
import 'package:taojuwu/widgets/zy_listTile.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // bool _hasMessagePush = true;

  String cacheSizeStr = '';
  @override
  void initState() {
    super.initState();
    getAppCacheSize();
  }

  getAppCacheSize() async {
    String sizeStr = await Application.loadCache();

    setState(() {
      cacheSizeStr = sizeStr;
    });
  }

  void clearCache() {
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                '清除缓存',
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('你确定要清除缓存吗？'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ZYOutlineButton('取消', () {
                        Navigator.of(context).pop();
                      }),
                      SizedBox(
                        width: 30,
                      ),
                      ZYRaisedButton('确定', () async {
                        Application.clearCache();
                        Navigator.of(context).pop();
                        cacheSizeStr = await getAppCacheSize();
                        setState(() {});
                      }),
                    ],
                  )
                ],
              ),
            );
          });
    } else {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('清除缓存'),
              content: Text('你确定要清除缓存吗？'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('确定'),
                  onPressed: () async {
                    Application.clearCache();
                    Navigator.of(context).pop();
                    cacheSizeStr = await getAppCacheSize();
                    setState(() {});
                  },
                ),
              ],
            );
          });
    }
  }

  void clearUserInfo() {
    Navigator.of(context).pop();
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    user.logOut();
    TargetClient.instance.clear();
    RouteHandler.goLoginPage(context, clearStack: true);
  }

  void logout() {
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                '退出提醒',
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('你确定要退出吗？'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ZYOutlineButton('取消', () {
                        Navigator.of(context).pop();
                      }),
                      SizedBox(
                        width: 30,
                      ),
                      ZYRaisedButton('确定', () {
                        clearUserInfo();
                      }),
                    ],
                  )
                ],
              ),
            );
          });
    } else {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('退出提醒'),
              content: Text('你确定要退出吗？'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('确定'),
                  onPressed: () {
                    clearUserInfo();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.brightness == Brightness.light
          ? const Color(0xFFF8F8F8)
          : Colors.white,
      appBar: AppBar(
        title: Text('设置'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProfileHeader(),
            VSpacing(20),
            // ZYListTile(
            //   title: '消息推送',
            //   trailing: CupertinoSwitch(
            //     activeColor: themeData.toggleableActiveColor,
            //     value: _hasMessagePush,
            //     onChanged: (v) {
            //       setState(() {
            //         _hasMessagePush = v;
            //       });
            //     },
            //   ),
            // ),
            // ZYListTile(
            //   title: '字体设置',
            // ),
            // ZYListTile(
            //   title: '清除缓存',
            // ),
            ZYListTile(
              title: '清除缓存',
              showDivider: true,
              trailing: Row(
                children: <Widget>[
                  Text(
                    cacheSizeStr ?? '0.00B',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Icon(ZYIcon.next),
                ],
              ),
              callback: () {
                clearCache();
              },
            ),
            ZYListTile(
              title: '重置密码',
              showDivider: false,
              callback: () {
                RouteHandler.goResetPwdPage(context);
              },
            ),
            VSpacing(20),
            // ZYListTile(
            //   title: '字体设置',
            // ),
            // ZYListTile(
            //   title: '推荐给好友',
            // ),
            ZYListTile(
              title: '问题反馈',
              callback: () {
                RouteHandler.goFeedbackPage(context);
              },
            ),
            ZYListTile(
              title: '关于淘居屋',
              showDivider: false,
              callback: () {
                RouteHandler.goVersionPage(context);
              },
            ),
            VSpacing(20),
            // _LoginButton(
            //   title: '切换账号',
            //   callback: () {
            //     RouteHandler.goSwitchAccountPage(context);
            //   },
            // ),
            VSpacing(20),
            _LoginButton(
              title: '退出登录',
              callback: () {
                logout();
                // RouteHandler.goSwitchAccountPage(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
            child: ZYAssetImage(
              'default_avatar@2x.png',
              width: UIKit.width(100),
              height: UIKit.width(100),
            ),
          ),
          Consumer<UserProvider>(
            builder: (BuildContext context, UserProvider provider, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text.rich(TextSpan(
                      text: provider?.userInfo?.nickName ?? '',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(text: '  '),
                        TextSpan(
                            text: provider?.userInfo?.userTel ?? "暂无联系方式",
                            style: textTheme.bodyText2)
                      ])),
                  Text(
                    provider?.userInfo?.shopName ?? '',
                    style: textTheme.caption,
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String title;
  final Function callback;
  const _LoginButton({Key key, this.title, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback ?? () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: UIKit.height(30)),
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(title ?? ''),
        color: Colors.white,
      ),
    );
  }
}
