import 'dart:convert';

import 'package:city_pickers/city_pickers.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/user/customer_detail_model.dart';
import 'package:taojuwu/utils/ui_kit.dart';

class FeatureInfoSegment extends StatefulWidget {
  final CustomerDetailModel model;
  final Map<String, String> params;
  FeatureInfoSegment({Key key, this.model, this.params}) : super(key: key);

  @override
  _FeatureInfoSegmentState createState() => _FeatureInfoSegmentState();
}

class _FeatureInfoSegmentState extends State<FeatureInfoSegment> {
  TextEditingController addressInput;
  CustomerDetailModel model;

  String provinceId;
  String cityId;
  String districtId;

  String enterTime;

  String provinceName;
  String cityName;
  String districtName;
  Map<String, String> params;

  String get address =>
      '${provinceName ?? ''}${cityName ?? ''}${districtName ?? ''}';

  @override
  void initState() {
    super.initState();
    model = widget.model;
    params = widget.params;
    provinceName = model?.provinceName;
    cityName = model?.cityName;
    districtName = model?.districtName;
    if (model == null) {
      enterTime = DateUtil.formatDateMs(DateTime.now().millisecondsSinceEpoch,
          format: 'yyyy-MM-dd HH:mm:ss');
    } else {
      enterTime = DateUtil.formatDateMs(model?.enterTime ?? 0,
          format: 'yyyy-MM-dd HH:mm:ss');
    }

    addressInput = TextEditingController(text: model?.detailAddress);
  }

  @override
  void dispose() {
    super.dispose();
    addressInput?.dispose();
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
              ),
            ],
          )),
    );
  }

  Future getId(String filePath, String name) async {
    if (filePath.isEmpty || name.isEmpty) return;
    rootBundle.loadString(filePath).then((String data) {
      Map json = jsonDecode(data);
      List list = json['RECORDS'];
      switch (filePath) {
        case 'assets/data/province.json':
          {
            for (int i = 0; i < list.length; i++) {
              Map item = list[i];
              if (item['province_name'].contains(name)) {
                provinceId = '${item['province_id']}';
                params['province_id'] = provinceId;
                return;
              }
            }
            break;
          }
        case 'assets/data/city.json':
          {
            for (int i = 0; i < list.length; i++) {
              Map item = list[i];
              if (item['city_name'].contains(name)) {
                cityId = '${item['city_id']}';
                params['city_id'] = cityId;
                return;
              }
            }
          }
          break;
        default:
          {
            {
              for (int i = 0; i < list.length; i++) {
                Map item = list[i];

                if (item['district_name'].contains(name)) {
                  districtId = '${item['district_id']}';
                  params['district_id'] = districtId;
                  return;
                }
              }
            }
          }
      }
    }).catchError((err) => err);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
        color: themeData.primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _title(context, '特征信息'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
              child: Column(
                children: <Widget>[
                  _bar(context, '入店时间', () {
                    int tmp = 0;
                    DateTime now = DateTime.now();
                    bool hasChangeEnterTime = false;
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        theme: DatePickerTheme(
                            cancelStyle: UIKit.CANCEL_BUTTON_STYLE,
                            itemHeight: UIKit.ITEM_EXTENT,
                            doneStyle: UIKit.CONFIRM_BUTTON_STYLE,
                            itemStyle: UIKit.OPTION_ITEM_STYLE,
                            containerHeight: UIKit.BOTTOM_PICKER_HEIGHT),
                        onChanged: (DateTime date) {
                          hasChangeEnterTime = true;
                          tmp = date?.millisecondsSinceEpoch;
                        },
                        onConfirm: (date) {
                          if (hasChangeEnterTime == false)
                            tmp = now.millisecondsSinceEpoch;
                          params['enter_timer'] = '${tmp ~/ 1000}';
                          setState(() {
                            enterTime = DateUtil.formatDateMs(tmp,
                                format: 'yyyy-MM-dd HH:mm:ss');
                          });
                        },
                        currentTime: now,
                        locale: LocaleType.zh,
                        onCancel: () {
                          tmp = now.millisecondsSinceEpoch;
                        });
                  }, trailText: '$enterTime' ?? ''),
                  Divider(),
                  _bar(context, '区域地址', () {
                    CityPickers.showCityPicker(
                        context: context,
                        height: UIKit.BOTTOM_PICKER_HEIGHT,
                        itemExtent: UIKit.ITEM_EXTENT,
                        cancelWidget:
                            Text('取消', style: UIKit.CANCEL_BUTTON_STYLE),
                        confirmWidget: Text(
                          '确定',
                          style: UIKit.CONFIRM_BUTTON_STYLE,
                        )).then((Result result) async {
                      await getId(
                          'assets/data/province.json', result.provinceName);
                      await getId('assets/data/city.json', result.cityName);
                      await getId('assets/data/area.json', result.areaName);
                      setState(() {
                        provinceName = result?.provinceName;
                        cityName = result?.cityName;
                        districtName = result?.areaName;
                      });
                    }).catchError((err) => err);
                  }, trailText: address),
                  Divider(),
                  TextField(
                    controller: addressInput,
                    onChanged: (String text) {
                      params['detail_address'] = text;
                    },
                    decoration: InputDecoration(
                        icon: Text('详细地址'),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: '（选填）'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
