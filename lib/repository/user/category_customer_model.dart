import 'package:taojuwu/repository/zy_response.dart';

class CategoryCustomerModelListResp
    extends ZYResponse<CategoryCustomerModelListWrapper> {
  CategoryCustomerModelListResp.fromMap(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid
        ? CategoryCustomerModelListWrapper.fromJson(json['data'])
        : null;
  }
}

class CategoryCustomerModelListWrapper {
  int totalCount;
  int pageCount;
  List<CategoryCustomerModelBean> data;

  CategoryCustomerModelListWrapper(
      {this.totalCount, this.pageCount, this.data});

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

  String clientMobile;
  int clientAge;
  String clientSex;
  String clientWx;
  String enterTime;
  int style;
  String clientName;

  String goodCategory;
  CategoryCustomerModelBean(
      {this.id,
      this.clientName,
      this.clientMobile,
      this.clientAge,
      this.clientSex,
      this.clientWx,
      this.enterTime,
      this.style,
      this.goodCategory});

  CategoryCustomerModelBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientName = json['client_name'];
    clientMobile = json['client_mobile'];
    clientAge = json['client_age'];
    clientSex = json['client_sex'];
    clientWx = json['client_wx'];
    enterTime = json['enter_time'];
    style = json['style'];
    goodCategory = json['good_category'];
  }
}
