/*
 * @Description: 属性选择项的类
 * @Author: iamsmiling
 * @Date: 2020-09-28 09:14:34
 * @LastEditTime: 2021-01-14 10:46:11
 */

import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/utils/common_kit.dart';

class ProductSkuAttrWrapperResp extends ZYResponse<ProductSkuAttr> {
  ProductSkuAttrWrapperResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = valid ? ProductSkuAttr?.fromJson(json['data']) : null;
  }
}

class ProductSkuAttr {
  int type; // 规格的类型
  String name; // 规格的名称
  List<ProductSkuAttrBean> data; // 属性值列表
  String title; //弹框上面的标题
  bool canMultiSelect = false;

  ProductSkuAttr();
  ProductSkuAttr copy() {
    ProductSkuAttr obj = ProductSkuAttr();
    obj.type = type;
    obj.name = name;
    obj.data = data
            ?.map((e) => e?.toMap())
            ?.toList()
            ?.map((e) => ProductSkuAttrBean.fromJson(e))
            ?.toList() ??
        [];
    obj.title = title;
    obj.canMultiSelect = canMultiSelect;

    return obj;
  }
  // Map<int, String> type2name = {
  //   1: '空间',
  //   2: '窗型',
  //   3: '窗纱',
  //   4: '工艺',
  //   5: '型材',
  //   8: '幔头',
  //   12: '里布',
  //   13: '配饰'
  // };

  // Map<int, String> type2title = {
  //   1: '空间选择',
  //   2: '窗型选择',
  //   3: '窗纱选择',
  //   4: '工艺选择',
  //   5: '型材更换',
  //   8: '幔头选择',
  //   12: '里布选择',
  //   13: '配饰选择'
  // };
  ProductSkuAttr.fromJson(Map<String, dynamic> json) {
    type = CommonKit.parseInt(json['type']);
    // name = type2name[type];
    // title = type2title[type];
    name = json['name'];
    title = json['title'];
    List list = CommonKit.parseList(json['data']);

    // 默认选中第一个
    for (int i = 0; i < list.length; i++) {
      list[i] = CommonKit.parseMap(list[i]);
      list[i]['is_checked'] = i == 0;
    }
    data = CommonKit.parseList(json['data'])
        ?.map((e) => ProductSkuAttrBean.fromJson(e))
        ?.toList();
    canMultiSelect = type == 13; // 只有配饰为多选
  }

  String get selectedAttrName {
    if (data == null || data.isEmpty) return '';
    if (canMultiSelect) {
      return data
          ?.where((element) => element.isChecked)
          ?.toList()
          ?.map((e) =>
              e.name +
              ' ' +
              '${CommonKit.isNumNullOrZero(e.price) ? '' : '¥${e.price}'}')
          ?.join(',');
    } else {
      var e =
          data?.firstWhere((element) => element.isChecked, orElse: () => null);
      return e.name +
          ' ' +
          '${CommonKit.isNumNullOrZero(e.price) ? '' : '¥${e.price}'}';
    }
  }

  ProductSkuAttrBean get selcetedAttrBean {
    return data?.firstWhere((element) => element.isChecked, orElse: () => null);
  }

  List<ProductSkuAttrBean> get selcetedAttrBeanList {
    return data?.where((element) => element?.isChecked)?.toList() ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'name': name,
      'data': data?.map((e) => e?.toMap())?.toList(),
      'title': title,
    };
  }

  Map<String, dynamic> toJson() {
    if (type == 13) {
      return {'13': selcetedAttrBeanList?.map((e) => e?.toJson())?.toList()};
    }
    return {
      '$type': selcetedAttrBean?.toJson() ?? {'name': '', 'id': ''}
    };
  }
}

class ProductSkuAttrBean {
  int id;
  String name;
  String picture;
  double price;
  bool isChecked;
  ProductSkuAttrBean.fromJson(Map<String, dynamic> json) {
    id = CommonKit.parseInt(json['id']);
    name = json['name'] ?? '';
    picture = json['picture'] ?? '';
    price = CommonKit.parseDouble(json['price']);
    isChecked = json['is_checked'] ?? false;
  }
  Map<dynamic, dynamic> toJson() => {'name': name, 'id': id};

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
        'is_checked': isChecked,
        'price': price,
        'picture': picture
      };
}
