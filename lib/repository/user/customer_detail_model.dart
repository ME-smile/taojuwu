/*
 * @Description: 
 * @Author: iamsmiling
 * @Date: 2020-10-31 13:34:35
 * @LastEditTime: 2021-02-24 16:45:03
 */
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/utils/common_kit.dart';

class CustomerDetailModelResp extends ZYResponse<CustomerDetailModel> {
  CustomerDetailModelResp.fromMap(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid ? CustomerDetailModel.fromJson(json['data']) : null;
  }
}

class CustomerDetailModel {
  int id;
  String clientName;
  String clientMobile;
  int clientAge;
  int clientSex;
  String clientWx;
  int enterTime;
  int provinceId;
  int cityId;
  int districtId;
  String detailAddress;
  int shopId;
  String provinceName;
  String cityName;
  String districtName;
  int clientType;
  String get address =>
      '${provinceName ?? ''}${cityName ?? ''}${districtName ?? ''}';
  CustomerDetailModel(
      {this.id,
      this.clientName,
      this.clientType,
      this.clientMobile,
      this.clientAge,
      this.clientSex,
      this.clientWx,
      this.enterTime,
      this.provinceId,
      this.cityId,
      this.districtId,
      this.detailAddress,
      this.shopId,
      this.provinceName,
      this.cityName,
      this.districtName});

  CustomerDetailModel.fromJson(Map<String, dynamic> json) {
    id = CommonKit.parseInt(json['id']);
    clientName = json['client_name'];
    clientType = json['client_type'];
    clientMobile = json['client_mobile'];
    clientAge = CommonKit.parseInt(json['client_age']);
    clientSex = CommonKit.parseInt(json['client_sex']);
    clientWx = json['client_wx'];
    enterTime = json['enter_time'];
    provinceId = CommonKit.parseInt(json['province_id']);
    cityId = CommonKit.parseInt(json['city_id']);
    districtId = CommonKit.parseInt(json['district_id']);
    detailAddress = json['detail_address'];
    shopId = json['shop_id'];
    provinceName = json['province_name'];
    cityName = json['city_name'];
    districtName = json['district_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_name': clientName,
      'client_mobile': clientMobile,
      'client_age': clientAge,
      'client_sex': clientSex,
      'client_wx': clientWx,
      'enter_time': enterTime,
      'province_id': provinceId,
      'city_id': cityId,
      'district_id': districtId,
      'shopId': shopId,
      'detail_address': detailAddress
    };
  }
}
