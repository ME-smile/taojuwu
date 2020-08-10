import 'package:taojuwu/models/zy_response.dart';

class UserProtocalModelResp extends ZYResponse<UserProrocalModel> {
  UserProtocalModelResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid ? UserProrocalModel.fromJson(json['data']) : null;
  }
}

class UserProrocalModel {
  String title;
  String content;
  UserProrocalModel.fromJson(Map<String, dynamic> json) {
    this.title = json['title'];
    this.content = json['content'];
  }
}
