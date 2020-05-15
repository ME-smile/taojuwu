import 'dart:convert';

import 'package:city_pickers/city_pickers.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/user/customer_detail_model.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/providers/client_provider.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';
import 'package:taojuwu/widgets/zy_submit_button.dart';

class EditAddressPage extends StatefulWidget {
  final int id;
  EditAddressPage({Key key, this.id}) : super(key: key);

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  TextEditingController nameInput;
  TextEditingController telInput;
  TextEditingController houseNumInput;
  FocusNode focusNode = FocusNode();

  String provinceName;
  String cityName;
  String districtName;
  String detailAddress = '';
  String name = '';
  String tel = '';
  int gender = 0;
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
    'detail_address': ''
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
    params['gender'] = '${provider?.gender ?? ''}';
    params['province'] = '${provider?.provinceId ?? ''}';
    params['city'] = '${provider?.cityId ?? ''}';
    params['district'] = '${provider?.districtId ?? ''}';
    params['address'] = '${provider?.detailAddress ?? ''}';
    provinceName = '${provider?.provinceName ?? ''}';
    cityName = '${provider?.cityName ?? ''}';
    districtName = '${provider?.districtName ?? ''}';
    params['gender'] = params['consigner'] = name;
    params['detail_address'] = detailAddress;
    params['mobile'] = tel;
  }

  void saveToProvider(ClientProvider provider) {
    provider?.name = name;
    provider?.tel = tel;
    provider?.detailAddress = detailAddress;
  }

  void initToController(ClientProvider provider) {
    name = provider?.name;
    tel = provider?.tel;
    detailAddress = provider?.detailAddress;
    nameInput.text = provider?.name ?? null;
    telInput.text = provider?.tel ?? null;
    houseNumInput.text = provider?.detailAddress ?? null;
  }

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
                provider?.provinceId = item['province_id'];
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
                provider?.cityId = item['city_id'];
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
                  provider?.districtId = item['district_id'];
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
      CommonKit.showInfo('请填写联系人');
      return false;
    }
    if (provider?.gender == null) {
      CommonKit.showInfo('请填写性别');
      return false;
    }
    if (provider?.tel == null ||
        provider?.tel?.trim()?.isEmpty == true ||
        RegexUtil.isMobileSimple(provider?.tel) == false) {
      CommonKit.showInfo('请输入正确的手机号');
      return false;
    }
    if (provider?.address == null ||
        provider?.address?.trim()?.isEmpty == true) {
      CommonKit.showInfo('请填写正确的收货地址');
      return false;
    }
    if (provider?.detailAddress == null ||
        provider?.detailAddress?.trim()?.isEmpty == true) {
      CommonKit.showInfo('请记得填写门牌号哦');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('填写收货地址'),
          centerTitle: true,
        ),
        body: Consumer<ClientProvider>(
          builder: (BuildContext context, ClientProvider provider, _) {
            return ZYFutureBuilder(
                futureFunc: OTPService.customerDetail,
                params: {'id': widget.id},
                builder: (
                  BuildContext context,
                  CustomerDetailModelResp response,
                ) {
                  provider?.setClientModel(response?.data ?? null);
                  initToController(provider);
                  setParams(provider);
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
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: UIKit.width(20)),
                                  hintText: '请填写联系人的姓名',
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: UIKit.height(10)),
                          child: Row(
                            children: <Widget>[
                              Text(' '.padLeft(15)),
                              provider?.gender == 1
                                  ? ZYRaisedButton('先生', () {
                                      if (provider?.gender == 1) return;
                                      provider?.gender = 1;
                                    })
                                  : ZYOutlineButton('先生', () {
                                      if (provider?.gender == 1) return;
                                      provider?.gender = 1;
                                    }),
                              SizedBox(
                                width: UIKit.width(40),
                              ),
                              provider?.gender == 2
                                  ? ZYRaisedButton('女士', () {
                                      if (provider?.gender == 2) return;
                                      provider?.gender = 2;
                                    })
                                  : ZYOutlineButton('女士', () {
                                      if (provider?.gender == 2) return;
                                      provider?.gender = 2;
                                    }),
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
                                focusNode: focusNode,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: UIKit.width(20)),
                                  hintText: '请输入手机号',
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        InkWell(
                          onTap: () {
                            focusNode.unfocus();
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
                              await getId('assets/data/city.json',
                                  result?.cityName, provider);
                              await getId('assets/data/area.json',
                                  result?.areaName, provider);

                              provider?.provinceName = result?.provinceName;
                              provider?.cityName = result?.cityName;
                              provider?.districtName = result?.areaName;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: UIKit.height(10)),
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
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: UIKit.width(20)),
                                  hintText: '请填写您要测量安装的具体地址',
                                ),
                              ),
                            )
                          ],
                        ),
                        VSpacing(50),
                        ZYSubmitButton('保存并使用', () {
                          saveToProvider(provider);
                          setParams(provider);
                          if (!beforeCommit(provider)) return;
                          OTPService.editAddress(context, params: params)
                              .then((ZYResponse response) {
                            if (response.valid) {
                              provider?.addressId =
                                  int.parse('${response.data}') ?? -1;

                              Navigator.of(context).pop();
                            } else {
                              CommonKit.showToast('${response?.message ?? ''}');
                            }
                          }).catchError((err) => err);
                        })
                      ],
                    ),
                  );
                });
          },
        ));
  }
}
