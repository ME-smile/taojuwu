class TargetClient {
  TargetClient._internal();

  int clientId;
  String clientName;

  String tel;
  String get address =>
      '${provinceName ?? ''}${cityName ?? ''}${districtName ?? ''}$detailAddress';
  String detailAddress;
  int gender; //1 表示男 2 表示女

  int addressId;

  String districtName;
  String cityName;
  String provinceName;
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
  }

  saveInfo(int id, String name) {
    _instance.clientId = id;
    _instance.clientName = name;
  }

  setTel(String tel) {
    instance.tel = tel;
  }

  setAddress(String province, String city, String district) {
    provinceName = province;
    cityName = city;
    districtName = district;
  }

  setAddressId(int id) {
    addressId = id;
  }
}
