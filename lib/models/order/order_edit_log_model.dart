import 'package:common_utils/common_utils.dart';
import 'package:taojuwu/models/zy_response.dart';

class OrderEditLogModelResp extends ZYResponse<OrderEditLogModelWrapper> {
  OrderEditLogModelResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid ? OrderEditLogModelWrapper.fromJson(json) : null;
  }
}

class OrderEditLogModelWrapper {
  List<OrderEitLogModel> list;

  OrderEditLogModelWrapper.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      list = new List<OrderEitLogModel>();
      json['data'].forEach((v) {
        list.add(new OrderEitLogModel.fromJson(v));
      });
    }
  }
}

class OrderEitLogModel {
  String userName;
  String recordTime;
  int actionTime;
  String recordName;

  OrderEitLogModel(
      {this.userName, this.recordTime, this.actionTime, this.recordName});

  String get actionTimeStr {
    int timeStamp = (actionTime ?? 0) * 1000;
    return DateUtil.formatDateMs(timeStamp, format: 'yyyy-MM-dd HH:mm:ss');
  }

  OrderEitLogModel.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    recordTime = json['record_time'];
    actionTime = json['action_time'];
    recordName = json['record_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['record_time'] = this.recordTime;
    data['action_time'] = this.actionTime;
    data['record_name'] = this.recordName;
    return data;
  }
}
