import 'package:taojuwu/models/zy_response.dart';

class CustomerDetailModelResp extends ZYResponse<CustomerDetailModel> {
  CustomerDetailModelResp.fromMap(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid ? CustomerDetailModel.fromJson(json['data']) : null;
  }
}

class CustomerDetailModel {
  int id;
  int memberUid;
  String clientName;
  int clientType;
  String headWord;
  String clientMobile;
  int clientAge;
  int clientSex;
  String clientWx;
  int enterTime;
  int style;
  int goodsCategoryId;
  int provinceId;
  int cityId;
  int districtId;
  String detailAddress;
  int shopId;
  int createAt;
  int updateAt;
  String provinceName;
  String cityName;
  String districtName;

  String get address =>
      '${provinceName ?? ''}${cityName ?? ''}${districtName ?? ''}';
  CustomerDetailModel(
      {this.id,
      this.memberUid,
      this.clientName,
      this.clientType,
      this.headWord,
      this.clientMobile,
      this.clientAge,
      this.clientSex,
      this.clientWx,
      this.enterTime,
      this.style,
      this.goodsCategoryId,
      this.provinceId,
      this.cityId,
      this.districtId,
      this.detailAddress,
      this.shopId,
      this.createAt,
      this.updateAt,
      this.provinceName,
      this.cityName,
      this.districtName});

  CustomerDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberUid = json['member_uid'];
    clientName = json['client_name'];
    clientType = json['client_type'];
    headWord = json['head_word'];
    clientMobile = json['client_mobile'];
    clientAge = json['client_age'];
    clientSex = json['client_sex'] == 0 ? 1 : json['client_sex'];
    clientWx = json['client_wx'];
    enterTime = json['enter_time'];
    enterTime = enterTime != null ? enterTime * 1000 : enterTime;
    style = json['style'];
    goodsCategoryId = json['goods_category_id'];
    provinceId = json['province_id'];
    cityId = json['city_id'];
    districtId = json['district_id'];
    detailAddress = json['detail_address'];
    shopId = json['shop_id'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
    provinceName = json['province_name'];
    cityName = json['city_name'];
    districtName = json['district_name'];
  }
}
