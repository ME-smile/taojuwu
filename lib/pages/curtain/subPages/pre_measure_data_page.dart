import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/models/shop/sku_attr/room_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_pattern_attr.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/pages/curtain/widgets/attr_options_bar.dart';
import 'package:taojuwu/pages/curtain/widgets/sku_attr_picker.dart';
import 'package:taojuwu/pages/curtain/widgets/window_pattern_view.dart';
import 'package:taojuwu/providers/goods_provider.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class PreMeasureDataPage extends StatefulWidget {
  PreMeasureDataPage({Key key}) : super(key: key);

  @override
  _PreMeasureDataPageState createState() => _PreMeasureDataPageState();
}

class _PreMeasureDataPageState extends State<PreMeasureDataPage> {
  TextEditingController widthInputController;
  TextEditingController heightInputController;
  TextEditingController dyInputController;
  String width = '';
  String height = '';
  String dy = '';
  Map<String, dynamic> data = {};
  Map<String, dynamic> params = {
    'dataId': '',
    'width': '',
    'height': '',
    'install_room': '',
    'goods_id': '',
    'vertical_ground_height': '',
    'data': {},
    'goods_id': ''
  };

  void setParams(GoodsProvider provider) {
    params['dataId'] = '${provider?.windowPatternId ?? ''}';

    params['width'] = '${provider?.widthM ?? ''}';
    params['height'] = '${provider?.heightM ?? ''}';
    params['vertical_ground_height'] = '${provider?.dy ?? ''}';
    params['goods_id'] = '${provider?.goods?.goodsId ?? ''}';
    params['install_room'] = '${provider?.curRoomAttrBean?.id ?? ''}';
    data['${provider?.windowPatternId ?? ''}'] = {
      'name': '${provider?.windowPatternStr ?? ''}',
      'selected': {
        '安装选项': ['${provider?.curInstallModeName ?? ''}'],
        '边距选项': ['满墙', '垂地'],
        '打开方式': ['${provider?.curOpenModeName ?? ''}']
      }
    };
    params['data'] = jsonEncode(data);
    width = '${provider?.widthM ?? ''}';
    height = '${provider?.heightM ?? ''}';
    dy = '${provider?.dy ?? ''}';
  }

  void initSize() {}

  String normalizeData(String n) {
    if (n == null || n?.isEmpty == true) return '';
    // return '${double/}';
    return '';
  }

  @override
  void initState() {
    super.initState();
    // goodsProvider = widget.goodsProvider;
    widthInputController = TextEditingController();
    heightInputController = TextEditingController();
    dyInputController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    widthInputController?.dispose();
    heightInputController?.dispose();
    dyInputController?.dispose();
  }

  void setSize(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('请输入尺寸(cm)'),
            content: Column(
              children: <Widget>[
                CupertinoTextField(
                  placeholder: '请输入宽(cm)',
                ),
                VSpacing(10),
                CupertinoTextField(
                  placeholder: '请输入高(cm)',
                ),
              ],
            ),
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
                },
              )
            ],
          );
        });
  }

  void checkWindowPattern(BuildContext context) async {
    await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return _WindowStyleCheckWrapper();
        });
  }

  Widget _modeBar(
    BuildContext context,
    String title,
    List<String> list,
  ) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    return Consumer<GoodsProvider>(
      builder: (BuildContext context, GoodsProvider provider, _) {
        return Container(
          child: Row(children: [
            Container(
              margin: EdgeInsets.only(right: UIKit.width(30)),
              child: Text(
                title,
                style: textTheme.caption,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(list.length, (int i) {
                  return InkWell(
                    onTap: () {
                      if (title.contains('安装方式')) {
                        provider?.curInstallMode = i;
                      }
                      if (title.contains('打开')) {
                        provider?.curOpenMode = i;
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: UIKit.height(20),
                          vertical: UIKit.height(8)),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: (title.contains('安装') &&
                                          provider?.curInstallMode == i) ||
                                      (title.contains('打开') &&
                                          provider?.curOpenMode == i)
                                  ? Colors.transparent
                                  : Colors.grey),
                          color: (title.contains('安装') &&
                                      provider?.curInstallMode == i) ||
                                  (title.contains('打开') &&
                                      provider?.curOpenMode == i)
                              ? themeData.accentColor
                              : themeData.scaffoldBackgroundColor),
                      child: Text(
                        list[i],
                        style: (title.contains('安装') &&
                                    provider?.curInstallMode == i) ||
                                (title.contains('打开') &&
                                    provider?.curOpenMode == i)
                            ? themeData.accentTextTheme.button
                            : themeData.textTheme.body1,
                      ),
                    ),
                  );
                }),
              ),
            )
          ]),
        );
      },
    );
  }

  void checkRoomAttr(BuildContext context) async {
    await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return _RoomAttrCheckWrapper();
        });
  }

  bool beforeSendData(GoodsProvider provider) {
    if (width?.trim()?.isEmpty == true) {
      CommonKit?.showInfo( '请填写宽度');
      return false;
    }
    if (double.parse(width) == 0) {
      CommonKit?.showInfo('宽度不能为0哦');
      return false;
    }
    if (height?.trim()?.isEmpty == true) {
      CommonKit?.showInfo( '请填写高度');
      return false;
    }
    if (double.parse(width) == 0) {
      CommonKit?.showInfo('高度不能为0哦');
      return false;
    }
    provider?.width = width;
    provider?.height = height;
    provider?.dy = dy;
    setParams(provider);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Consumer<GoodsProvider>(
      builder: (BuildContext context, GoodsProvider provider, _) {
        setParams(provider);
        return Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('测装数据'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: UIKit.width(20), vertical: UIKit.height(20)),
              child: Column(
                children: <Widget>[
                  Container(
                    child: ZYAssetImage(
                      WindowPatternAttr.installModesPic[WindowPatternAttr
                          .installModes[provider?.curInstallMode ?? 0]],
                      width: UIKit.width(480),
                      height: UIKit.height(480),
                    ),
                  ),
                  Divider(),
                  AttrOptionsBar(
                    title: '空间',
                    trailingText: provider?.curRoomAttrBean?.name ?? '',
                    callback: () {
                      checkRoomAttr(context);
                    },
                  ),
                  AttrOptionsBar(
                    title: '窗型',
                    trailingText: provider?.windowPatternStr ?? '',
                    callback: () {
                      checkWindowPattern(context);
                    },
                  ),
                  _modeBar(
                    context,
                    '安装方式:',
                    WindowPatternAttr.installModes,
                  ),
                  Divider(),
                  _modeBar(
                    context,
                    '打开方式:',
                    WindowPatternAttr.openModes,
                  ),
                  Divider(),
                  Column(
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: UIKit.height(20)),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: UIKit.width(30)),
                              child: Text(
                                '宽   (cm):',
                                style: textTheme.caption,
                              ),
                            ),
                            Container(
                              child: TextField(
                                maxLines: 1,
                                controller: widthInputController,
                                onChanged: (String text) {
                                  width = text;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 2.5),
                                ),
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: UIKit.width(20)),
                              width: UIKit.width(160),
                              height: UIKit.height(50),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: UIKit.height(20)),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: UIKit.width(30)),
                              child: Text(
                                '高   (cm):',
                                style: textTheme.caption,
                              ),
                            ),
                            Container(
                              child: TextField(
                                maxLines: 1,
                                controller: heightInputController,
                                onChanged: (String text) {
                                  height = text;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 2.5),
                                ),
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: UIKit.width(20)),
                              width: UIKit.width(160),
                              height: UIKit.height(50),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: UIKit.width(30)),
                          child: Text(
                            '离地距离:',
                            style: textTheme.caption,
                          ),
                        ),
                        Container(
                          child: TextField(
                            maxLines: 1,
                            controller: dyInputController,
                            onChanged: (String text) {
                              dy = text;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '单位(cm)',
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 2.5),
                            ),
                          ),
                          margin:
                              EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                          width: UIKit.width(160),
                          height: UIKit.height(50),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: ZYSubmitButton('确认', () {
            if (!beforeSendData(provider)) return;
            OTPService.saveMeasure(context, params: params)
                .then((ZYResponse response) {
              provider?.measureId = response?.data;
              Navigator.of(context).pop();
            }).catchError((err) => err);
          }),
        );
      },
    );
  }
}

class _RoomAttrCheckWrapper extends StatefulWidget {
  _RoomAttrCheckWrapper({
    Key key,
  }) : super(key: key);

  @override
  __RoomAttrCheckWrapperState createState() => __RoomAttrCheckWrapperState();
}

class __RoomAttrCheckWrapperState extends State<_RoomAttrCheckWrapper> {
  RoomAttr roomAttr;
  List<RoomAttrBean> beans;

  RoomAttrBean tmp;
  int tmpId;
  @override
  void initState() {
    super.initState();
    GoodsProvider provider = Provider.of<GoodsProvider>(context, listen: false);
    roomAttr = provider?.roomAttr;
    tmpId = provider?.curRoomAttrBean?.id;
  }

  @override
  Widget build(BuildContext context) {
    List<RoomAttrBean> beans = roomAttr?.data;
    ThemeData themeData = Theme.of(context);
    return Consumer<GoodsProvider>(
      builder: (BuildContext context, GoodsProvider provider, _) {
        return SkuAttrPicker(
          title: '空间选择',
          child: SingleChildScrollView(
            child: Wrap(
              children: List.generate(beans?.length ?? 0, (int i) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: UIKit.width(10)),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        tmp = beans[i];
                        tmpId = beans[i].id;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: tmpId == beans[i].id
                              ? themeData.accentColor
                              : const Color(0xFFEDEDED)),
                      margin: EdgeInsets.symmetric(
                          horizontal: UIKit.width(10),
                          vertical: UIKit.height(10)),
                      padding: EdgeInsets.symmetric(
                          horizontal: UIKit.width(15),
                          vertical: UIKit.height(10)),
                      child: Text(
                        beans[i].name,
                        style: tmpId == beans[i].id
                            ? themeData.accentTextTheme.button
                            : TextStyle(),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          callback: () {
            provider?.curRoomAttrBean = tmp;
            // print(provider?.curRoomAttrBean?.name);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _WindowStyleCheckWrapper extends StatelessWidget {
  const _WindowStyleCheckWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GoodsProvider>(
      builder: (BuildContext context, GoodsProvider provider, _) {
        return SkuAttrPicker(
          title: '窗型选择',
          child: SingleChildScrollView(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
            child: Column(
              children: [
                WindowPatternView(
                  text: WindowPatternAttr.patterns['title'],
                  imgs: WindowPatternAttr.patterns['options'],
                  curOpotion: provider?.curWindowPattern ?? 0,
                  provider: provider,
                ),
                WindowPatternView(
                  text: WindowPatternAttr.styles['title'],
                  imgs: WindowPatternAttr.styles['options'],
                  curOpotion: provider?.curWindowStyle ?? 0,
                  provider: provider,
                ),
                WindowPatternView(
                  text: WindowPatternAttr.types['title'],
                  imgs: WindowPatternAttr.types['options'],
                  curOpotion: provider?.curWindowType ?? 0,
                  provider: provider,
                )
              ],
            ),
          )),
          callback: () {
            provider?.saveWindowAttrs();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
