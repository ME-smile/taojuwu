import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/user/customer_detail_model.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/bottom_picker.dart';

class BaseInfoSegment extends StatefulWidget {
  final CustomerDetailModel model;
  final Map<String, String> params;
  BaseInfoSegment({Key key, this.model, this.params}) : super(key: key);

  @override
  _BaseInfoSegmentState createState() => _BaseInfoSegmentState();
}

class _BaseInfoSegmentState extends State<BaseInfoSegment> {
  TextEditingController nameInput;

  TextEditingController telInput;

  TextEditingController weChatInput;

  CustomerDetailModel model;
  Map<String, String> params;
  FixedExtentScrollController genderController;
  FixedExtentScrollController ageController;

  int gender = 0;
  int age = 0;
  String get genderStr => GENDER_OPTIONS[gender];
  void unFocus() {
    FocusManager.instance.primaryFocus.unfocus();
  }

  static const List<String> GENDER_OPTIONS = ['未知', '男', '女'];
  @override
  void initState() {
    super.initState();
    model = widget.model;
    params = widget.params;
    nameInput = TextEditingController(text: model?.clientName);
    telInput = TextEditingController(text: model?.clientMobile);
    weChatInput = TextEditingController(text: model?.clientWx);
    gender = model?.clientSex ?? 0;
    age = model?.clientAge ?? 0;

    genderController =
        FixedExtentScrollController(initialItem: model?.clientSex ?? 0);
    ageController = FixedExtentScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    nameInput?.dispose();

    telInput?.dispose();

    weChatInput?.dispose();

    genderController?.dispose();
    ageController?.dispose();
  }

  Widget _title(BuildContext context, String title) {
    ThemeData themeData = Theme.of(context);

    return Container(
      color: themeData.dividerColor,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(10)),
      child: Text(
        title ?? '',
        style: themeData.textTheme.caption,
      ),
    );
  }

  Widget _bar(BuildContext context, String title, Function callback,
      {String trailText}) {
    return InkWell(
      onTap: callback,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title ?? ''),
              Row(
                children: <Widget>[
                  Text(
                    trailText ?? '',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Icon(ZYIcon.next)
                ],
              )
            ],
          )),
    );
  }

  // 0 woman 1 man
  void checkGender(
    BuildContext context,
  ) async {
    int tmp = 0;
    await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return BottomPicker(
            title: '选择性别',
            callback: () {
              params['client_sex'] = '${gender ?? 0}';
              setState(() {
                gender = tmp;
              });
              Navigator.of(context).pop();
            },
            child: CupertinoPicker(
                backgroundColor: Theme.of(context).primaryColor,
                scrollController: genderController,
                itemExtent: UIKit.ITEM_EXTENT,
                onSelectedItemChanged: (int index) {
                  tmp = index;
                },
                children: List.generate(GENDER_OPTIONS.length, (int i) {
                  return Center(
                    child: Text(GENDER_OPTIONS[i]),
                  );
                })),
          );
        });
  }

  // 10-80
  void checkAge(
    BuildContext context,
  ) async {
    int tmp;
    await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return BottomPicker(
            title: '选择年龄',
            callback: () {
              params['client_age'] = '${tmp ?? 0}';
              setState(() {
                age = tmp;
              });
              Navigator.of(context).pop();
            },
            child: CupertinoPicker(
                backgroundColor: Theme.of(context).primaryColor,
                scrollController: ageController,
                itemExtent: UIKit.ITEM_EXTENT,
                onSelectedItemChanged: (int index) {
                  tmp = index + 10;
                },
                children: List.generate(70, (int i) {
                  return Center(
                    child: Text('${i + 10}'),
                  );
                })),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      color: themeData.primaryColor,
      child: Column(
        children: <Widget>[
          _title(context, '基本信息'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameInput,
                  onChanged: (String text) {
                    params['client_name'] = nameInput?.text;
                  },
                  decoration: InputDecoration(
                    icon: Text('姓    名'),
                    border: InputBorder.none,
                    hintText: '2-12个字符（必填）',
                  ),
                ),
                Divider(),
                _bar(context, '性    别', () {
                  unFocus();
                  checkGender(
                    context,
                  );
                }, trailText: genderStr),
                Divider(),
                _bar(context, '年    龄', () {
                  unFocus();
                  checkAge(
                    context,
                  );
                }, trailText: '${age ?? 0}'),
                Divider(),
                TextField(
                  controller: telInput,
                  onChanged: (String text) {
                    params['client_mobile'] = text;
                  },
                  decoration: InputDecoration(
                      icon: Text('手机号'),
                      // border: InputBorder.none,
                      hintText: '（必填）'),
                ),
                Divider(),
                TextField(
                  controller: weChatInput,
                  onChanged: (String text) {
                    params['client_wx'] = text;
                  },
                  decoration: InputDecoration(
                      icon: Text('微    信'),
                      border: InputBorder.none,
                      hintText: '（选填）'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
