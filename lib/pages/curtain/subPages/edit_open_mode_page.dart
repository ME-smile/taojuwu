import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/providers/goods_provider.dart';
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
    // ThemeData themeData = Theme.of(context);
    // TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('打开方式'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: UIKit.width(80)),
                child: ZYAssetImage(
                  'curtain/size_000011.png',
                  width: 320,
                  height: 280,
                ),
              ),
              Consumer<GoodsProvider>(
                builder: (BuildContext context, GoodsProvider provider, _) {
                  return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: UIKit.width(40),
                          vertical: UIKit.height(20)),
                      child: Row(
                          children: <Widget>[
                                Text('打开方式:'),
                              ] +
                              List.generate(provider?.openOptions?.length ?? 0,
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
                                            horizontalPadding: UIKit.width(15),
                                          )
                                        : ZYOutlineButton(
                                            item['text'],
                                            () {
                                              provider?.checkOpenMode(i);
                                            },
                                            horizontalPadding: UIKit.width(15),
                                          ));
                              })));

                  //      <Widget>[
                  //       Text('打开方式:'),

                  //       InkWell(
                  //         onTap: () {
                  //           // goodsProvider?.curOpenMode = 0;
                  //         },

                  //         child: Container(
                  //           margin: EdgeInsets.symmetric(
                  //               horizontal: UIKit.width(40)),
                  //           padding: EdgeInsets.symmetric(
                  //               horizontal: UIKit.width(30),
                  //               vertical: UIKit.height(10)),
                  //           decoration: BoxDecoration(
                  //               color: getBgColor(context, false),
                  //               border: Border.all(
                  //                   color: getBorderColor(context, false))),
                  //           child: Text(
                  //             '整体对开',
                  //             style: getTextStyle(context, false),
                  //           ),
                  //         ),
                  //       ),
                  //       InkWell(
                  //         onTap: () {
                  //           // goodsProvider?.curOpenMode = 1;
                  //         },
                  //         child: Container(
                  //           padding: EdgeInsets.symmetric(
                  //               horizontal: UIKit.width(30),
                  //               vertical: UIKit.height(10)),
                  //           decoration: BoxDecoration(
                  //               color: getBgColor(context, false),
                  //               border: Border.all(
                  //                   color: getBorderColor(context, false))),
                  //           child: Text(
                  //             '整体单开',
                  //             style: getTextStyle(context, false),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // );
                },
              ),
              ZYSubmitButton('确认', () {
                Navigator.of(context).pop();
              })
            ],
          ),
        ),
      ),
    );
  }
}
