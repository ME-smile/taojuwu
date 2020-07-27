class GoodsAttr {
  String name;
  String value;
  int type;
  var id;
  bool hasSelected = false;
  GoodsAttr.fromJson(Map<String, dynamic> json) {
    name = json['attr_category'];
    value = json['attr_name'];
    type = json['type'];
    id = json['id'];
    hasSelected = value?.isNotEmpty ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'attr_category': name,
      'attr_name': value,
      'type': type,
      'id': id,
      'has_selected': hasSelected,
    };
  }
}
