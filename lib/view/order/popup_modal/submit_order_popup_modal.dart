/*
 * @Description: 提交订单填写备注的弹窗
 * @Author: iamsmiling
 * @Date: 2020-10-29 17:43:00
 * @LastEditTime: 2020-10-30 07:36:44
 */
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/viewmodel/order/order_creator.dart';
import 'package:taojuwu/widgets/bottom_picker.dart';
import 'package:taojuwu/widgets/time_period_picker.dart';

//选择上门意向量尺时间
Future showMeasureTimePicker(BuildContext context, OrderCreator orderCreator,
    ValueNotifier<TimePeriod> measureTimePeriod,
    {StateSetter setState}) {
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return TimePeriodPicker(
          title: '上门量尺意向时间',
          curOption: measureTimePeriod,
          callback: () {
            orderCreator?.measureTimePeriod = measureTimePeriod?.value;
          },
        );
      });
}

// 选择意向上门安装时间

Future showInstallTimePicker(BuildContext context, OrderCreator orderCreator) {
  return DatePicker.showDatePicker(context,
          locale: LocaleType.zh,
          minTime: DateTime.now(),
          theme: DatePickerTheme(
              cancelStyle: UIKit.CANCEL_BUTTON_STYLE,
              itemHeight: UIKit.ITEM_EXTENT,
              doneStyle: UIKit.CONFIRM_BUTTON_STYLE,
              itemStyle: UIKit.OPTION_ITEM_STYLE,
              containerHeight: UIKit.BOTTOM_PICKER_HEIGHT))
      .then((DateTime date) {
    orderCreator?.installTime =
        DateUtil.formatDate(date, format: "yyyy年MM月dd日");
  }).catchError((err) => err);
}

Future showWindowCountPicker(BuildContext context, OrderCreator orderCreator,
    {String count = '1'}) {
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return BottomPicker(
          title: '测量窗数',
          callback: () {
            orderCreator?.windowCount = '$count';
            // provider?.windowNum = tmpOption ?? '1';
            Navigator.of(context).pop();
          },
          child: CupertinoPicker(
              // backgroundColor: themeData.primaryColor,
              // scrollController: ageController,
              itemExtent: UIKit.ITEM_EXTENT,
              onSelectedItemChanged: (int index) {
                if (index > 0 && index < 9) {
                  count = '${index + 1}';
                }
                if (index >= 10) {
                  count = '10+';
                }
                // if (index > 0 && index < 9) {
                //   tmpOption = '${index + 1}';
                // } else {
                //   tmpOption = '10+';
                // }
              },
              children: List.generate(11, (int i) {
                return Center(
                  child: Text(
                    '${i + 1 > 10 ? "10+" : i + 1}',
                    style: UIKit.OPTION_ITEM_STYLE,
                  ),
                );
              })),
        );
      });
}
