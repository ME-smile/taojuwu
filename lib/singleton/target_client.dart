class TargetClient {
  TargetClient._internal();

  int clientId;
  String clientName;

  String tel;
  String get address =>
      '${_instance.provinceName ?? ''}${_instance.cityName ?? ''}${_instance.districtName ?? ''}${_instance.detailAddress ?? ''}';
  String detailAddress = '';
  int gender; //1 表示男 2 表示女

  int addressId;

  String districtName = '';
  String cityName = '';
  String provinceName = '';
  bool get hasSelectedClient => clientId != null;

  static TargetClient _instance = TargetClient._internal();
  factory TargetClient() {
    return _instance;
  }
  static TargetClient get instance => _instance;

  setClientId(int id) {
    _instance.clientId = id;
  }

  setClientName(String name) {
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
  }

  saveInfo(int id, String name) {
    _instance.clientId = id;
    _instance.clientName = name;
  }

  setTel(String tel) {
    _instance.tel = tel;
  }

  setAddress(String province, String city, String district) {
    _instance.provinceName = province;
    _instance.cityName = city;
    _instance.districtName = district;
  }

  setAddressId(int id) {
    _instance.addressId = id;
  }
}
