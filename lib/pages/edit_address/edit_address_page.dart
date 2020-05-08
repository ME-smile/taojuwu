import 'dart:convert';

import 'package:city_pickers/city_pickers.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/providers/client_provider.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

class EditAddressPage extends StatefulWidget {
  EditAddressPage({Key key}) : super(key: key);

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  TextEditingController nameInput;
  TextEditingController telInput;
  TextEditingController houseNumInput;

  String provinceId;
  String cityId;
  String districtId;
  String provinceName;
  String cityName;
  String districtName;
  String detailAddress = '';
  String name = '';
  String tel = '';

  Map<String, String> params = {
    'id': '',
    'consigner': '',
    'mobile': '',
    'province': '',
    'city': '',
    'district': '',
    'address': '',
    'zip_code': '',
    'is_default': '',
    'gender': '',
  };
  @override
  void initState() {
    super.initState();
    nameInput = TextEditingController();
    telInput = TextEditingController();
    houseNumInput = TextEditingController();
  }

  void setParams(ClientProvider provider) {
    params['id'] = '${provider?.clientId ?? ''}';
    params['consigner'] = '${provider?.name ?? ''}';
    params['mobile'] = '${provider?.tel ?? ''}';
    params['gender'] = '${provider?.gender ?? ''}';
    params['province'] = '${provider?.provinceId ?? ''}';
    params['city'] = '${provider?.cityId ?? ''}';
    params['district'] = '${provider?.districtId ?? ''}';
    params['address'] = '${provider?.detailAddress ?? ''}';
    provinceName = '${provider?.provinceName ?? ''}';
    cityName = '${provider?.cityName ?? ''}';
    districtName = '${provider?.districtName ?? ''}';
    detailAddress = '${provider?.detailAddress ?? ''}';
    name = '${provider?.name ?? ''}';
    tel = '${provider?.tel ?? ''}';
  }

  void saveToProvider(ClientProvider provider) {
    provider?.name = name;
    provider?.tel = tel;
    provider?.detailAddress = detailAddress;
  }

  static const GENDER_MAP = {'男': '1', '女': '2', '1': '1', '2': '2'};

  @override
  void dispose() {
    super.dispose();
    nameInput?.dispose();
    telInput?.dispose();
    houseNumInput?.dispose();
  }

  Future getId(String filePath, String name, ClientProvider provider) async {
    if (filePath?.isEmpty == true || name?.isEmpty == true) return;
    rootBundle.loadString(filePath).then((String data) {
      Map json = jsonDecode(data);
      List list = json['RECORDS'];
      switch (filePath) {
        case 'assets/data/province.json':
          {
            for (int i = 0; i < list.length; i++) {
              Map item = list[i];
              if (item['province_name']?.contains(name) == true) {
                provinceId = '${item['province_id']}';
                provider?.provinceId = provinceId;
                return;
              }
            }
            break;
          }
        case 'assets/data/city.json':
          {
            for (int i = 0; i < list.length; i++) {
              Map item = list[i];
              if (item['city_name']?.contains(name) == true) {
                cityId = '${item['city_id']}';
                provider?.cityId = cityId;
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

                if (item['district_name']?.contains(name) == true) {
                  districtId = '${item['district_id']}';
                  provider?.districtId = districtId;
                  return;
                }
              }
            }
          }
      }
    }).catchError((err) => err);
  }

  bool beforeCommit(ClientProvider provider) {
    if (provider?.name == null || provider?.name?.trim()?.isEmpty == true) {
      CommonKit.toast(context, '请填写联系人');
      return false;
    }
    if (provider?.gender == null || provider?.gender?.trim()?.isEmpty == true) {
      CommonKit.toast(context, '请填写性别');
      return false;
    }
    if (provider?.tel == null ||
        provider?.tel?.trim()?.isEmpty == true ||
        RegexUtil.isMobileSimple(provider?.tel) == false) {
      CommonKit.toast(context, '请输入正确的手机号');
      return false;
    }
    if (provider?.address == null ||
        provider?.address?.trim()?.isEmpty == true) {
      CommonKit.toast(context, '请填写正确的收货地址');
      return false;
    }
    if (provider?.detailAddress == null ||
        provider?.detailAddress?.trim()?.isEmpty == true) {
      CommonKit.toast(context, '请记得填写门牌号哦');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextTheme accentTextTheme = themeData.accentTextTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('填写收货地址'),
        centerTitle: true,
      ),
      body: Consumer<ClientProvider>(
        builder: (BuildContext context, ClientProvider provider, _) {
          setParams(provider);
          nameInput.text = provider?.name ?? null;
          telInput.text = provider?.tel ?? null;
          houseNumInput.text = provider?.detailAddress ?? null;
          return Container(
            color: themeData.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('联系人:'),
                    Expanded(
                      child: TextField(
                        controller: nameInput,
                        onChanged: (String text) {
                          name = text;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                          hintText: '请填写联系人的姓名',
                        ),
                      ),
                    )
                  ],
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
                  child: Row(
                    children: <Widget>[
                      Text(' '.padLeft(15)),
                      InkWell(
                        onTap: () {
                          if (GENDER_MAP[provider?.gender] == '1') return;
                          provider?.gender = '1';
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: UIKit.width(20),
                              vertical: UIKit.height(5)),
                          decoration: BoxDecoration(
                              color: GENDER_MAP[provider?.gender] == '1'
                                  ? themeData.accentColor
                                  : Colors.transparent,
                              border: Border.all(color: Colors.grey)),
                          child: Text(
                            '先生',
                            style: GENDER_MAP[provider?.gender] == '1'
                                ? accentTextTheme.button
                                : textTheme.body1,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (GENDER_MAP[provider?.gender] == '2') return;
                          provider?.gender = '2';
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                          padding: EdgeInsets.symmetric(
                              horizontal: UIKit.width(20),
                              vertical: UIKit.height(5)),
                          decoration: BoxDecoration(
                              color: GENDER_MAP[provider?.gender] == '2'
                                  ? themeData.accentColor
                                  : Colors.transparent,
                              border: Border.all(color: Colors.grey)),
                          child: Text(
                            '女士',
                            style: GENDER_MAP[provider?.gender] == '2'
                                ? accentTextTheme.button
                                : textTheme.body1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Text('手机号:'),
                    Expanded(
                      child: TextField(
                        controller: telInput,
                        onChanged: (String text) {
                          tel = text;
                        },
                        onEditingComplete: () {
                          tel = telInput?.text;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                          hintText: '请输入手机号',
                        ),
                      ),
                    )
                  ],
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    CityPickers.showCityPicker(
                      context: context,
                      height: 300,
                      cancelWidget: Text('取消',
                          style: TextStyle(
                              color: const Color(0xFF3C3C3C),
                              fontSize: UIKit.sp(36))),
                      confirmWidget: Text('确定',
                          style: TextStyle(
                              color: const Color(0xFF2196f3),
                              fontSize: UIKit.sp(32))),
                    ).then((Result result) async {
                      // provinceId = result.provinceId;
                      await getId('assets/data/province.json',
                          result?.provinceName, provider);
                      await getId(
                          'assets/data/city.json', result?.cityName, provider);
                      await getId(
                          'assets/data/area.json', result?.areaName, provider);

                      provider?.provinceName = result?.provinceName;
                      provider?.cityName = result?.cityName;
                      provider?.districtName = result?.areaName;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('收货地址:'),
                        Spacer(),
                        Text('${provider?.address ?? ''}'),
                        ZYIcon.next
                      ],
                    ),
                  ),
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Text('门牌号:'),
                    Expanded(
                      child: TextField(
                        controller: houseNumInput,
                        onChanged: (String text) {
                          detailAddress = text;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                          hintText: '请填写您要测量安装的具体地址',
                        ),
                      ),
                    )
                  ],
                ),
                VSpacing(50),
                InkWell(
                    onTap: () {
                      // params['address'] = detailAddress;
                      // params['city'] = cityId;
                      // params['district'] = districtId;
                      // params['province'] = provinceId;
                      print('手机号码---------');
                      print(tel);
                      saveToProvider(provider);
                      setParams(provider);
                      if (!beforeCommit(provider)) return;
                      OTPService.editAddress(context, params: params)
                          .then((ZYResponse response) {
                        CommonKit.toast(context, '${response?.message ?? ''}');

                        provider?.addressId = '${response.data}';

                        provider?.saveClientInfo(address: '${response.data}');
                      }).catchError((err) => err);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: UIKit.width(20),
                          vertical: UIKit.height(20)),
                      color: themeData.accentColor,
                      margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
                      child: Text(
                        '保存并使用',
                        style: accentTextTheme.button,
                      ),
                    ))
              ],
            ),
          );
        },
      ),
    );
  }
}
