import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/bottom_picker.dart';

class TimePeriodPicker extends StatefulWidget {
  final String title;
  final Function callback;
  final ValueNotifier<TimePeriod> curOption;
  TimePeriodPicker({Key key, this.title: '', this.callback, this.curOption})
      : super(key: key);

  @override
  _TimePeriodPickerState createState() => _TimePeriodPickerState();
}

class _TimePeriodPickerState extends State<TimePeriodPicker> {
  FixedExtentScrollController dateController;
  FixedExtentScrollController timeController;
  ValueNotifier<TimePeriod> curOption;
  Function callback;
  @override
  void initState() {
    super.initState();
    dateController = FixedExtentScrollController();
    timeController = FixedExtentScrollController();
    curOption = widget.curOption;
    callback = widget.callback;
  }

  static const List<String> timePeriods = [
    '09:00-10:00',
    '10:00-11:00',
    '11:00-12:00',
    '12:00-13:00',
    '13:00-14:00',
    '14:00-15:00',
    '15:00-16:00',
    '17:00-18:00'
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    return BottomPicker(
      title: widget.title,
      callback: () {
        if (callback != null) {
          callback();
        }
        Navigator.of(context).pop();
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              width: width / 2,
              height: UIKit.BOTTOM_PICKER_HEIGHT,
              child: CupertinoPicker(
                  backgroundColor: Theme.of(context).primaryColor,
                  scrollController: dateController,
                  itemExtent: UIKit.ITEM_EXTENT,
                  onSelectedItemChanged: (int index) {
                    curOption.value.dateTime = now.add(
                      Duration(days: index),
                    );
                  },
                  children: List.generate(31, (int i) {
                    if (i == 0)
                      return Center(
                        child: Text(
                          '今天',
                          style: UIKit.OPTION_ITEM_STYLE,
                        ),
                      );
                    return Center(
                      child: Text(
                        DateUtil.formatDate(
                          now.add(
                            Duration(days: i),
                          ),
                          format: 'MM月dd日',
                        ),
                        style: UIKit.OPTION_ITEM_STYLE,
                      ),
                    );
                  })),
            ),
            Container(
              width: width / 2,
              height: UIKit.BOTTOM_PICKER_HEIGHT,
              child: CupertinoPicker(
                  backgroundColor: Theme.of(context).primaryColor,
                  scrollController: timeController,
                  itemExtent: UIKit.ITEM_EXTENT,
                  onSelectedItemChanged: (int index) {
                    curOption.value.period = timePeriods[index];
                  },
                  children: List.generate(timePeriods?.length, (int i) {
                    return Center(
                      child: Text(
                        timePeriods[i],
                        style: UIKit.OPTION_ITEM_STYLE,
                      ),
                    );
                  })),
            ),
          ],
        ),
      ),
    );
  }
}

class TimePeriod {
  DateTime dateTime;
  String period;

  TimePeriod({this.period, this.dateTime});
}
