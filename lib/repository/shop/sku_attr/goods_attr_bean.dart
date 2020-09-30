/*
 * @Description: 属性选择项的类
 * @Author: iamsmiling
 * @Date: 2020-09-28 09:14:34
 * @LastEditTime: 2020-09-29 12:03:25
 */

import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/utils/common_kit.dart';

class GoodsSkuAttrWrapperResp extends ZYResponse<GoodsSkuAttr> {
  GoodsSkuAttrWrapperResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = valid ? GoodsSkuAttr?.fromJson(json['data']) : null;
  }
}

class GoodsSkuAttr {
  int type; // 规格的类型
  String name; // 规格的名称
  List<GoodsSkuAttrBean> data; // 属性值列表
  String title; //弹框上面的标题
  bool canMultiSelect = false;

  bool hasSelectedAttr = false;
  static const Map<int, String> type2name = {
    1: '空间',
    2: '窗型',
    3: '窗纱',
    4: '工艺',
    5: '型材',
    8: '幔头',
    12: '里布',
    13: '配饰'
  };

  static const Map<int, String> type2title = {
    1: '空间选择',
    2: '窗型选择',
    3: '窗纱选择',
    4: '工艺选择',
    5: '型材更换',
    8: '幔头选择',
    12: '里布选择',
    13: '配饰选择'
  };
  GoodsSkuAttr.fromJson(Map<String, dynamic> json) {
    type = CommonKit.parseInt(json['type']);
    name = type2name[type];
    title = type2title[type];
    List list = CommonKit.parseList(json['data']);

    // 默认选中第一个
    for (int i = 0; i < list.length; i++) {
      list[i] = CommonKit.parseMap(list[i]);
      list[i]['is_checked'] = i == 0;
    }
    data = CommonKit.parseList(json['data'])
        ?.map((e) => GoodsSkuAttrBean.fromJson(e))
        ?.toList();
    canMultiSelect = type == 13; // 只有配饰为多选
  }

  String get selectedAttrName {
    if (data == null || data.isEmpty) return '';
    return data
        ?.where((element) => element.isChecked)
        ?.toList()
        ?.map((e) => e?.name)
        ?.join(',');
  }
}

class GoodsSkuAttrBean {
  int id;
  String name;
  String picture;
  double price;
  bool isChecked;
  GoodsSkuAttrBean.fromJson(Map<String, dynamic> json) {
    id = json['id'].runtimeType == int ? json['id'] : int.parse(json['id']);
    name = json['name'] ?? '';
    picture = json['picture'] ?? '';
    price = CommonKit.parseDouble(json['price']);
    isChecked = json['is_checked'] ?? false;
  }
}
