/*
 * @Description: 窗帘属性状态
 * @Author: iamsmiling
 * @Date: 2020-10-31 06:34:24
 * @LastEditTime: 2020-12-28 13:48:07
 */
import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';

class ProductAttrHolder {
  static List<ProductSkuAttr> _attrList = []; // 窗纱 工艺方式 型材 里布 幔头 配饰等属性
  static ProductSkuAttr _roomAttr;

  List<ProductSkuAttr> get attrList => _attrList;
  set attrList(List<ProductSkuAttr> list) {
    _attrList = list;
    print(list);
  }

  ProductSkuAttr get roomAttr => _roomAttr;

  ProductSkuAttr get sectionalbarAttr =>
      _attrList?.firstWhere((e) => e.type == 5, orElse: () => null);

  set roomAttr(ProductSkuAttr attr) {
    _roomAttr = attr;
    print(attr);
  }

  static List<ProductSkuAttr> copy() {
    return _attrList?.map((e) => ProductSkuAttr.fromJson(e?.toMap()))?.toList();
  }

  Future fetchProductAttrsData() async {
    if (!CommonKit.isNullOrEmpty(_attrList)) return;
    await fetchAttrsData();
    await fetchRoomAttrData();
  }

  static Future<List<ProductSkuAttr>> fetchAttrsData() async {
    List<Map<String, dynamic>> args = [
      {
        'type': 3,
        'name': '窗纱',
        'title': '窗纱选择',
      },
      {'type': 4, 'name': '工艺', 'title': '工艺选择'},
      {'type': 5, 'name': '型材', 'title': '型材更换'},
      {'type': 8, 'name': '幔头', 'title': '幔头选择'},
      {'type': 12, 'name': '里布', 'title': '里布选择'},
      {'type': 13, 'name': '配饰', 'title': '配饰选择'}
    ];

    List<Future<ProductSkuAttrWrapperResp>> futures = args.map((e) {
      // e.addAll({
      //   'parts_type': measureData?.partsType,
      //   'goods_id': goodsId,
      // });
      return OTPService.skuAttr(params: e)
          .then((ProductSkuAttrWrapperResp response) {
        if (response?.valid == true) {
          _attrList?.add(response?.data);
        }
      }).catchError((err) => err);
    }).toList();
    await Future.wait(futures);
    _attrList?.sort((ProductSkuAttr a, ProductSkuAttr b) => a.type - b.type);
    return _attrList;
  }

  static Future fetchRoomAttrData() {
    return OTPService.skuAttr(
            params: {'type': 1, 'name': '空间', 'title': '空间选择'})
        .then((ProductSkuAttrWrapperResp response) {
      if (response?.valid == true) {
        _roomAttr = response?.data;
      }
    }).catchError((err) => err);
  }
}
