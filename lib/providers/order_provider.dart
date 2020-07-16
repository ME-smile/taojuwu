import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/models/order/order_cart_goods_model.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';

import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/providers/order_detail_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/time_period_picker.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

import 'user_provider.dart';

class OrderProvider with ChangeNotifier {
  List<OrderCartGoods> orderGoods;

  OrderGoods _curOrderGoods;
  int _orderId;

  BuildContext context;

  double get totalPrice {
    double sum = 0.00;

    orderGoods?.forEach((item) {
      double price = item?.totalPrice is String
          ? double.parse(item?.totalPrice ?? '0.00')
          : item?.totalPrice;

      sum += price ?? 0.00;
    });
    return sum;
  }

  OrderProvider(this.context, {this.orderGoods});
  bool get hasOrderGoodsId => orderGoodsId != null;
  int get orderGoodsId => _curOrderGoods?.orderGoodsId;
  int get orderId => _orderId;

  int get addressId => TargetClient.instance.addressId;
  String get clientUid => '${TargetClient.instance.clientId}';
  String get shopId => '${Provider.of<UserProvider>(context, listen: false)}';
  String get goodsSkuListText =>
      orderGoods
          ?.map((item) =>
              '${item?.skuId ?? ''}:${item?.count ?? ''}:${item?.isShade ?? ''}:${item?.totalPrice ?? ''}')
          ?.toList()
          ?.join(',') ??
      '';
  String get cartId =>
      orderGoods?.map((item) => item.cartId)?.toList()?.join(',');
  String get dy => '${TargetOrderGoods.instance.goodsProvider?.dyCMStr ?? ''}';
  List<String> get attr => orderGoods?.map((item) => item.attr)?.toList() ?? [];

  int get totalCount => orderGoods?.length ?? 0;

  TimePeriod _measureTime;
  String _installTime;
  String _orderMark;
  String _deposit;
  String _windowNum;

  String get measureTimeStr => _measureTime == null
      ? '时间'
      : '${DateUtil.formatDate(_measureTime?.dateTime, format: 'yyyy年MM月dd日') ?? ''} ${_measureTime?.period ?? ''}' ??
          '';
  String get installTime => _installTime;
  String get orderMark => _orderMark;
  String get deposit => _deposit;
  String get windowNum => _windowNum;

  OrderGoods get curOrderGoods => _curOrderGoods;

  set orderMark(String orderMark) {
    _orderMark = orderMark;
    notifyListeners();
  }

  // set dy(String h) {
  //   _orderGoodsMeasure?.verticalGroundHeight = h;
  //   notifyListeners();
  // }

  // set openMode(String mode) {
  //   if (_orderGoodsMeasure?.openType == mode) return;
  //   if (_oldOpenMode == null) {
  //     _oldOpenMode = _orderGoodsMeasure?.openType;
  //   }
  //   _orderGoodsMeasure?.openType = mode;
  //   notifyListeners();
  // }

  set curOrderGoods(OrderGoods orderGoods) {
    _curOrderGoods = orderGoods;
    notifyListeners();
  }

  setHasSelectedGoods(OrderGoods orderGoods, bool flag) {
    orderGoods?.isSelectedGoods = 1;
    notifyListeners();
  }

  set windowNum(String n) {
    _windowNum = n;
    notifyListeners();
  }

  set orderId(int id) {
    _orderId = id;
    notifyListeners();
  }

  set deposit(String amount) {
    _deposit = amount;
    notifyListeners();
  }

  void initMeasureTime(TimePeriod timePeriod) {
    _measureTime = timePeriod;
  }

  set measureTime(TimePeriod timePeriod) {
    _measureTime = timePeriod;
    notifyListeners();
  }

  set installTime(String date) {
    _installTime = date;
    notifyListeners();
  }

  bool beforeCreateOrder(BuildContext context, {Function callback}) {
    if (TargetClient.instance?.hasSelectedClient == false) {
      CommonKit.showInfo('请选择客户');
      return false;
    }
    if (addressId == null) {
      CommonKit.showInfo('请填写收货人');
      return false;
    }
    if (measureTimeStr == null || measureTimeStr?.trim()?.isEmpty == true) {
      CommonKit.showInfo('请选择上门量尺意向时间');
      return false;
    }
    if (installTime == null || installTime?.trim()?.isEmpty == true) {
      CommonKit.showInfo('请选择客户意向安装时间');
      return false;
    }
    if (deposit == null || deposit?.trim()?.isEmpty == true) {
      CommonKit.showInfo('请输入定金');
      return false;
    }
    return true;
  }

  void createOrder(BuildContext ctx,
      {Function beforeCallback, Function afterCallback}) {
    // LogUtil.e({
    //   'order_earnest_money': deposit,
    //   'client_uid': clientUid,
    //   'shop_id': shopId,
    //   'cart_id': cartId,
    //   'measure_id':
    //       '${orderGoods?.map((item) => item.measureId)?.toList()?.join(',')}',
    //   'measure_time': measureTimeStr,
    //   'install_time': installTime,
    //   'order_remark': orderMark,
    //   'wc_attr': jsonEncode(attr),
    //   'data': '''{
    //       "order_type": '1',
    //       "point": "0",
    //       "pay_type": "10",
    //       "shipping_info": {"shipping_type": "1", "shipping_company_id": "0"},
    //       "address_id": "$addressId",
    //       "coupon_id": "0",
    //       "order_tag": "2",
    //       "goods_sku_list": "$goodsSkuListText"
    //     }'''
    // });
    if (!beforeCreateOrder(ctx)) return;
    if (beforeCallback != null) {
      beforeCallback();
    }
    OTPService.createOrder(
      params: {
        'order_earnest_money': deposit,
        'client_uid': clientUid,
        'shop_id': shopId,
        'cart_id': cartId,
        'vertical_ground_height': dy,
        'measure_id':
            '${orderGoods?.map((item) => item.measureId)?.toList()?.join(',')}',
        'measure_time': measureTimeStr,
        'install_time': installTime,
        'order_remark': orderMark,
        'wc_attr': jsonEncode(attr),
        'data': '''{
          "order_type": 1,
          "point": "0",
          "pay_type": "10",
          "shipping_info": {"shipping_type": "1", "shipping_company_id": "0"},
          "address_id": "$addressId",
          "coupon_id": "0",
          "order_tag": "2",
          "goods_sku_list": "$goodsSkuListText"
        }'''
      },
    ).then((ZYResponse response) {
      if (response.valid) {
        RouteHandler.goOrderCommitSuccessPage(ctx, clientUid);
        clear();
      } else {
        CommonKit.showErrorInfo(response?.message ?? '');
      }
    }).catchError((err) {
      return err;
    }).whenComplete(() {
      if (afterCallback != null) afterCallback();
    });
  }

  clear() {
    TargetClient.instance.clear();
    _measureTime = null;
    _installTime = null;
    _orderMark = null;
    _deposit = null;
    _windowNum = null;
  }

  void createMeasureOrder(BuildContext ctx) {
    if (!beforeCreateOrder(ctx)) return;
    OTPService.createMeasureOrder(params: {
      'client_uid': clientUid,
      'measure_time': measureTimeStr,
      'install_time': installTime,
      'order_earnest_money': deposit,
      'order_remark': orderMark,
      'shop_id': shopId,
      'order_window_num': windowNum,
    }).then((ZYResponse response) {
      if (response.valid) {
        RouteHandler.goOrderCommitSuccessPage(ctx, clientUid, orderType: 2);
        TargetClient.instance.clear();
      } else {
        CommonKit.showErrorInfo(response?.message ?? '');
      }
    }).catchError((err) => err);
  }

  // i标示orderGoods中的第i个商品
  void initMeasureOrder(
    OrderDetailProvider provider,
    BuildContext context, {
    OrderGoods orderGoods,
  }) {
    // _orderGoodsMeasure = orderGoods?.orderGoodsMeasure;
    // goodsProvider?.measureData = _orderGoodsMeasure;
    // goodsProvider?.initSize(_orderGoodsMeasure
    //     // _orderGoodsMeasure?.width ?? '0.00',
    //     // _orderGoodsMeasure?.height ?? '0.00',
    //     // _orderGoodsMeasure?.verticalGroundHeight ?? '0.00',
    //     // installMode: _orderGoodsMeasure?.installType ?? '顶装满墙',
    //     // openMode: _orderGoodsMeasure?.openType ?? '整体对开'
    //     // _orderGoodsMeasure?.
    //     );

    RouteHandler.goCurtainMallPage(context);
  }

  Future showSelectProductDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: ,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ZYAssetImage(
                  'success@2x.png',
                  width: UIKit.width(160),
                  height: UIKit.height(160),
                ),
                Text('选品成功'),
                Text('记得提醒客户及时支付尾款哦～'),
                ZYRaisedButton('查看订单', () {
                  RouteHandler.goOrderDetailPage(
                    context,
                    orderId,
                  );
                  Navigator.of(context).pop();
                })
              ],
            ),
          );
        });
  }
}
