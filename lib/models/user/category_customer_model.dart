import 'package:taojuwu/models/zy_response.dart';

class CategoryCustomerModelListResp
    extends ZYResponse<CategoryCustomerModelListWrapper> {
  CategoryCustomerModelListResp.fromMap(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data =
        this.valid ? CategoryCustomerModelListWrapper.fromJson(json['data']) : null;
  }
}

class CategoryCustomerModelListWrapper {
  int totalCount;
  int pageCount;
  List<CategoryCustomerModelBean> data;

   CategoryCustomerModelListWrapper({this.totalCount, this.pageCount, this.data});

  CategoryCustomerModelListWrapper.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    pageCount = json['page_count'];
    if (json['list'] != null) {
      data = new List<CategoryCustomerModelBean>();
      json['list'].forEach((v) {
        data.add(new CategoryCustomerModelBean.fromJson(v));
      });
    }
  }
}

class CategoryCustomerModelBean {
  int id;
  int memberUid;
  String clientName;
  int clientType;
  String headWord;
  String clientMobile;
  int clientAge;
  String clientSex;
  String clientWx;
  String enterTime;
  int style;
  int goodsCategoryId;
  int provinceId;
  int cityId;
  int districtId;
  String detailAddress;
  int shopId;
  int createAt;
  int updateAt;
  String goodCategory;
  CategoryCustomerModelBean(
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
      this.goodCategory});

    CategoryCustomerModelBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberUid = json['member_uid'];
    clientName = json['client_name'];
    clientType = json['client_type'];
    headWord = json['head_word'];
    clientMobile = json['client_mobile'];
    clientAge = json['client_age'];
    clientSex = json['client_sex'];
    clientWx = json['client_wx'];
    enterTime = json['enter_time'];
    style = json['style'];
    goodsCategoryId = json['goods_category_id'];
    provinceId = json['province_id'];
    cityId = json['city_id'];
    districtId = json['district_id'];
    detailAddress = json['detail_address'];
    shopId = json['shop_id'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
    goodCategory = json['good_category'];
  }

}
