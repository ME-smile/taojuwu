/*
 * @Description: 窗帘商品测装数据持有
 * @Author: iamsmiling
 * @Date: 2020-10-30 13:54:51
 * @LastEditTime: 2020-10-31 07:51:03
 */
import 'package:taojuwu/repository/order/order_detail_model.dart';

class MeasureDataHolder {
  static OrderGoodsMeasureData _measureData = OrderGoodsMeasureData();

  OrderGoodsMeasureData get measureData => _measureData;

  bool get hasSetSzie => _measureData?.hasSetSize;

  set measureData(OrderGoodsMeasureData data) {
    _measureData = data;
    print(data);
  }

  static OrderGoodsMeasureData copy() {
    return OrderGoodsMeasureData(
        heightCM: _measureData?.heightCM ?? 265.0,
        widthCM: _measureData?.widthCM ?? 300.0,
        deltaYCM: _measureData?.deltaYCM ?? 0.0);
  }
}
