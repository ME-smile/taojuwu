/*
 * @Description: 上门量尺时间
 * @Author: iamsmiling
 * @Date: 2020-10-29 17:16:10
 * @LastEditTime: 2020-10-30 07:26:50
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/view/order/popup_modal/submit_order_popup_modal.dart';
import 'package:taojuwu/view/order/widgets/order_remark_card/widgets/base/order_remark_bar.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';
import 'package:taojuwu/widgets/time_period_picker.dart';

class MeasureTimeRemarkBar extends StatefulWidget {
  final OrderCreator orderCreator;
  MeasureTimeRemarkBar(this.orderCreator, {Key key}) : super(key: key);

  @override
  _MeasureTimeRemarkBarState createState() => _MeasureTimeRemarkBarState();
}

class _MeasureTimeRemarkBarState extends State<MeasureTimeRemarkBar> {
  OrderCreator get orderCreator => widget.orderCreator;
  ValueNotifier<TimePeriod> measureTimePeriod;
  @override
  void initState() {
    super.initState();
    measureTimePeriod = ValueNotifier<TimePeriod>(
        TimePeriod(dateTime: DateTime.now(), period: '09:00-10:00'));
  }

  @override
  void dispose() {
    measureTimePeriod?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrderRemarkBar(
      title: '上门量尺意向时间:',
      text: orderCreator?.measureTimeStr,
      callback: () =>
          showMeasureTimePicker(context, widget.orderCreator, measureTimePeriod)
              .whenComplete(() {
        setState(() {});
      }),
    );
  }
}
