import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/pages/data_center/widgets/passenger_graph_view.dart';

import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/bottom_picker.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

import 'widgets/sales_analysis_graph_view.dart';
import 'widgets/sales_statics_graph_view.dart';

class DataCenterPage extends StatefulWidget {
  DataCenterPage({Key key}) : super(key: key);

  @override
  _DataCenterPageState createState() => _DataCenterPageState();
}

class _DataCenterPageState extends State<DataCenterPage> {
  List tabs = ['客流统计', '销售统计', '销售分析'];
  bool isLoading = true;
  static List options = [
    {
      'text': '本周',
      'type': 1,
      'isChecked': true,
      'callback': () {
        checkOption(0);
      }
    },
    {
      'text': '本月',
      'type': 2,
      'isChecked': false,
      'callback': () {
        checkOption(1);
      }
    },
    {
      'text': '本季度',
      'type': 3,
      'isChecked': false,
      'callback': () {
        checkOption(2);
      }
    },
    {
      'text': '本年',
      'type': 4,
      'isChecked': false,
      'callback': () {
        checkOption(3);
      }
    },
    {
      'text': '更多',
      'type': 5,
      'isChecked': false,
    },
  ];

  static checkOption(int i) {
    for (int j = 0; j < options.length; j++) {
      Map item = options[j];
      item['isChecked'] = j == i;
    }
  }

  showMoreOption(BuildContext context) async {
    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return _MoreOptionSheet();
        });
  }

  @override
  void initState() {
    super.initState();
  }

  get currentType {
    for (int i = 0; i < options.length; i++) {
      Map item = options[i];
      if (item['isChecked']) return item['type'] ?? 1;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('数据中心'),
            centerTitle: true,
            bottom: PreferredSize(
                child: Column(
                  children: <Widget>[
                    TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: List.generate(tabs.length, (int i) {
                          return Text('${tabs[i]}');
                        })),
                    Container(
                      color: Color(0xFFF3F3F3),
                      padding: EdgeInsets.only(top: UIKit.height(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(options.length, (int i) {
                          return InkWell(
                            onTap: () {
                              if (i == options.length - 1) {
                                showMoreOption(context);
                              } else {
                                setState(() {
                                  options[i]['callback']();
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              color: options[i]['isChecked']
                                  ? themeData.primaryColor
                                  : Colors.transparent,
                              child: Text('${options[i]['text']}'),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                preferredSize: Size.fromHeight(60)),
          ),
          body: TabBarView(children: [
            PassengerGraphView(
              type: currentType,
            ),
            SalesStaticsGraphView(),
            SalesAnalysisGraphView()
          ]),
        ));
  }
}

class _MoreOptionSheet extends StatefulWidget {
  _MoreOptionSheet({Key key}) : super(key: key);

  @override
  _MoreOptionSheetState createState() => _MoreOptionSheetState();
}

class _MoreOptionSheetState extends State<_MoreOptionSheet> {
  // FixedExtentScrollController yearController;
  // FixedExtentScrollController monthController;
  // FixedExtentScrollController yearController1;
  int currentYear = 0;
  int currentMonth = 0;

  List<int> yearOptions = [];
  List<int> monthOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  int currentMode = 0;

  checkMode() {}
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    for (int i = 0; i < 10; i++) {
      int j = i < 5 ? -i : i - 5;
      currentYear = j == 0 ? i : currentYear;
      yearOptions.add(now.year + (j));
    }
    currentMonth = now.month - 1;
    // yearController = FixedExtentScrollController(initialItem: currentYear);
    // yearController1 = FixedExtentScrollController(initialItem: currentYear);
    // monthController = FixedExtentScrollController(initialItem: currentMonth);
    // monthController2 = FixedExtentScrollController(initialItem: currentMonth);
  }

  @override
  void dispose() {
    super.dispose();
    // yearController?.dispose();
    // monthController?.dispose();
    // monthController2?.dispose();
  }

  BoxDecoration getBoxDecoration(int i, ThemeData themeData) {
    return currentMode == i
        ? BoxDecoration(
            color: themeData.accentColor,
            border: Border.all(color: themeData.accentColor),
          )
        : BoxDecoration(border: Border.all(width: 1));
  }

  TextStyle getTextStyle(int i, ThemeData themeData) {
    return currentMode == i ? themeData.accentTextTheme.button : TextStyle();
  }

  Widget buildActionButton() {
    ThemeData themeData = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              currentMode = 0;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: UIKit.width(40), vertical: UIKit.height(8)),
            decoration: getBoxDecoration(0, themeData),
            child: Text(
              '按月',
              style: getTextStyle(0, themeData),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              currentMode = 1;
            });
            // createOrder(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: UIKit.width(40), vertical: UIKit.height(8)),
            decoration: getBoxDecoration(1, themeData),
            child: Text(
              '按年',
              style: getTextStyle(1, themeData),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomPicker(
      height: 500,
      title: '选择时间',
      confirmTextStyle: TextStyle(fontSize: 18, color: const Color(0xFF333333)),
      child: Material(
        child: Container(
          child: Column(
            children: <Widget>[
              VSpacing(40),
              buildActionButton(),
              VSpacing(40),
              currentMode == 0 ? buildYearAndMonthPicker() : buildYearPicker()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildYearAndMonthPicker() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Row(
        children: <Widget>[
          Container(
              width: width / 2,
              height: UIKit.BOTTOM_PICKER_HEIGHT,
              child: CupertinoPicker(
                  backgroundColor: Color(0xFFF8F8F8),
                  // scrollController: yearController,
                  itemExtent: UIKit.ITEM_EXTENT,
                  onSelectedItemChanged: (_) {
                    // callback();
                  },
                  children: List.generate(yearOptions.length, (int i) {
                    return Center(
                      child: Text('${yearOptions[i]}年'),
                    );
                  }))),
          Container(
              width: width / 2,
              height: UIKit.BOTTOM_PICKER_HEIGHT,
              child: CupertinoPicker(
                  backgroundColor: Color(0xFFF8F8F8),
                  // scrollController: monthController,
                  itemExtent: UIKit.ITEM_EXTENT,
                  onSelectedItemChanged: (_) {
                    // callback();
                  },
                  children: List.generate(monthOptions.length, (int i) {
                    return Center(
                      child: Text('${monthOptions[i]}月'),
                    );
                  }))),
        ],
      ),
    );
  }

  Widget buildYearPicker() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Row(
        children: <Widget>[
          Container(
              width: width,
              height: UIKit.BOTTOM_PICKER_HEIGHT,
              child: CupertinoPicker(
                  backgroundColor: Color(0xFFF8F8F8),
                  // scrollController: yearController1,
                  itemExtent: UIKit.ITEM_EXTENT,
                  onSelectedItemChanged: (_) {
                    // callback();
                  },
                  children: List.generate(yearOptions.length, (int i) {
                    return Center(
                      child: Text('${yearOptions[i]}年'),
                    );
                  }))),
        ],
      ),
    );
  }
}
