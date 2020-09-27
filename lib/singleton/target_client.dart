/*
 * @Description: 下单时选中的目标客户
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-09-25 15:47:46
 */
import 'package:taojuwu/repository/user/category_customer_model.dart';
import 'package:taojuwu/repository/user/customer_model.dart';

class TargetClient {
  TargetClient._internal();

  TargetClient.fromCustomerModelBean(CustomerModelBean bean) {
    clientId = bean.id;
    clientName = bean.clientName;
  }

  TargetClient.fromCategoryCustomerModelBean(CategoryCustomerModelBean bean) {
    clientId = bean.id;
    clientName = bean.clientName;
  }

  TargetClient.fromLiteral(id, name) {
    clientId = id;
    clientName = name;
  }

  // 在按钮出展示的名字
  String get displayName {
    if (!hasSelectedClient) return '请选择';
    return clientName;
  }

  int clientId;
  String clientName;

  String tel;
  String get address =>
      '${_instance.provinceName ?? ''}${_instance.cityName ?? ''}${_instance.districtName ?? ''}${_instance.detailAddress ?? ''}';
  String detailAddress = '';
  int gender; //1 表示男 2 表示女

  int addressId;

  String districtName;
  String cityName;
  String provinceName;

  int provinceId;
  int cityId;
  int districtId;
  bool get hasSelectedClient => clientId != null;

  static TargetClient _instance = TargetClient._internal();
  factory TargetClient() {
    return _instance;
  }
  static TargetClient get instance => _instance;

  setClientId(int id) {
    _instance.clientId = id;
  }

  setGender(int i) {
    _instance.gender = i;
  }

  setClientName(String name) {
    int len = name?.length ?? 0;
    if (len > 5) {
      name = name.substring(0, 5) + '...';
    }
    _instance.clientName = name;
  }

  clear() {
    _instance.clientName = null;
    _instance.clientId = null;
    _instance.tel = null;
    _instance.provinceName = null;
    _instance.cityName = null;
    _instance.districtName = null;
    _instance.detailAddress = null;
    _instance.provinceId = null;
    _instance.cityId = null;
    _instance.districtId = null;
    _instance.addressId = null;
  }

  saveInfo(int id, String name) {
    _instance.clientId = id;
    _instance.clientName = name;
  }

  setTel(String tel) {
    _instance.tel = tel;
  }

  setAddress(String province, String city, String district,
      String detailAddress, int provinceId, int cityId, int districtId) {
    _instance.provinceName = province;
    _instance.cityName = city;
    _instance.districtName = district;
    _instance.detailAddress = detailAddress;
    _instance.provinceId = provinceId;
    _instance.cityId = cityId;
    _instance.districtId = districtId;
  }

  setAddressId(int id) {
    _instance.addressId = id;
  }
}
