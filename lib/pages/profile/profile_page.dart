import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/providers/user_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';
import 'package:taojuwu/widgets/zy_listTile.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _hasMessagePush = true;
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
            ZYListTile(
              title: '消息推送',
              trailing: CupertinoSwitch(
                activeColor: themeData.toggleableActiveColor,
                value: _hasMessagePush,
                onChanged: (v) {
                  setState(() {
                    _hasMessagePush = v;
                  });
                },
              ),
            ),
            ZYListTile(
              title: '字体设置',
            ),
            ZYListTile(
              title: '清除缓存',
            ),
            ZYListTile(
              title: '密码管理',
              showDivider: false,
            ),
            VSpacing(20),
            ZYListTile(
              title: '字体设置',
            ),
            ZYListTile(
              title: '推荐给好友',
            ),
            ZYListTile(
              title: '问题反馈',
              callback: () {
                RouteHandler.goFeedbackPage(context);
              },
            ),
            ZYListTile(
              title: '关于陶居屋',
              showDivider: false,
            ),
            VSpacing(20),
            _LoginButton(
              title: '切换账号',
              callback: () {
                RouteHandler.goSwitchAccountPage(context);
              },
            ),
            VSpacing(20),
            _LoginButton(
              title: '退出登录',
              callback: () async {
                await showCupertinoDialog(
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
                              Navigator.of(context).pop();
                              UserProvider user = Provider.of<UserProvider>(
                                  context,
                                  listen: false);
                              user.logOut();
                              RouteHandler.goLoginPage(context);
                            },
                          ),
                        ],
                      );
                    });
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
                      style: textTheme.title,
                      children: [
                        TextSpan(
                            text: provider?.userInfo?.userTel ?? "暂无联系方式",
                            style: textTheme.body1)
                      ])),
                  Text(
                    provider?.userInfo?.shopName,
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
