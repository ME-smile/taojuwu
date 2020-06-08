import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/models/shop/sku_attr/window_pattern_attr.dart';
import 'package:taojuwu/providers/goods_provider.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class EditOpenModePage extends StatelessWidget {
  const EditOpenModePage({Key key}) : super(key: key);

  Color getBgColor(BuildContext context, bool isCurrentOption) {
    ThemeData themeData = Theme.of(context);
    return isCurrentOption ? themeData.accentColor : themeData.primaryColor;
  }

  Color getBorderColor(BuildContext context, bool isCurrentOption) {
    ThemeData themeData = Theme.of(context);
    return isCurrentOption ? Colors.transparent : themeData.accentColor;
  }

  TextStyle getTextStyle(BuildContext context, bool isCurrentOption) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextTheme accentTextTheme = themeData.accentTextTheme;
    return isCurrentOption ? accentTextTheme.body1 : textTheme.body1;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return WillPopScope(
        child: ChangeNotifierProvider.value(
          value: TargetOrderGoods.instance.goodsProvider,
          child: Scaffold(
            appBar: AppBar(
              title: Text('打开方式'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Consumer<GoodsProvider>(
                builder: (BuildContext context, GoodsProvider provider, _) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: UIKit.width(80)),
                          child: ZYAssetImage(
                            WindowPatternAttr.pictureMap[
                                '${provider?.windowPatternStr}/${provider?.curInstallMode}'],
                            width: 320,
                            height: 280,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: UIKit.width(20),
                                vertical: UIKit.height(20)),
                            child: Row(
                                children: <Widget>[
                                      Text('打开方式:'),
                                    ] +
                                    List.generate(
                                        provider?.openOptions?.length ?? 0,
                                        (int i) {
                                      Map<String, dynamic> item =
                                          provider?.openOptions[i];
                                      return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: UIKit.width(10)),
                                          child: item['is_checked'] == true
                                              ? ZYRaisedButton(
                                                  item['text'],
                                                  () {
                                                    provider?.checkOpenMode(i);
                                                  },
                                                  horizontalPadding:
                                                      UIKit.width(15),
                                                )
                                              : ZYOutlineButton(
                                                  item['text'],
                                                  () {
                                                    provider?.checkOpenMode(i);
                                                  },
                                                  horizontalPadding:
                                                      UIKit.width(15),
                                                ));
                                    }))),
                        Column(
                          children: List.generate(
                              provider?.openSubOptions?.length ?? 0, (int i) {
                            Map<String, dynamic> tmp =
                                provider?.openSubOptions[i];
                            return Row(
                                children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(
                                              right: UIKit.width(30)),
                                          child: Text(
                                            tmp['name'],
                                            style: textTheme.caption,
                                          )),
                                    ] +
                                    List.generate(tmp['options']?.length,
                                        (int j) {
                                      Map<String, dynamic> item =
                                          tmp['options'][j];
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: UIKit.width(10)),
                                        child: item['is_checked']
                                            ? ZYRaisedButton(
                                                item['text'],
                                                () {
                                                  provider?.checkOpenSubOption(
                                                      i, j);
                                                },
                                                horizontalPadding:
                                                    UIKit.width(20),
                                              )
                                            : ZYOutlineButton(
                                                item['text'],
                                                () {
                                                  provider?.checkOpenSubOption(
                                                      i, j);
                                                },
                                                horizontalPadding:
                                                    UIKit.width(20),
                                              ),
                                      );
                                    }));
                          }),
                        ),
                        ZYSubmitButton('确认', () {
                          provider?.measureData?.newOpenType =
                              provider?.curOpenMode;
                          Navigator.of(context).pop();
                        })
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        onWillPop: () {
          // G
          Navigator.of(context).pop();
          return Future.value(false);
        });
  }
}
