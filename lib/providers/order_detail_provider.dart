import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/pages/order/utils/order_kit.dart';

class OrderDetailProvider with ChangeNotifier {
  OrderDetailModel model;
  bool _isMinus = true;

  bool get isMinus => _isMinus;
  set isMinus(bool flag) {
    _isMinus = flag;
    notifyListeners();
  }

  int get clientId => model?.clientId;
  String get clientName => model?.clientName;
  bool get hasUnselectedGoods => unselectedGoodsNum > 0;
  int get unselectedGoodsNum => model?.unselectedGoodsNum;
  double _deltaPrice;
  double get tailPrice =>
      model?.tailMoney != null ? double.parse(model?.tailMoney) : 0.0;

  bool get hasRemark => changePriceRemark?.isNotEmpty == true;
  bool get isWaitingToInstall => model?.isWaitingToInstall;

  bool get isWaitingToShipOrReceive => model?.isWaitingToShipOrReceive;
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

  bool get hasEditPrice => deltaPrice != 0;
  double get adjustMoney =>
      model?.adjustMoney != null ? double.parse(model?.adjustMoney) : 0.0;
  bool get isMeasureOrder => model?.isMeasureOrder ?? false;
  bool get hasNotsSelectedProduct => model?.haNotsSelectedProduct ?? false;
  bool get hasAudited => model?.hasAudited ?? false;
  bool get hasMeasured => model?.hasMeasured ?? false;
  bool get hasInstalled => model?.hasInstalled ?? false;
  bool get hasProducted => model?.hasProducted ?? false;
  bool get hasScheduled => model?.hasScheduled ?? false;

  bool get showSelectedProductButton =>
      hasMeasured &&
      isMeasureOrder &&
      hasNotsSelectedProduct == true &&
      hasScheduled;

  bool get canEditPrice => model?.orderStatus == 4;
  bool get hasFinished => model?.hasFinished ?? false;
  bool get hasCanceled => model?.hasCanceled;
  bool get showButton =>
      [1, 2, 3, 6, 7, 8, 14, 15].contains(model?.orderStatus);
  bool get isWaitingToship => model?.isWaitingToship;
  bool get hasShipped => model?.hasShipped;
  set deltaPrice(double price) {
    _deltaPrice = price;
    notifyListeners();
  }

  set changePriceRemark(String remark) {
    model?.adjustMoneyRemark = remark;
    notifyListeners();
  }

  OrderDetailProvider({
    this.model,
  });

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

  void cancelOrderGoods(BuildContext ctx, OrderGoods orderGoods) async {
    // bool flag = false;
    // if (Platform.isAndroid) {
    //   await showDialog(
    //       context: ctx,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: Text(
    //             '您确定要取消该商品',
    //             textAlign: TextAlign.center,
    //           ),
    //           content: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: <Widget>[
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: <Widget>[
    //                   ZYOutlineButton('取消', () {
    //                     flag = false;
    //                     Navigator.of(context).pop();
    //                   }),
    //                   SizedBox(
    //                     width: 40,
    //                   ),
    //                   ZYRaisedButton('确定', () {
    //                     flag = true;
    //                     Navigator.of(context).pop();
    //                   })
    //                 ],
    //               )
    //             ],
    //           ),
    //         );
    //       });
    // } else {
    //   showCupertinoDialog(
    //       context: ctx,
    //       builder: (BuildContext context) {
    //         return CupertinoAlertDialog(
    //           title: Text(
    //             '您确定要取消该商品',
    //           ),
    //           actions: <Widget>[
    //             CupertinoDialogAction(
    //               child: Text('取消'),
    //               onPressed: () {
    //                 flag = false;
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //             CupertinoDialogAction(
    //               child: Text('确认'),
    //               onPressed: () {
    //                 flag = true;
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //           ],
    //         );
    //       });
    // }
    // if (flag == false) return;
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
