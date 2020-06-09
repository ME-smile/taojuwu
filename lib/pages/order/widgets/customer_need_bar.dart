import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/providers/order_provider.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/bottom_picker.dart';
import 'package:taojuwu/widgets/time_period_picker.dart';

class CustomerNeedBar extends StatefulWidget {
  final bool isHideMeasureWindowNum;
  CustomerNeedBar({Key key, this.isHideMeasureWindowNum: false})
      : super(key: key);

  @override
  _CustomerNeedBarState createState() => _CustomerNeedBarState();
}

class _CustomerNeedBarState extends State<CustomerNeedBar> {
  FixedExtentScrollController ageController;
  TextEditingController depositInput;
  TextEditingController markInput;
  ValueNotifier<TimePeriod> measureTimePeriod;
  @override
  void initState() {
    super.initState();
    ageController = FixedExtentScrollController();
    depositInput = TextEditingController();
    markInput = TextEditingController();
    measureTimePeriod = ValueNotifier<TimePeriod>(
        TimePeriod(dateTime: DateTime.now(), period: '09:00-10:00'));
  }

  @override
  void dispose() {
    super.dispose();
    ageController?.dispose();
    depositInput?.dispose();
    markInput?.dispose();
    measureTimePeriod?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Consumer<OrderProvider>(
      builder: (BuildContext context, OrderProvider provider, _) {
        // provider?.initMeasureTime(measureTimePeriod?.value);
        return Container(
          color: themeData.primaryColor,
          child: Column(
            children: <Widget>[
              OptBar(
                title: '上门量尺意向时间:',
                text: '${provider?.measureTimeStr ?? '时间'}',
                callback: () async {
                  await showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) {
                        // String tmpOption;
                        // DateTime now = DateTime.now();
                        return TimePeriodPicker(
                          title: '上门量尺意向时间',
                          curOption: measureTimePeriod,
                          callback: () {
                            provider?.measureTime = measureTimePeriod?.value;
                          },
                        );
                      });
                  // DatePicker.showDateTimePicker(context, locale: LocaleType.zh)
                  //     .then((DateTime date) {
                  //   provider?.measureTime =
                  //       DateUtil.formatDate(date, format: "yyyy年MM月dd日 HH:mm");
                  // }).catchError((err) => err);
                },
              ),
              OptBar(
                title: '客户意向安装时间:',
                text: '${provider?.installTime ?? '时间'}',
                callback: () async {
                  DatePicker.showDatePicker(context,
                          locale: LocaleType.zh,
                          minTime: DateTime.now(),
                          theme: DatePickerTheme(
                              cancelStyle: UIKit.CANCEL_BUTTON_STYLE,
                              itemHeight: UIKit.ITEM_EXTENT,
                              doneStyle: UIKit.CONFIRM_BUTTON_STYLE,
                              itemStyle: UIKit.OPTION_ITEM_STYLE,
                              containerHeight: UIKit.BOTTOM_PICKER_HEIGHT))
                      .then((DateTime date) {
                    provider?.installTime =
                        DateUtil.formatDate(date, format: "yyyy年MM月dd日");
                  }).catchError((err) => err);
                },
              ),
              Offstage(
                offstage: widget.isHideMeasureWindowNum,
                child: OptBar(
                  title: '需测量窗数:'.padLeft(17),
                  text: '${provider?.windowNum ?? '请选择'}',
                  callback: () async {
                    await showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) {
                          String tmpOption;
                          return BottomPicker(
                            title: '测量窗数',
                            callback: () {
                              provider?.windowNum = tmpOption ?? '1';
                              Navigator.of(context).pop();
                            },
                            child: CupertinoPicker(
                                backgroundColor: themeData.primaryColor,
                                scrollController: ageController,
                                itemExtent: UIKit.ITEM_EXTENT,
                                onSelectedItemChanged: (int index) {
                                  if (index > 0 && index < 9) {
                                    tmpOption = '${index + 1}';
                                  } else {
                                    tmpOption = '10+';
                                  }
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
                  },
                ),
              ),
              OptBar(
                title: '定金:'.padLeft(25),
                text: '${provider?.deposit ?? '请输入'}',
                callback: () async {
                  await showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text('定金'),
                          content: Column(
                            children: <Widget>[
                              CupertinoTextField(
                                controller: depositInput,
                                keyboardType: TextInputType.number,
                                placeholder: '元',
                              ),
                            ],
                          ),
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
                                // closeSizeDialog();
                                // print(depositInput?.text);
                                provider?.deposit = depositInput?.text;
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                },
              ),
              OptBar(
                title: '订单备注:'.padLeft(19),
                text: '${provider?.orderMark ?? '选填'}',
                callback: () async {
                  await showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text('备注'),
                          content: Column(
                            children: <Widget>[
                              CupertinoTextField(
                                controller: markInput,
                                placeholder: '请填写备注',
                              ),
                            ],
                          ),
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
                                // closeSizeDialog();
                                provider?.orderMark = markInput?.text;
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class OptBar extends StatelessWidget {
  final String title;
  final String text;
  final Function callback;
  const OptBar({Key key, this.title, this.callback, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return InkWell(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: UIKit.width(20), vertical: UIKit.height(10)),
        child: Row(
          children: <Widget>[
            Text(title),
            Expanded(
                child: Text(
              text,
              style: textTheme.caption,
            )),
            Icon(ZYIcon.next)
          ],
        ),
      ),
    );
  }
}
