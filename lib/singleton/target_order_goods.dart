import 'package:taojuwu/models/shop/cart_list_model.dart';
import 'package:taojuwu/providers/end_product_provider.dart';
import 'package:taojuwu/providers/goods_provider.dart';

class TargetOrderGoods {
  int orderGoodsId;
  GoodsProvider goodsProvider;
  GoodsProvider cartGoodsProvider;
  EndProductProvider endProductProvider;
  bool hasConfirmMeasureData = false;
  TargetOrderGoods._internal();
  int orderId;

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

  setEndProductProvider(EndProductProvider provider) {
    endProductProvider = provider;
  }

  setGoodsProvider(GoodsProvider provider) {
    _instance.goodsProvider = provider;
  }

  setCartGoodsProvider(GoodsProvider provider) {
    _instance?.cartGoodsProvider = provider;
  }

  removeProvider() {
    goodsProvider?.release();
  }

  clear() {
    _instance.hasConfirmMeasureData = false;
    _instance.orderId = null;
  }

  GoodsAttrWrapper goodsAttrWrapper;
}
