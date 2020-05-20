import 'package:flutter/material.dart';
import 'package:taojuwu/models/user/customer_detail_model.dart';

class ClientProvider with ChangeNotifier {
  CustomerDetailModel clientModel;
  int _clientId;

  int _addressId;
  String _clientName;
  void clearClientInfo() {
    _clientId = null;

    _clientName = null;
    clientModel = null;

    notifyListeners();
  }
  //通过计数器标示是否更新客户

  // int _count=0;

  bool _isForSelectedClient = false;

  int get clientId => _clientId;
  String get tel => clientModel?.clientMobile ?? '';
  int get provinceId => clientModel?.provinceId ?? -1;
  int get cityId => clientModel?.cityId ?? -1;
  int get districtId => clientModel?.districtId ?? -1;
  String get provinceName => clientModel?.provinceName ?? '';
  String get cityName => clientModel?.cityName ?? '';
  String get districtName => clientModel?.districtName ?? '';
  bool get isForSelectedClient => _isForSelectedClient;
  String get detailAddress => clientModel?.detailAddress;
  int get gender => clientModel?.clientSex ?? 1;
  String get name => _clientName ?? clientModel?.clientName ?? '';
  int get addressId => _addressId;
  String get address =>
      '${provinceName ?? ''}${cityName ?? ''}${districtName ?? ''}';

  bool get hasChoosenCustomer => clientId != null;
  set name(String name) {
    _clientName = name;
    clientModel?.clientName = name;
    notifyListeners();
  }

  set provinceName(String provinceName) {
    clientModel?.provinceName = provinceName;
    notifyListeners();
  }

  set cityName(String cityName) {
    clientModel?.cityName = cityName;
    notifyListeners();
  }

  set districtName(String districtName) {
    clientModel?.districtName = districtName;
    notifyListeners();
  }

  set gender(int gender) {
    clientModel?.clientSex = gender;
    notifyListeners();
  }

  set detailAddress(String detailAddress) {
    clientModel?.detailAddress = detailAddress;
    notifyListeners();
  }

  set clientId(int id) {
    _clientId = id;
    notifyListeners();
  }

  set tel(String tel) {
    clientModel?.clientMobile = tel;
    notifyListeners();
  }

  set addressId(int id) {
    _addressId = id;
    notifyListeners();
  }

  set isForSelectedClient(bool flag) {
    _isForSelectedClient = flag;

    notifyListeners();
  }

  void setAddress(String provinceName, String cityName, String districtName) {
    notifyListeners();
  }

  void setAddressId(int provinceId, int cityId, int districtId) {
    clientModel?.provinceId = provinceId;
    clientModel?.cityId = cityId;
    clientModel?.districtId = districtId;
    notifyListeners();
  }

  set provinceId(int id) {
    clientModel?.provinceId = id;
    notifyListeners();
  }

  set cityId(int id) {
    clientModel?.cityId = id;
    notifyListeners();
  }

  set districtId(int id) {
    clientModel?.districtId = id;
    notifyListeners();
  }

  setClientModel(CustomerDetailModel model) {
    clientModel = model;
    _clientName = model?.clientName;
  }

  saveClientInfo({int clientId, int addressId, String name}) {
    _clientId = clientId;
    _addressId = addressId;
    _clientName = name;
    notifyListeners();
  }
}
