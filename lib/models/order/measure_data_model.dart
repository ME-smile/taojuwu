import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/models/zy_response.dart';

import 'order_model.dart';

class MeasureDataModelResp extends ZYResponse<MeasureDataModelData> {
  MeasureDataModelResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid ? MeasureDataModelData.fromJson(json['data']) : null;
  }
}

class MeasureDataModelData {
  List<OrderProductAttrWrapper> wcAttr;
  OrderGoodsMeasure measureData;
  ClientInfo clientInfo;

  MeasureDataModelData.fromJson(Map<String, dynamic> json) {
    Map map = json['wc_attr'];

    List<Map<String, dynamic>> wrapper = [];
    map?.forEach((key, val) {
      Map<String, dynamic> tmp = {};
      tmp['attr_name'] = Constants.ATTR_MAP[int.parse('$key')];
      tmp['attr'] = val is List ? val : [val];
      wrapper.add(tmp);
    });

    wcAttr =
        wrapper.map((item) => OrderProductAttrWrapper.fromJson(item)).toList();
    measureData = OrderGoodsMeasure.fromJson(json['order_goods_measure']);
    clientInfo = ClientInfo.fromJson(json['client_info']);
  }
}

class ClientInfo {
  int id;
  String cleintName;

  ClientInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cleintName = json['client_name'];
  }
}
