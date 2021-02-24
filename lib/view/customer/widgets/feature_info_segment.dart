import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taojuwu/config/sdk/tencent_map.dart';

import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/location/location_bean.dart';
import 'package:taojuwu/repository/user/customer_detail_model.dart';
import 'package:taojuwu/services/otp_service.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/city_picker/x_city_picker.dart';

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

  int provinceId = 1;
  int cityId = 1;
  int districtId = 1;

  String enterTime;

  String provinceName;
  String cityName;
  String districtName;
  Map<String, String> params;
  double longitude;
  double latitude;
  String get address =>
      '${provinceName ?? ''}${cityName ?? ''}${districtName ?? ''}';
  LocationBean locationDataBean;
  @override
  void initState() {
    super.initState();
    model = widget.model;
    params = widget.params;
    // getLocation()
    //     .then((LocationBean locationBean) {
    //       provinceName = locationBean?.province;
    //       cityName = locationBean?.city;
    //       districtName = locationBean?.district;
    //       locationDataBean = locationBean;
    //       print(locationDataBean?.data);
    //     })
    //     .catchError((err) => err)
    //     .whenComplete(() {
    //       // ignore: unnecessary_statements
    //       mounted ? setState(() {}) : '';
    //     });
    if (model != null) {
      provinceName = model?.provinceName;
      cityName = model?.cityName;
      districtName = model?.districtName;
      provinceId = model?.provinceId;
      cityId = model?.cityId;
      districtId = model?.districtId;
    } else {}

    if (model == null) {
      enterTime = DateUtil.formatDateMs(DateTime.now().millisecondsSinceEpoch,
          format: 'yyyy-MM-dd HH:mm:ss');
    } else {
      enterTime = DateUtil.formatDateMs((model?.enterTime ?? 0) * 1000,
          format: 'yyyy-MM-dd HH:mm:ss');
    }

    addressInput = TextEditingController(text: model?.detailAddress);
  }

  Future<LocationBean> getLocation() async {
    LocationBean locationBean;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.openLocationSettings();

      if (!serviceEnabled) return Future.value(null);
    }
    LocationPermission permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.denied ||
        permissionStatus == LocationPermission.deniedForever) {
      permissionStatus = await Geolocator.requestPermission();

      if (permissionStatus != LocationPermission.whileInUse ||
          permissionStatus != LocationPermission.always)
        return Future.value(null);
    }

    try {
      // Position locationData = await Geolocator.getCurrentPosition(
      //     desiredAccuracy: LocationAccuracy.bestForNavigation,
      //     forceAndroidLocationManager: true);

      locationBean = await OTPService.ipLocate(context, params: {
        'key': TencentMap.KEY,
        // 'location': '120.79996,30.6871',
        // 'location': '${locationData?.longitude},${locationData?.latitude}'
        // 'radius': 1000,
        // 'batch':false,
        // 'extensions':'all',
      });
      print(locationBean);
    } catch (err) {
      print('获取定位出错');
      print(err);
    } finally {
      //释放资源
    }
    return Future.value(locationBean);
  }

  @override
  void dispose() {
    super.dispose();
    addressInput?.dispose();
  }

  Widget _title(BuildContext context, String title) {
    // ThemeData themeData = Theme.of(context);

    return Container(
      color: const Color(0xFFF5F5F9),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(10)),
      child: Text(
        title ?? '',
        style: TextStyle(color: const Color(0xFF666666), fontSize: 13),
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

  // Future getId(String filePath, String name) async {
  //   if (filePath.isEmpty || name.isEmpty) return;
  //   rootBundle.loadString(filePath).then((String data) {
  //     Map json = jsonDecode(data);
  //     List list = json['RECORDS'];
  //     switch (filePath) {
  //       case 'assets/data/province.json':
  //         {
  //           for (int i = 0; i < list.length; i++) {
  //             Map item = list[i];
  //             if (item['province_name'].contains(name)) {
  //               provinceId = '${item['province_id']}';
  //               params['province_id'] = provinceId;
  //               return;
  //             }
  //           }
  //           break;
  //         }
  //       case 'assets/data/city.json':
  //         {
  //           for (int i = 0; i < list.length; i++) {
  //             Map item = list[i];
  //             if (item['city_name'].contains(name)) {
  //               cityId = '${item['city_id']}';
  //               params['city_id'] = cityId;
  //               return;
  //             }
  //           }
  //         }
  //         break;
  //       default:
  //         {
  //           {
  //             for (int i = 0; i < list.length; i++) {
  //               Map item = list[i];

  //               if (item['district_name'].contains(name)) {
  //                 districtId = '${item['district_id']}';
  //                 params['district_id'] = districtId;
  //                 return;
  //               }
  //             }
  //           }
  //         }
  //     }
  //   }).catchError((err) => err);
  // }

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
                          params['enter_time'] = "${(tmp ~/ 1000)}";
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
                    showXCityPicker(context,
                            addressResult: AddressResult.fromId(
                                provinceId, cityId, districtId))
                        .then((data) {
                      if (data is AddressResult) {
                        provinceId = data.provicne.id;
                        cityId = data.city.id;
                        districtId = data.district.id;
                        provinceName = data.provicne.name;
                        cityName = data.city.name;
                        districtName = data.district.name;
                        params["province_id"] = '$provinceId';
                        params["city_id"] = '$cityId';
                        params["district_id"] = '$districtId';
                      }
                    }).whenComplete(() {
                      setState(() {});
                    });
                    // CityPickers.showCityPicker(
                    //     context: context,
                    //     height: UIKit.BOTTOM_PICKER_HEIGHT,
                    //     itemExtent: UIKit.ITEM_EXTENT,
                    //     cancelWidget:
                    //         Text('取消', style: UIKit.CANCEL_BUTTON_STYLE),
                    //     confirmWidget: Text(
                    //       '确定',
                    //       style: UIKit.CONFIRM_BUTTON_STYLE,
                    //     )).then((Result result) async {
                    //   await getId(
                    //       'assets/data/province.json', result.provinceName);
                    //   await getId('assets/data/city.json', result.cityName);
                    //   await getId('assets/data/area.json', result.areaName);
                    //   setState(() {
                    //     provinceName = result?.provinceName;
                    //     cityName = result?.cityName;
                    //     districtName = result?.areaName;
                    //   });
                    // }).catchError((err) => err);
                  }, trailText: address),
                  // Text('${locationDataBean?.data}'),
                  // Text('经度:$longitude'),
                  // Text('纬度:$latitude'),
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
