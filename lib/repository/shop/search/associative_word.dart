import 'package:taojuwu/repository/zy_response.dart';

class AssociativeWordResp extends ZYResponse<AssociativeWordWrapper> {
  AssociativeWordResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid ? AssociativeWordWrapper.fromJson(json) : null;
  }
}

class AssociativeWordWrapper {
  List data;
  AssociativeWordWrapper.fromJson(Map<String, dynamic> json) {
    data = json['data'] is List ? json['data'] : [];
  }
}
