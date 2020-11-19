/*
 * @Description: 商品规格数据模型
 * @Author: iamsmiling
 * @Date: 2020-10-23 13:52:10
 * @LastEditTime: 2020-11-13 10:27:37
 */
import 'package:taojuwu/utils/common_kit.dart';

class ProductSpecBean {
  String name;
  String id;
  String type;
  List<ProductSpecOptionBean> options;
  ProductSpecBean.fromJson(Map<String, dynamic> json) {
    name = json['spec_name'];
    id = json['spec_id'];
    options = CommonKit.parseList(json['value'])
        .map((e) => ProductSpecOptionBean.fromJson(e))
        ?.toList();
  }

  ProductSpecOptionBean get selectedOption =>
      options?.firstWhere((element) => element?.isSelected, orElse: () => null);

  String get selectedOptionsName => selectedOption?.name ?? '';
}

class ProductSpecOptionBean {
  String specId;
  String optionId;
  String desc;
  String name;
  bool isSelected;
  ProductSpecOptionBean.fromJson(Map<String, dynamic> json) {
    specId = json['spec_id'];
    optionId = json['spec_value_id'];
    desc = json['spec_name'];
    name = json['spec_value_name'];
    isSelected = false;
  }

  ProductSpecOptionBean.defaultOption(Map<String, dynamic> json) {
    specId = json['spec_id'];
    optionId = json['spec_value_id'];
    desc = json['spec_name'];
    name = json['spec_value_name'];
    isSelected = json['is_selected'];
  }
}
