/*
 * @Description: 修改价格弹窗
 * @Author: iamsmiling
 * @Date: 2020-11-25 16:08:18
 * @LastEditTime: 2020-11-25 17:10:16
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/providers/order_detail_provider.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/toast_kit.dart';
import 'package:taojuwu/view/goods/curtain/widgets/sku_attr_picker.dart';

class EditPriceModalView extends StatefulWidget {
  final OrderDetailProvider provider;

  EditPriceModalView(this.provider, {Key key}) : super(key: key);

  @override
  _EditPriceModalViewState createState() => _EditPriceModalViewState();
}

class _EditPriceModalViewState extends State<EditPriceModalView> {
  OrderDetailProvider get provider => widget.provider;
  int get orderId => provider.model.orderId;
  String newPrice = '';
  String remark = '';
  double discount = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderDetailProvider>.value(
      value: provider,
      child: SkuAttrPicker(
        callback: () {
          double deltaPrice = 0.0;
          if (newPrice?.trim()?.isEmpty == true) {
            return ToastKit.showInfo('请输入正确的金额');
          }
          double tmp = CommonKit.parseDouble(newPrice);

          if (provider.modifyPriceByAmount) {
            deltaPrice = provider.originPrice - tmp;
          }
          if (provider.modifyPriceByDisscount) {
            deltaPrice =
                (provider.originPrice) * (1 - provider?.discountFactor);
          }
          OTPService.editPrice(params: {
            'adjust_money': deltaPrice,
            'adjust_money_remark': remark,
            'order_id': orderId ?? -1
          }).then((ZYResponse response) {
            if (response.valid) {
              Navigator.of(context).pop();
            }
          }).catchError((err) => err);
        },
        height: MediaQuery.of(context).size.height * .72,
        title: '修改价格',
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Divider(
                  color: const Color(0xFFF1F1F1),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('原订单总价',
                          style: TextStyle(
                            color: const Color(0xFF333333),
                            fontSize: 16,
                          )),
                      Text(
                        '¥${provider?.originPrice}',
                        style: TextStyle(
                          color: const Color(0xFFFF6161),
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('改价方式',
                                  style: TextStyle(
                                    color: const Color(0xFF333333),
                                    fontSize: 16,
                                  )),
                              Container(
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                            value:
                                                provider?.modifyPriceByAmount,
                                            onChanged: (bool flag) {
                                              setState(() {
                                                provider?.modifyPriceByAmount =
                                                    true;
                                                provider?.modifyPriceByDisscount =
                                                    false;
                                              });
                                            }),
                                        Text('按金额')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value:
                                              provider?.modifyPriceByDisscount,
                                          onChanged: (_) {
                                            setState(() {
                                              provider?.modifyPriceByAmount =
                                                  false;
                                              provider?.modifyPriceByDisscount =
                                                  true;
                                            });
                                          },
                                        ),
                                        Text('按折扣')
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: IndexedStack(
                              index:
                                  provider?.modifyPriceByAmount == true ? 0 : 1,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('改后总价',
                                          style: TextStyle(
                                            color: const Color(0xFF333333),
                                            fontSize: 16,
                                          )),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: 36,
                                          maxWidth: 96,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          child: TextField(
                                              onChanged: (String str) {
                                                newPrice = str;
                                              },
                                              decoration: InputDecoration(
                                                  isDense: true,
                                                  filled: true,
                                                  fillColor: Color(0xFFF8F8F8),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 10,
                                                          top: 8,
                                                          bottom: 8,
                                                          right: 10),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: const Color(
                                                                  0xFFEFF0F0))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: const Color(
                                                              0xFFEFF0F0))))),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('折扣系数',
                                          style: TextStyle(
                                            color: const Color(0xFF333333),
                                            fontSize: 16,
                                          )),
                                      Row(
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxHeight: 36,
                                              maxWidth: 96,
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              child: TextField(
                                                  onChanged: (String str) {
                                                    double tmp =
                                                        CommonKit.parseDouble(
                                                                str,
                                                                defaultVal: 0) /
                                                            10;

                                                    if (tmp > 10 || tmp < 0) {
                                                      return ToastKit.showInfo(
                                                          '请输入正确的折扣系数');
                                                    }
                                                    discount = tmp;
                                                    provider?.discountFactor =
                                                        tmp;
                                                    newPrice =
                                                        '${provider.originPrice * discount}';
                                                  },
                                                  onEditingComplete: () {
                                                    setState(() {});
                                                  },
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xFFF8F8F8),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 32,
                                                              top: 8,
                                                              bottom: 8,
                                                              right: 10),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: const Color(
                                                                  0xFFEFF0F0))),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: const Color(
                                                                  0xFFEFF0F0))))),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              '折',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      const Color(0xFF333333)),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: MediaQuery.of(context).size.width,
                                  maxWidth: MediaQuery.of(context).size.width,
                                  maxHeight: 48,
                                  minHeight: 48),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                child: TextField(
                                    decoration: InputDecoration(
                                        isDense: true,
                                        filled: true,
                                        hintText: '改价备注说明（非必填）',
                                        fillColor: Color(0xFFF8F8F8),
                                        contentPadding: EdgeInsets.only(
                                            left: 10,
                                            top: 8,
                                            bottom: 8,
                                            right: 10),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    const Color(0xFFEFF0F0))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    const Color(0xFFEFF0F0))))),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: provider.modifyPriceByDisscount &&
                                CommonKit.isNumNullOrZero(
                                    CommonKit.parseDouble(provider?.newPrice)),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('改后总价',
                                      style: TextStyle(
                                        color: const Color(0xFF333333),
                                        fontSize: 16,
                                      )),
                                  Selector(
                                    builder: (BuildContext context,
                                        double price, _) {
                                      return Text(
                                        '¥' + (price?.toStringAsFixed(2) ?? ''),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      );
                                    },
                                    selector: (
                                      BuildContext context,
                                      OrderDetailProvider provider,
                                    ) =>
                                        provider.newPrice,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // ClipRRect(
                //   borderRadius: BorderRadius.all(Radius.circular(5)),
                //   child: Container(
                //     alignment: Alignment.center,
                //     constraints:
                //         BoxConstraints(maxHeight: 36, minHeight: 36),
                //     decoration: BoxDecoration(
                //         border: Border.all(color: const Color(0xFFF8F8F8))),
                //     child: TextField(
                //         decoration: InputDecoration(
                //       filled: true,
                //       isDense: true,
                //       contentPadding: EdgeInsets.only(
                //           left: 10, top: 5, bottom: 5, right: 10),
                //       focusedBorder: OutlineInputBorder(
                //           borderSide:
                //               BorderSide(color: const Color(0xFFEFF0F0))),
                //       enabledBorder: OutlineInputBorder(
                //           borderSide:
                //               BorderSide(color: const Color(0xFFEFF0F0))),
                //       hintText: '改价备注说明（非必填）',
                //       fillColor: Color(0xFFF8F8F8),
                //     )),
                //   ),
                // )
                // Container(
                //   child: ,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
