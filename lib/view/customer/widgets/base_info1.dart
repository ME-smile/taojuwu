import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/user/customer_detail_model.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/viewmodel/customer/edit_customer_viewmodel.dart';

class BaseInfoSegment extends StatefulWidget {
  final CustomerDetailModel model;
  final Map<String, String> params;

  final EditCustomerViewModel viewModel;
  BaseInfoSegment(this.viewModel, {Key key, this.model, this.params})
      : super(key: key);

  @override
  _BaseInfoSegmentState createState() => _BaseInfoSegmentState();
}

class _BaseInfoSegmentState extends State<BaseInfoSegment> {
  TextEditingController nameInput;

  TextEditingController telInput;

  TextEditingController weChatInput;

  Map<String, String> params;
  FixedExtentScrollController genderController;
  FixedExtentScrollController ageController;

  EditCustomerViewModel get viewmodel => widget.viewModel;
  CustomerDetailModel get model => viewmodel.bean;

  int gender = 0;
  int age = 0;

  @override
  void initState() {
    super.initState();
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
                  onChanged: (String text) {
                    model.clientName = text;
                  },
                  decoration: InputDecoration(
                    icon: Text('姓    名'),
                    border: InputBorder.none,
                    hintText: '2-12个字符（必填）',
                  ),
                ),
                Divider(),
                _bar(context, '性    别', viewmodel.checkGender, trailText: ''),
                Divider(),
                _bar(context, '年    龄', viewmodel.checkAge,
                    trailText: '${age ?? 0}'),
                Divider(),
                TextField(
                  onChanged: (String text) {
                    model?.clientMobile = text;
                  },
                  decoration: InputDecoration(
                      icon: Text('手机号'),
                      // border: InputBorder.none,
                      hintText: '（必填）'),
                ),
                Divider(),
                TextField(
                  onChanged: (String text) {
                    model?.clientWx = text;
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
