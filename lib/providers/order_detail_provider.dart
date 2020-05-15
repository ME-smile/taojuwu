import 'package:flutter/material.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/pages/order/utils/order_kit.dart';

class OrderDetailProvider with ChangeNotifier {
  final OrderDetailModel model;
  double _deltaPrice = 0.00;
  bool _isMinus = true;

  bool get isMinus => _isMinus;
  set isMinus(bool flag) {
    _isMinus = flag;
    notifyListeners();
  }

  bool get isMeasureOrder => model?.isMeasureOrder ?? false;
  bool get haNotsSelectedProduct => model?.haNotsSelectedProduct ?? false;
  bool get hasAudited => model?.hasAudited ?? false;
  bool get hasMeasured => model?.hasMeasured ?? false;
  bool get hasInstalled => model?.hasInstalled ?? false;
  bool get hasProducted => model?.hasProducted ?? false;
  bool get showSelectedProductButton => hasMeasured && isMeasureOrder;
  double get deltaPrice => _deltaPrice;
  bool get canEditPrice => model?.orderStatus == 4;
  bool get hasFinished => model?.hasFinished ?? false;

  bool get showButton =>
      [1, 2, 3, 6, 7, 8, 14, 15].contains(model?.orderStatus);
  set deltaPrice(double price) {
    _deltaPrice = price;
    notifyListeners();
  }

  OrderDetailProvider({this.model});

  List<OrderGoods> get orderGoods => model?.orderGoods ?? [];

  bool get canCancelOrder {
    int len =
        orderGoods?.where((item) => item?.canCancel == false)?.toList()?.length;
    return len == 0 && model?.orderStatus != 15;
  }

  cancelOrder(BuildContext ctx, int orderId) {
    OrderKit.cancelOrder(ctx, orderId, callback: () {
      model?.orderStatus = 15;
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
