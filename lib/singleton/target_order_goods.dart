class TargetOrderGoods {
  int orderGoodsId;
  bool hasConfirmMeasureData = false;
  TargetOrderGoods._internal();

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
    hasConfirmMeasureData = flag;
  }

  clear() {
    _instance.orderGoodsId = null;
  }
}
