class ClientInfo {
  String tel;
  int id;
  String name;

  // 地区相关
  String districtName;
  String cityName;
  String provinceName;
  int provinceId;
  int cityId;
  int districtId;

  // addressId 不为空说明已经填写收货地址
  int addressId;
  // 是否已经选择客户
  bool get hasSelectedCient => id != null;

  bool get hasEditedAddress => addressId != null;

  factory ClientInfo() => instance;

  ClientInfo._singleton();

  static ClientInfo get instance {
    if (instance == null) return ClientInfo._singleton();
    return instance;
  }
}
