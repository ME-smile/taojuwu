import 'package:flutter/material.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

class SwitchAccountPage extends StatelessWidget {
  const SwitchAccountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('切换账号'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            VSpacing(200),
            Text('轻触头像以切换账号', style: textTheme.title),
            VSpacing(50),
            Divider(
              indent: UIKit.width(200),
              endIndent: UIKit.width(200),
              thickness: 2,
            ),
            VSpacing(50),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1586945956674&di=dc744317fe6c15c3e13a55fbe932efc1&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201807%2F30%2F20180730190139_uPcss.jpeg',
                          width: UIKit.width(200),
                          height: UIKit.width(200),
                          fit: BoxFit.fill,
                        ),
                        VSpacing(10),
                        Text(
                          '张爽',
                          style: textTheme.subhead,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              ZYIcon.dot,
                              color: const Color(0xFF6ABD13),
                              size: 16,
                            ),
                            Text(
                              '当前使用',
                              style: textTheme.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          UIKit.getAssetsImagePath('add.png'),
                          width: UIKit.width(200),
                          height: UIKit.width(200),
                        ),
                        VSpacing(10),
                        Text(
                          '切换账号',
                          style: textTheme.caption
                              .copyWith(fontSize: UIKit.sp(24)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
