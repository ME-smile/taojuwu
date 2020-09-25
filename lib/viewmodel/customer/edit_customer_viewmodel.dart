/*
 * @Description: 编辑用户
 * @Author: iamsmiling
 * @Date: 2020-09-25 09:32:28
 * @LastEditTime: 2020-09-25 11:26:56
 */

import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taojuwu/repository/user/customer_detail_model.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/bottom_picker.dart';

//0--->新增客户  1--->修改客户信息
class EditCustomerViewModel with ChangeNotifier {
  int id; // 客户id

  CustomerDetailModel bean; //用户信息模型
  BuildContext context;
  EditCustomerViewModel(BuildContext context, int id) {
    if (id != null) {
      getCustomerDetailInfo();
    } else {
      bean = CustomerDetailModel();
      initControllers();
    }
  }

  TextEditingController nameInput;

  TextEditingController telInput;

  TextEditingController weChatInput;

  FixedExtentScrollController genderController;
  FixedExtentScrollController ageController;

  TextEditingController addressInput;

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  void initControllers() {
    nameInput = TextEditingController(text: bean.clientName);
    telInput = TextEditingController(text: bean.clientMobile);
    weChatInput = TextEditingController(text: bean.clientWx);
    genderController = FixedExtentScrollController();
    ageController = FixedExtentScrollController();
    addressInput = TextEditingController(text: bean.detailAddress);
  }

  void disposeController() {
    nameInput?.dispose();
    telInput?.dispose();
    weChatInput?.dispose();
    genderController?.dispose();
    ageController?.dispose();
    addressInput?.dispose();
  }

  bool isParamsValid() {
    String name = bean.clientName?.trim();
    if (CommonKit.isNullOrEmpty(name)) {
      ToastKit.showInfo('用户名不能为空哦');
      return false;
    }
    if (name.length > 12 || name.length < 2) {
      ToastKit.showInfo('用户名在2-12个字符之间哟');
      return false;
    }
    if (!RegexUtil.isMobileSimple(bean.clientMobile?.trim())) {
      ToastKit.showInfo('请输入正确的手机号哦');
      return false;
    }
    return true;
  }

  Future getCustomerDetailInfo() {
    return OTPService.customerDetail(context, params: {'id': id})
        .then((CustomerDetailModelResp response) {
      bean = response?.data;
      initControllers();
    });
  }

  Future addUser() {
    if (isParamsValid()) {
      return OTPService.addUser(params).then((ZYResponse response) {
        if (response?.valid == true) {
          Navigator.of(context).pop();
          // RouteHandler.goCustomerPage(context,
          //     isReplaceMode: true);
        }
      }).catchError((err) => err);
    }
    return Future.value(false);
  }

  /*
   * @Author: iamsmiling
   * @description: 根据名称获取省市区id
   * @param : 
   * @return {type} 
   * @Date: 2020-09-25 10:41:10
   */
  Future getId(String filePath, String name) async {
    if (filePath.isEmpty || name.isEmpty) return;
    rootBundle.loadString(filePath).then((String data) {
      Map json = jsonDecode(data);
      List list = json['RECORDS'];
      switch (filePath) {
        case 'assets/data/province.json':
          {
            _getId(list, 1, 'province_name', 'province_id', name);
            break;
          }
        case 'assets/data/city.json':
          {
            _getId(list, 1, 'city_name', 'city_id', name);
            break;
          }
        default:
          {
            _getId(list, 1, 'district_name', 'district_id', name);
            break;
          }
      }
    }).catchError((err) => err);
  }

  /*
   * @Author: iamsmiling
   * @description: 定义内部方法，根据名称在列表中匹配id
   * @param : list -->需要遍历的列表  level == 1代表省 2==市 3==区   namekey 等级键名 idkey  键名  value == 当前选中城市的值
   * @return {type} 
   * @Date: 2020-09-25 10:50:12
   */
  void _getId(
      List list, int level, String nameKey, String idKey, String value) {
    for (int i = 0; i < list.length; i++) {
      Map item = list[i];
      if (item[nameKey].contains(value)) {
        int id = item[idKey];
        switch (level) {
          case 1:
            bean.provinceId = id;
            break;
          case 2:
            bean.cityId = id;
            break;
          case 3:
            bean.districtId = id;
            break;
        }
      }
    }
  }
  /*
    * @Author: iamsmiling
    * @description: 选择用户年龄
    * @param : 
    * @return {type} 
    * @Date: 2020-09-25 11:14:34
    */

  // 10-80
  void checkAge() async {
    int tmp;
    //使输入框失去焦点
    FocusManager.instance.primaryFocus.unfocus();
    await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return BottomPicker(
            title: '选择年龄',
            callback: () {
              bean.clientAge = tmp ?? 0;
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

  /*
   * @Author: iamsmiling
   * @description: 选择用户性别 0 代表女  1代表男
   * @param : 
   * @return {type} 
   * @Date: 2020-09-25 11:20:03
   */
  void checkGender() async {
    int tmp = 0;
    const List<String> GENDER_OPTIONS = ['未知', '男', '女'];
    await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return BottomPicker(
            title: '选择性别',
            callback: () {
              bean?.clientSex = tmp;
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

  // 提交参数
  Map<String, dynamic> get params => bean?.toJson() ?? {};
}
