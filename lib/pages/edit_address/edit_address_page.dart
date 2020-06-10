import 'dart:convert';

import 'package:city_pickers/city_pickers.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/models/user/customer_detail_model.dart';
import 'package:taojuwu/models/zy_response.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
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
  TargetClient targetClient = TargetClient.instance;
  CustomerDetailModel bean;
  String provinceName;
  String cityName;
  String districtName;

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
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    nameInput = TextEditingController();
    telInput = TextEditingController();
    houseNumInput = TextEditingController();
    Future.delayed(Constants.TRANSITION_DURATION, () {
      fetchData();
    });
  }

  void fetchData() {
    OTPService.customerDetail(
      context,
      params: {'id': widget.id},
    ).then((CustomerDetailModelResp response) {
      if (mounted) {
        setState(() {
          bean = response?.data;
          initData(bean);
          setParams(bean);

          isLoading = false;
        });
      }
    }).catchError((err) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void unFocus() {
    FocusManager.instance.primaryFocus.unfocus();
  }

  void setParams(CustomerDetailModel model) {
    params['id'] = '${model?.id ?? ''}';
    params['gender'] = '${model?.clientSex ?? ''}';
    params['province'] = '${model?.provinceId ?? ''}';
    params['city'] = '${model?.cityId ?? ''}';
    params['district'] = '${model?.districtId ?? ''}';
    params['address'] = '${model?.detailAddress ?? ''}';
    params['consigner'] = '${model?.clientName}';
    params['detail_address'] = '${model?.detailAddress}';
    params['mobile'] = '${model?.clientMobile}';
  }

  void saveInfoToTargetClient(int addressId) {
    targetClient.setClientName(bean?.clientName);

    targetClient.setAddressId(addressId);
    targetClient.setTel(bean?.clientMobile);
    targetClient.setGender(bean?.clientSex);
    targetClient.setAddress(
        bean?.provinceName,
        bean?.cityName,
        bean?.districtName,
        bean?.detailAddress,
        bean?.provinceId,
        bean?.cityId,
        bean?.districtId);
  }

  void initData(CustomerDetailModel model) {
    TargetClient targetClient = TargetClient.instance;
    gender = targetClient.gender ?? model?.clientSex ?? 1;
    model?.provinceName =
        targetClient.provinceName ?? model?.provinceName ?? '';

    model?.cityName = targetClient.cityName ?? model?.cityName ?? '';
    model?.districtName =
        targetClient.districtName ?? model?.districtName ?? '';
    model?.provinceId = targetClient?.provinceId ?? model?.provinceId ?? -1;
    model?.cityId = targetClient?.cityId ?? model?.cityId ?? -1;
    model?.districtId = targetClient?.districtId ?? model?.districtId ?? -1;
    nameInput?.text = targetClient.clientName ?? model?.clientName ?? null;
    telInput?.text = targetClient.tel ?? model?.clientMobile ?? null;
    houseNumInput?.text =
        targetClient.detailAddress ?? model.detailAddress ?? null;
  }

  void saveData(CustomerDetailModel model) {
    model?.clientSex = gender;
    model?.detailAddress = houseNumInput?.text;
    model?.clientMobile = telInput?.text;
    model?.clientName = nameInput?.text;
  }

  @override
  void dispose() {
    super.dispose();
    nameInput?.dispose();
    telInput?.dispose();
    houseNumInput?.dispose();
  }

  Future getId(String filePath, String name, CustomerDetailModel model) async {
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
                model?.provinceName = name;
                model?.provinceId = item['province_id'];
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
                model?.cityName = name;
                model?.cityId = item['city_id'];
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
                  model?.districtName = name;
                  model?.districtId = item['district_id'];
                  return;
                }
              }
            }
          }
      }
    }).catchError((err) => err);
  }

  Future setAddress(Result result) async {
    await getId('assets/data/province.json', result?.provinceName, bean);
    await getId('assets/data/city.json', result?.cityName, bean);
    await getId('assets/data/area.json', result?.areaName, bean);

    setState(() {
      bean?.provinceName = result?.provinceName;
      bean?.cityName = result?.cityName;
      bean?.districtName = result?.areaName;
    });
  }

  bool beforeCommit() {
    if (bean?.clientName == null || bean?.clientName?.trim()?.isEmpty == true) {
      CommonKit.showInfo('请填写联系人');
      return false;
    }
    if (bean?.clientSex == 0) {
      CommonKit.showInfo('请填写性别');
      return false;
    }
    if (bean?.clientMobile == null ||
        bean?.clientMobile?.trim()?.isEmpty == true ||
        RegexUtil.isMobileSimple(bean?.clientMobile) == false) {
      CommonKit.showInfo('请输入正确的手机号');
      return false;
    }
    if (bean?.address == null || bean?.address?.trim()?.isEmpty == true) {
      CommonKit.showInfo('请填写正确的收货地址');
      return false;
    }
    if (bean?.detailAddress == null ||
        bean?.detailAddress?.trim()?.isEmpty == true) {
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
        body: isLoading
            ? LoadingCircle()
            : Container(
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
                      padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
                      child: Row(
                        children: <Widget>[
                          Text(' '.padLeft(15)),
                          gender == 1
                              ? ZYRaisedButton('先生', () {
                                  if (gender == 1) return;
                                  unFocus();

                                  setState(() {
                                    gender = 1;
                                  });
                                })
                              : ZYOutlineButton('先生', () {
                                  unFocus();
                                  if (gender == 1) return;
                                  setState(() {
                                    gender = 1;
                                  });
                                }),
                          SizedBox(
                            width: UIKit.width(40),
                          ),
                          gender == 2
                              ? ZYRaisedButton('女士', () {
                                  unFocus();
                                  if (gender == 2) return;
                                  setState(() {
                                    gender = 2;
                                  });
                                })
                              : ZYOutlineButton('女士', () {
                                  unFocus();
                                  if (gender == 2) return;
                                  setState(() {
                                    gender = 2;
                                  });
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
                        unFocus();
                        CityPickers.showCityPicker(
                          context: context,
                          height: UIKit.BOTTOM_PICKER_HEIGHT,
                          itemExtent: UIKit.ITEM_EXTENT,
                          cancelWidget:
                              Text('取消', style: UIKit.CANCEL_BUTTON_STYLE),
                          confirmWidget:
                              Text('确定', style: UIKit.CONFIRM_BUTTON_STYLE),
                        ).then((Result result) async {
                          // provinceId = result.provinceId;
                          await setAddress(result);
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: UIKit.height(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('收货地址:'),
                            Spacer(),
                            Text('${bean?.address ?? ''}'),
                            Icon(ZYIcon.next)
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
                      saveData(bean);
                      if (!beforeCommit()) return;
                      setParams(bean);
                      OTPService.editAddress(context, params: params)
                          .then((ZYResponse response) {
                        if (response.valid) {
                          int id = int.parse('${response.data}' ?? '-1');
                          saveInfoToTargetClient(id);
                          Navigator.of(context).pop();
                        } else {
                          CommonKit.showToast('${response?.message ?? ''}');
                        }
                      }).catchError((err) => err);
                    })
                  ],
                ),
              ));
  }
}
