import 'package:flutter/material.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';

class OrderCommitSuccessPage extends StatelessWidget {
  const OrderCommitSuccessPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        color: themeData.primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            VSpacing(200),
            ZYAssetImage(
              'success@2x.png',
              width: UIKit.width(180),
              height: UIKit.height(180),
            ),
            VSpacing(30),
            Text('等待师傅上门测量尺寸~',style: textTheme.caption,),
            Text('请在测量完成后支付尾款',style: textTheme.caption),
            VSpacing(20),
            InkWell(
              onTap: (){
                RouteHandler.goCurtainMallPage(context);
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: themeData.accentColor,
                      border:
                          Border.all(color: themeData.accentColor, width: .5)),
                  padding: EdgeInsets.symmetric(
                      horizontal: UIKit.width(60), vertical: UIKit.height(20)),
                  child: Text(
                    '继续挑选',
                    style: themeData.accentTextTheme.button,
                  )),
            ),
            VSpacing(20),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: themeData.accentColor, width: .5)),
                padding: EdgeInsets.symmetric(
                    horizontal: UIKit.width(60), vertical: UIKit.height(20)),
                child: Text('查看订单'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
