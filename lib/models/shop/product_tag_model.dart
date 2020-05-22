import 'package:taojuwu/models/zy_response.dart';

class TagListResp extends ZYResponse<TagBeanWrapper> {
  TagListResp.fromMap(Map<String, dynamic> json) : super.fromJson(json) {
    this.data = this.valid ? TagBeanWrapper.fromJson(json['data']) : null;
  }
}

class TagBeanWrapper {
  List<TagBean> category;
  List<TagBean> tag;
  TagBeanWrapper.fromJson(Map<String, dynamic> json) {
    if (json['category'] != null) {
      category = new List<TagBean>();
      json['category'].forEach((v) {
        category.add(new TagBean.fromJson(v));
      });
    }
    if (json['tag'] != null) {
      tag = new List<TagBean>();
      json['tag'].forEach((v) {
        tag.add(new TagBean.fromJson(v));
      });
    }
  }
}

class TagBean {
  int id;
  String name;
  bool isChecked;
  TagBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isChecked = false;
  }
}
