import 'dart:convert';

import 'package:city_pickers/city_pickers.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

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
  Map<String, String> params;
  @override
  void initState() {
    super.initState();
    model = widget.model;
    params = widget.params;
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
                  ZYIcon.next
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
    return StickyHeader(
        header: _title(context, '特征信息'),
        content: Container(
          color: themeData.primaryColor,
          padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
          child: Column(
            children: <Widget>[
              _bar(context, '入店时间', () {
                DatePicker.showDatePicker(context, showTitleActions: true,
                    onChanged: (date) {
                  setState(() {
                    model?.enterTime = date?.millisecondsSinceEpoch;
                  });
                }, onConfirm: (date) {
                  params['enter_time'] = '${model?.enterTime ?? 0}';
                  params['enter_time'] = params['enter_time'] ==null || params['enter_time'].isEmpty?'0':'${int.parse(params['enter_time'])/1000}';
                }, currentTime: DateTime.now(), locale: LocaleType.zh);
              },
                  trailText:
                      '${DateUtil.formatDateMs(model?.enterTime ?? 0, format: 'yyyy-MM-dd HH:mm:ss')}' ??
                          ''),
              Divider(),
              _bar(context, '区域地址', () {
                CityPickers.showCityPicker(
                    context: context,
                    height: 300,
                    cancelWidget: Text('取消',
                        style: TextStyle(
                            color: const Color(0xFF3C3C3C),
                            fontSize: UIKit.sp(36))),
                    confirmWidget: Text(
                      '确定',
                      style: TextStyle(
                          color: const Color(0xFF2196f3),
                          fontSize: UIKit.sp(32)),
                    )).then((Result result) async {
                  await getId('assets/data/province.json', result.provinceName);
                  await getId('assets/data/city.json', result.cityName);
                  await getId('assets/data/area.json', result.areaName);
                  setState(() {
                    model?.provinceName = result?.provinceName;
                    model?.cityName = result?.cityName;
                    model?.districtName = result?.areaName;
                  });
                }).catchError((err) => err);
              },
                  trailText:
                      '${model?.provinceName ?? ''}${model?.cityName ?? ''}${model?.districtName ?? ''}' ??
                          ''),
              Divider(),
              TextField(
                controller: addressInput,
                onChanged: (String text) {
                  params['detail_address'] = text;
                },
                decoration: InputDecoration(
                    icon: Text('详细地址'),
                    border: InputBorder.none,
                    hintText: '（选填）'),
              ),
            ],
          ),
        ));
  }
}
