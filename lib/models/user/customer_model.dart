import 'package:azlistview/azlistview.dart';
import 'package:taojuwu/models/zy_response.dart';

class CustomerModelListResp extends ZYResponse<CustomerModelWrapper> {
  CustomerModelListResp.fromMap(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid ? CustomerModelWrapper.fromJson(json['data']) : null;
  }
}

class CustomerModelWrapper {
  int totalCount;
  int pageCount;
  int status0;
  int status1;
  int status2;
  int status3;
  List<CustomerModelBean> data;

  CustomerModelWrapper(
      {this.totalCount,
      this.pageCount,
      this.status0,
      this.status1,
      this.status2,
      this.status3,
      this.data});
  CustomerModelWrapper.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    pageCount = json['page_count'];
    status0 = json['status_0'];
    status1 = json['status_1'];
    status2 = json['status_2'];
    status3 = json['status_3'];
    if (json['list'] != null) {
      data = new List<CustomerModelBean>();
      int index = 0;
      json['list'].forEach((v) {
        v['index'] = index;
        data.add(new CustomerModelBean.fromJson(v));
        index++;
      });
    }
  }
}

class CustomerModelBean extends ISuspensionBean {
  int index;
  int id;
  String clientName;
  String headWord;
  String namePinyin;
  CustomerModelBean(
      {this.index,
      this.id,
      this.clientName,
      this.headWord,
      this.namePinyin: ''});

  CustomerModelBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientName = json['client_name'];
    headWord = json['head_word'];
    index = json['index'];
  }

  @override
  String getSuspensionTag() {
    return headWord;
  }
}
