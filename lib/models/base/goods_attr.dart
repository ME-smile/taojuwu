class GoodsAttr {
  String name;
  String value;

  GoodsAttr.fromJson(Map<String, dynamic> json) {
    name = json['attr_category'];
    value = json['attr_name'];
  }
}
