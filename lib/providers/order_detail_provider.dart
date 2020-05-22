import 'package:flutter/material.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/pages/order/utils/order_kit.dart';

class OrderDetailProvider with ChangeNotifier {
  final OrderDetailModel model;

  bool _isMinus = true;

  bool get isMinus => _isMinus;
  set isMinus(bool flag) {
    _isMinus = flag;
    notifyListeners();
  }

  int get clientId => model?.clientId;
  bool get hasUnselectedGoods => unselectedGoodsNum > 0;
  int get unselectedGoodsNum => model?.unselectedGoodsNum;
  double _deltaPrice;
  double get tailPrice =>
      model?.tailMoney != null ? double.parse(model?.tailMoney) : 0.0;

  bool get hasRemark => changePriceRemark?.isNotEmpty == true;

  double get afterChangeTailMoney {
    if (_deltaPrice == null) {
      return tailPrice;
    }
    return tailPrice + deltaPrice;
  }

  double get afterChangeOriginPrice {
    if (_deltaPrice == null) {
      return originPrice;
    }
    return originPrice + deltaPrice;
  }

  String get changePriceRemark => model?.adjustMoneyRemark;
  double get originPrice => model?.orderEstimatedPrice != null
      ? double.parse(model?.orderEstimatedPrice)
      : 0.0;
  double get depositPrice => model?.orderEarnestMoney != null
      ? double.parse(model?.orderEarnestMoney)
      : 0.0;
  double get deltaPrice => _deltaPrice ?? adjustMoney;
  double get adjustMoney =>
      model?.adjustMoney != null ? double.parse(model?.adjustMoney) : 0.0;
  bool get isMeasureOrder => model?.isMeasureOrder ?? false;
  bool get haNotsSelectedProduct => model?.haNotsSelectedProduct ?? false;
  bool get hasAudited => model?.hasAudited ?? false;
  bool get hasMeasured => model?.hasMeasured ?? false;
  bool get hasInstalled => model?.hasInstalled ?? false;
  bool get hasProducted => model?.hasProducted ?? false;
  bool get hasScheduled => model?.hasScheduled ?? false;
  bool get showSelectedProductButton =>
      hasMeasured &&
      isMeasureOrder &&
      haNotsSelectedProduct == true &&
      hasScheduled;

  bool get canEditPrice => model?.orderStatus == 4;
  bool get hasFinished => model?.hasFinished ?? false;

  bool get showButton => [1, 2, 3, 6, 7, 8, 14].contains(model?.orderStatus);
  set deltaPrice(double price) {
    _deltaPrice = price;
    notifyListeners();
  }

  set changePriceRemark(String remark) {
    model?.adjustMoneyRemark = remark;
    notifyListeners();
  }

  OrderDetailProvider({this.model});

  List<OrderGoods> get orderGoods => model?.orderGoods ?? [];

  bool get canCancelOrder {
    int len =
        orderGoods?.where((item) => item?.canCancel == false)?.toList()?.length;
    return len == 0 && model?.orderStatus != 0;
  }

  cancelOrder(BuildContext ctx, int orderId) {
    OrderKit.cancelOrder(ctx, orderId, callback: () {
      model?.orderStatus = 0;
      notifyListeners();
    });
  }

  bool get showDeltaPrice => deltaPrice != 0;
  void cancelOrderGoods(BuildContext ctx, OrderGoods orderGoods) {
    OrderKit.cancelOrderGoods(ctx, model?.orderId, orderGoods?.orderGoodsId,
        callback: () {
      orderGoods?.refundStatus = 1;
      notifyListeners();
    }).then((response) {}).catchError((err) => err);
  }

  void editPrict(
    BuildContext ctx,
  ) {
    OrderKit.editPrice(
      ctx,
      model?.orderId ?? -1,
    );
  }
}
