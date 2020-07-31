import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/models/order/order_model.dart';

import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/pages/order/order_detail_page.dart';
import 'package:taojuwu/pages/order/widgets/aftersale_button.dart';
import 'package:taojuwu/pages/order/widgets/cancel_order_button.dart';
import 'package:taojuwu/pages/order/widgets/cancel_order_goods_button.dart';
import 'package:taojuwu/pages/order/widgets/preview_delivery_info_button.dart';
import 'package:taojuwu/pages/order/widgets/remind_button.dart';
import 'package:taojuwu/pages/order/widgets/select_product_button.dart';

import 'package:taojuwu/providers/order_detail_provider.dart';

import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'package:taojuwu/utils/ui_kit.dart';

import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_outline_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class OrderKit {
  static Future cancelOrder(BuildContext ctx, int orderId,
      {Function callback}) async {
    String why = '';
    String reason = '';

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: ctx,
          useRootNavigator: false,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('您确定要取消订单？'),
              content: Column(
                children: <Widget>[
                  CupertinoTextField(
                    onChanged: (String text) {
                      why = text;
                    },
                    placeholder: '请概述您需要取消订单的原因',
                  ),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    // Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('确定'),
                  onPressed: () async {
                    reason = why;

                    sendCancelOrderRequest(context, {
                      'order_id': orderId,
                      'order_close_reason': reason
                    }).then((_) {
                      if (callback != null) {
                        callback();
                      }
                      Navigator.of(context).pop();
                    }).catchError((err) => err);
                  },
                )
              ],
            );
          });
    }
    if (Platform.isAndroid) {
      showDialog(
          context: ctx,
          barrierDismissible: false,
          useRootNavigator: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                '您确定要取消订单？',
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 36,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: TextField(
                        onChanged: (String text) {
                          why = text;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.symmetric(vertical: 0),
                          hintText: '请概述您需要取消订单的原因(选填)',
                          filled: true,
                          fillColor: const Color(0xFFF2F2F2),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: ZYOutlineButton('取消', () {
                            Navigator.of(context).pop();
                          }),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          child: ZYRaisedButton('确认', () {
                            reason = why;

                            sendCancelOrderRequest(context, {
                              'order_id': orderId,
                              'order_close_reason': reason
                            }).then((_) {
                              if (callback != null) callback();
                              Navigator.of(context).pop();
                            }).catchError((err) => err);
                          }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          });
    }
  }

  static Future sendCancelOrderRequest(
      BuildContext context, Map<String, dynamic> params) {
    return OTPService.orderCancel(params: params).then((ZYResponse response) {
      // CommonKit.toast(context, response?.message ?? '');
      if (response?.valid == true) {
        // Navigator.of(context).pop();
      }
      return response;
    }).catchError((err) => err);
  }

  static Future remindOrder(
      BuildContext context, String title, int orderId, int status) async {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(title ?? ''),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('确定'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    sendOrderRemindRequest(
                        context, {'order_id': orderId, 'status': status});
                  },
                )
              ],
            );
          });
    }
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                title ?? '',
                textAlign: TextAlign.center,
              ),
              content: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ZYOutlineButton('取消', () {
                      Navigator.of(context).pop();
                    }),
                    SizedBox(
                      width: 40,
                    ),
                    ZYRaisedButton('确定', () {
                      sendOrderRemindRequest(
                          context, {'order_id': orderId, 'status': status},
                          callback: () {
                        Navigator.of(context).pop();
                      });
                    }),
                  ],
                ),
              ),
            );
          });
    }
  }

  static Future cancelOrderGoods(
      BuildContext context, int orderId, int orderGooodsId,
      {Function callback}) async {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(
                '您确定取消此商品?' ?? '',
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    '取消',
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('确定'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    return sendOrderGoodsCancelRequest(context, callback,
                        {'order_id': orderId, 'order_goods_id': orderGooodsId});
                  },
                )
              ],
            );
          });
    }
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                '您确定取消此商品?' ?? '',
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              content: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: ZYOutlineButton('取消', () {
                        Navigator.of(context).pop();
                      }),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Container(
                      child: ZYRaisedButton('确定', () {
                        Navigator.of(context).pop();
                        return sendOrderGoodsCancelRequest(context, callback, {
                          'order_id': orderId,
                          'order_goods_id': orderGooodsId
                        });
                      }),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  static Future editPrice(BuildContext ctx, int orderId,
      {Function callback}) async {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          String deltaMoney = '';
          String remark = '';
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              title: Text(
                '修改价格',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('金额调整:'),
                          VSpacing(20),
                          Text('说明:'),
                        ],
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SignSymbol(ctx),
                                Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFF2F2F2),
                                        borderRadius: BorderRadius.circular(5)),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: UIKit.width(10)),
                                    width: UIKit.width(160),
                                    height: UIKit.height(60),
                                    child: TextField(
                                        onChanged: (String text) {
                                          deltaMoney = text;
                                        },
                                        autofocus: true,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 8),
                                        ))),
                                Text('元')
                              ],
                            ),
                            VSpacing(20),
                            Container(
                                child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: UIKit.width(10)),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF2F2F2),
                                  borderRadius: BorderRadius.circular(5)),
                              width: UIKit.width(380),
                              height: UIKit.height(60),
                              child: TextField(
                                onChanged: (String text) {
                                  remark = text;
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                  VSpacing(40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ZYOutlineButton('取消', () {
                        Navigator.of(context).pop();
                      }),
                      SizedBox(
                        width: 50,
                      ),
                      ZYRaisedButton('确认', () {
                        // Navigator.of(context).pop();
                        OrderDetailProvider provider =
                            Provider.of(ctx, listen: false);
                        double deltaPrice = 0.0;
                        if (deltaMoney?.trim()?.isEmpty == true) {
                          return CommonKit.showInfo('请输入正确的金额');
                        }
                        deltaPrice = double.parse(deltaMoney) ?? 0;
                        if (provider?.isMinus == true) {
                          deltaPrice = -deltaPrice;
                        }
                        sendEditPriceRequest(context, {
                          'adjust_money': deltaPrice,
                          'adjust_money_remark': remark,
                          'order_id': orderId ?? -1
                        }, callback: () {
                          provider?.deltaPrice = deltaPrice;
                          provider?.changePriceRemark = remark;
                        }).then((_) {}).catchError((err) => err);
                      }),
                    ],
                  )
                ],
              ));
        });
  }

  static void sendOrderRemindRequest(
      BuildContext context, Map<String, dynamic> params,
      {Function callback}) {
    OTPService.orderRemind(params: params)
        .then((ZYResponse response) {})
        .catchError((err) => err)
        .whenComplete(() {
      if (callback != null) {
        callback();
      }
    });
  }

  static void goAfterSaleServicePage(BuildContext context, int id) {
    RouteHandler.goAfterSaleServicePage(context);
  }

  static Future sendOrderGoodsCancelRequest(
      BuildContext context, Function callback, Map<String, dynamic> params) {
    return OTPService.orderGoodsCancel(params: params)
        .then((ZYResponse response) {
      callback();
    }).catchError((err) => err);
  }

  static Future confirmToSelect(
      BuildContext context, Map<String, dynamic> params,
      {Function callback}) {
    return OTPService.confirmToSelect(params: params)
        .then((ZYResponse response) {
      if (response.valid) {
        Navigator.of(context).pop();
        CommonKit.showSuccess();
      } else {
        CommonKit.showInfo(response?.message ?? '');
      }
    }).catchError((err) => err);
  }

  static Future sendEditPriceRequest(
      BuildContext context, Map<String, dynamic> params,
      {Function callback}) async {
    OTPService.editPrice(params: params).then((ZYResponse response) {
      if (response.valid) {
        if (callback != null) callback();
        Navigator.of(context).pop();
      }
    }).catchError((err) => err);
  }

  static Widget buildOrderInfoText(
    BuildContext context,
    OrderModelData orderModelData,
  ) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    if (orderModelData?.hasSelectedProduct == true) {
      return Row(
        children: <Widget>[
          Expanded(child: SizedBox()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '尾款金额:${orderModelData?.tailMoney ?? ''}',
              ),
              Text('创建时间:${UIKit.getTimeStr(orderModelData?.createTime)}',
                  style: textTheme.caption),
            ],
          )
        ],
      );
    }
    if (orderModelData?.hasAudited == true) {
      return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        Expanded(child: SizedBox()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('客户:${orderModelData?.clientName ?? ''}'),
            Text('订单号:${orderModelData?.orderNo ?? ''}',
                style: textTheme.caption),
            Text('测量时间:${orderModelData?.measureTime ?? ''}',
                style: textTheme.caption),
            Text(
                '共${orderModelData?.orderWindowNum ?? 1}窗,已选${orderModelData?.goodsCount}件商品 合计: ￥${orderModelData?.orderEstimatedPrice}',
                style: textTheme.caption)
          ],
        )
      ]);
    }
    return Row(
      children: <Widget>[
        Expanded(child: SizedBox()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              '应收定金:${orderModelData?.orderEarnestMoneyStr ?? ''}',
            ),
            Text('创建时间:${UIKit.getTimeStr(orderModelData?.createTime)}',
                style: textTheme.caption),
          ],
        )
      ],
    );
  }

  static Widget buildButton(BuildContext context, OrderModelData model,
      {Function callback}) {
    //状态从后往前判断
    if (model?.hasFinished == true) {
      return AfterSaleButton();
    }

    // if (model?.hasProducted == true && model?.hasInstalled == false) {
    //   return RemindButton('提醒安装', () {
    //     remindOrder(context, '是否提醒安装', model?.orderId ?? -1, 3);
    //   });
    // }
    if (model?.isMeasureOrder == true) {
      // if (model?.hasAudited == false) {
      //   return RemindButton('提醒审核', () {
      //     remindOrder(context, '是否提醒审核', model?.orderId ?? -1, 3);
      //   });
      // }
      if (model?.hasNotsSelectedProduct == true) {
        return SelectedProductButton(
          callback: callback,
        );
      }
    }
    // if (model?.hasAudited == true && model?.hasMeasured == false) {
    //   return RemindButton('提醒测量', () {
    //     remindOrder(context, '是否提醒测量', model?.orderId ?? -1, 2);
    //   });
    // }
    // if (model?.hasAudited == false) {
    //   return RemindButton('提醒审核', () {
    //     remindOrder(context, '是否提醒审核', model?.orderId ?? -1, 1);
    //   });
    // }
    return VSpacing(20);
  }

  static void selectProduct(OrderDetailProvider provider, BuildContext ctx) {
    if (provider?.unselectedGoodsNum == 1) {
      return CommonKit.showInfo('您当前尚未选品，请先选品后提交');
    }
    if (provider?.hasUnselectedGoods == true) {
      if (Platform.isAndroid) {
        showDialog(
            context: ctx,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  '您还有${provider?.unselectedGoodsNum}窗未完成选品,是否确认提交?',
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ZYRaisedButton('确认提交', () async {
                          await confirmToSelect(context, {
                            'order_id': provider?.model?.orderId ?? -1
                          }, callback: () {
                            // provider?.refresh();

                            // provider?.globalKey?.currentState?.initState();
                          });

                          Navigator.of(context).pop();
                        }),
                        SizedBox(
                          width: 40,
                        ),
                        ZYOutlineButton('继续选品', () {
                          // saveSize(goodsProvider);
                          // measureData?.newVerticalGroundHeight = tmp;
                          // goodsProvider?.dy = tmp;
                          Navigator.of(context).pop();
                        })
                      ],
                    )
                  ],
                ),
              );
            });
      } else {
        showCupertinoDialog(
            context: ctx,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text('您还有${provider?.unselectedGoodsNum}窗未完成选品,是否确认提交?'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('确定'),
                    onPressed: () async {
                      await confirmToSelect(
                          context, {'order_id': provider?.model?.orderId ?? -1},
                          callback: () {});

                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('继续选品'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    } else {
      confirmToSelect(ctx, {'order_id': provider?.model?.orderId ?? -1});
    }
  }

  static List<Widget> buildBottomActionButton(
      BuildContext context, OrderDetailProvider provider) {
    if (provider?.hasCanceled == true) {
      return [];
    }

    if (provider?.hasFinished == true) {
      return [
        PreviewDeliveryInfoButton(orderId: provider?.model?.orderId),
        SizedBox(width: 20),
        AfterSaleButton(),
      ];
    }

    if (provider?.isWaitingToInstall == true) {
      return [
        RemindButton('提醒安装', () {
          remindOrder(context, '是否提醒安装', provider?.model?.orderId ?? -1, 2);
        }),
        SizedBox(width: 20),
        PreviewDeliveryInfoButton(orderId: provider?.model?.orderId),
      ];
    }

    if (provider?.hasShipped == true) {
      return [PreviewDeliveryInfoButton(orderId: provider?.model?.orderId)];
    }
    if (provider?.isWaitingToship == true) {
      return [];
    }

    if (provider?.hasMeasured == true) {
      if (provider?.isMeasureOrder == true) {
        if (provider?.hasNotsSelectedProduct == true) {
          return [
            CancelOrderButton(
              callback: () {
                provider?.cancelOrder(context, provider?.model?.orderId ?? -1);
              },
              isActive: provider?.canCancelOrder,
            ),
            SizedBox(width: 20),
            ZYOutlineButton('确定', () {
              selectProduct(provider, context);
            })
          ];
        } else {
          return [
            CancelOrderButton(
              callback: () {
                provider?.cancelOrder(context, provider?.model?.orderId ?? -1);
              },
              isActive: provider?.canCancelOrder,
            ),
          ];
        }
      }
      return [
        CancelOrderButton(
          callback: () {
            provider?.cancelOrder(context, provider?.model?.orderId ?? -1);
          },
          isActive: provider?.canCancelOrder,
        ),
      ];
    }
    if (provider?.hasProducted == true && provider?.hasInstalled == false) {
      return [
        RemindButton('提醒安装', () {
          remindOrder(context, '是否提醒安装', provider?.model?.orderId ?? -1, 3);
        })
      ];
    }
    if (provider?.hasAudited == true && provider?.hasMeasured == false) {
      return [
        CancelOrderButton(
          callback: () {
            provider?.cancelOrder(context, provider?.model?.orderId ?? -1);
          },
          isActive: provider?.canCancelOrder,
        ),
        SizedBox(width: 20),
        RemindButton('提醒测量', () {
          remindOrder(context, '是否提醒测量', provider?.model?.orderId ?? -1, 2);
        })
      ];
    }

    if (provider?.hasAudited == false) {
      return [
        CancelOrderButton(
          callback: () {
            provider?.cancelOrder(context, provider?.model?.orderId ?? -1);
          },
          isActive: provider?.canCancelOrder,
        ),
        // SizedBox(width: 20),
        // RemindButton('提醒审核', () {
        //   remindOrder(context, '是否提醒审核', provider?.model?.orderId ?? -1, 1);
        // })
      ];
    }
    return [Container()];
  }

  static Widget buildOrderGoodsActionButton(
    BuildContext context,
    OrderGoods goods,
    OrderDetailProvider provider,
  ) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          goods?.hasAlreadyCancel == true
              ? ZYOutlineButton(
                  '商品已取消',
                  null,
                  isActive: false,
                )
              : CancelOrderGoodsButton(
                  isActive: goods?.canCancel,
                  callback: () {
                    provider?.cancelOrderGoods(context, goods);
                  },
                ),
          Offstage(
            offstage: provider?.showSelectedProductButton == false,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: SelectedProductButton(
                text: goods?.hasSelectedProduct == false ? '去选品' : '更换选品',
                callback: () {
                  TargetOrderGoods targetOrderGoods = TargetOrderGoods();
                  targetOrderGoods?.setOrderGoodsId(goods?.orderGoodsId);
                  RouteHandler.goCurtainMallPage(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
