import 'package:taojuwu/providers/goods_provider.dart';

class TargetOrderGoods {
  int orderGoodsId;
  GoodsProvider goodsProvider;
  bool hasConfirmMeasureData = false;
  TargetOrderGoods._internal();
  int orderId;

  String keyword; //缓存 商品列表搜索的关键字

  static TargetOrderGoods _instance = TargetOrderGoods._internal();

  bool get isMeasureOrder => _instance.orderGoodsId != null;

  factory TargetOrderGoods() {
    return _instance;
  }

  static TargetOrderGoods get instance => _instance;

  setOrderGoodsId(int id) {
    _instance.orderGoodsId = id;
  }

  setHasConfirmMeasureDataFlag(bool flag) {
    _instance.hasConfirmMeasureData = flag;
  }

  setGoodsProvider(GoodsProvider provider) {
    _instance.goodsProvider = provider;
  }

  removeProvider() {
    goodsProvider?.release();
  }

  clear() {
    _instance.orderGoodsId = null;
    _instance.hasConfirmMeasureData = false;
    _instance.orderId = null;
    _instance.keyword = null;
  }
}
