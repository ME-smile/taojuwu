import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';

class ClientProvider with ChangeNotifier {
  String _name;
  String _tel;
  String _gender;
  String _addressId;
  String _detailAddress;
  int _clientId;
  int _goodsId;
  String _provinceId;
  String _cityId;
  String _districtId;
  String _provinceName;
  String _cityName;
  String _districtName;

  bool _isForSelectedClient = false;
  int get goodsId => _goodsId;
  int get clientId => _clientId;
  String get tel => _tel;
  String get provinceId => _provinceId;
  String get cityId => _cityId;
  String get districtId => _districtId;
  String get provinceName => _provinceName;
  String get cityName => _cityName;
  String get districtName => _districtName;
  bool get isForSelectedClient => _isForSelectedClient;
  String get detailAddress => _detailAddress;
  String get gender => _gender;
  String get name => _name;
  String get addressId => _addressId;
  String get address =>
      '${_provinceName ?? ''}${_cityName ?? ''}${_districtName ?? ''}';

  bool get hasChoosenCustomer => clientId != null;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  set provinceName(String provinceName) {
    _provinceName = provinceName;
    notifyListeners();
  }

  set cityName(String cityName) {
    _cityName = cityName;
    notifyListeners();
  }

  set districtName(String districtName) {
    _districtName = districtName;
    notifyListeners();
  }

  set gender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  set detailAddress(String detailAddress) {
    _detailAddress = detailAddress;
    notifyListeners();
  }

  set clientId(int id) {
    _clientId = id;
    notifyListeners();
  }

  set tel(String tel) {
    _tel = tel;
    notifyListeners();
  }

  set addressId(String id) {
    _addressId = id;
    notifyListeners();
  }

  set goodsId(int id) {
    _goodsId = id;
    notifyListeners();
  }

  set isForSelectedClient(bool flag) {
    _isForSelectedClient = flag;

    notifyListeners();
  }

  void clearClientInfo() {
    _tel = '';
    _gender = '';
    _provinceId = '';
    _cityId = '';
    _districtId = '';
    _detailAddress = '';
    notifyListeners();
  }

  void setAddress(String provinceName, String cityName, String districtName) {
    _provinceName = provinceName;
    _cityName = cityName;
    _districtName = districtName;
    notifyListeners();
  }

  void setAddressId(String provinceId, String cityId, String districtId) {
    _provinceId = provinceId;
    _cityName = cityId;
    _districtName = districtId;
    notifyListeners();
  }

  set provinceId(String id) {
    _provinceId = id;
    notifyListeners();
  }

  set cityId(String id) {
    _cityId = id;
    notifyListeners();
  }

  set districtId(String id) {
    _districtId = id;
    notifyListeners();
  }

  void saveClientInfo(
      {String name,
      String tel,
      String address,
      int clientId,
      String gender,
      String provinceId,
      String cityId,
      String districtId,
      String provinceName,
      String cityName,
      String addressId,
      String districtName}) {
    Application.sp.setString('clientName', name);
    Application.sp.setString('clientTel', tel);
    Application.sp.setString('clientGender', gender);
    Application.sp.setString('clientProvinceId', provinceId);
    Application.sp.setString('clientCityId', cityId);
    Application.sp.setString('clientDistrictId', districtId);
    Application.sp.setString('clientProvinceName', provinceName);
    Application.sp.setString('clientCityName', cityName);
    Application.sp.setString('clientDistrictName', districtName);
    Application.sp.setString('clientAddress', address);
    Application.sp.setInt('clientId', clientId);
    Application.sp.setString('clientAddressId', addressId);
  }

  initClientInfo() {
    _name = Application.sp.get('clientName');
    _tel = Application.sp.get('clientTel');
    _provinceId = Application.sp.get('clientProvinceId');
    _cityId = Application.sp.get('clientCityId');
    _districtName = Application.sp.get('clientDistrictId');
    _provinceName = Application.sp.get('clientProvinceName');
    _cityName = Application.sp.get('clientCityName');
    _districtName = Application.sp.get('clientDistrictName');
    _clientId = Application.sp.get('clientId');
    _gender = Application.sp.get('clientGender');
    _addressId = Application.sp.get('clientAddressId');
  }
}
