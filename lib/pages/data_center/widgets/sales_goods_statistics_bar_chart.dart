import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mp_chart/mp/chart/bar_chart.dart';
import 'package:mp_chart/mp/controller/bar_chart_controller.dart';
import 'package:mp_chart/mp/core/animator.dart';
import 'package:mp_chart/mp/core/data/bar_data.dart';
import 'package:mp_chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/bar_entry.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/enums/y_axis_label_position.dart';

import 'package:taojuwu/models/data_center/sale_statistics_data_model.dart';
import 'package:taojuwu/pages/data_center/formatter.dart';

class SalesGoodsStaticsBarChart extends StatefulWidget {
  final List<SalesGoodsModel> goodsList;
  SalesGoodsStaticsBarChart(
      {Key key, this.goodsList: const [SalesGoodsModel('窗帘', 0.0)]})
      : super(key: key);

  @override
  _SalesGoodsStaticsBarChartState createState() =>
      _SalesGoodsStaticsBarChartState();
}

class _SalesGoodsStaticsBarChartState extends State<SalesGoodsStaticsBarChart> {
  List<SalesGoodsModel> get goodsList =>
      widget.goodsList == null || widget.goodsList.isEmpty
          ? [SalesGoodsModel('窗帘', 0.0)]
          : widget.goodsList;
  List<BarEntry> entries = [];

  BarDataSet createDataset() {
    entries?.clear();
    List<SalesGoodsModel> list = goodsList;
    for (int i = 0; i < list?.length ?? 0; i++) {
      SalesGoodsModel model = list[i];
      entries
          .add(BarEntry(x: i.toDouble(), y: model?.money, data: model?.name));
    }

    BarDataSet dataSet = BarDataSet(entries, 'goods');

    dataSet.setColor1(Color(0xFF5C89FF));
    return dataSet;
  }

  BarChartController controller;
  void initController() {
    Description desc = Description()..enabled = false;

    controller = BarChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..setLabelCount2(8, false)
            ..position = YAxisLabelPosition.OUTSIDE_CHART
            ..spacePercentTop = 15
            ..drawGridLines = false
            ..setAxisMinimum(0);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight.enabled = (false);
        },
        legendSettingFunction: (legend, controller) {
          legend.enabled = false;
          // legend
          //   ..verticalAlignment = LegendVerticalAlignment.BOTTOM
          //   ..orientation = LegendOrientation.HORIZONTAL
          //   ..drawInside = false
          //   ..shape = LegendForm.SQUARE
          //   ..formSize = 20
          //   ..textSize = 11
          //   ..textColor = ColorUtils.RED
          //   ..xEntrySpace = 4;
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..position = XAxisPosition.BOTTOM
            ..drawGridLines = false
            ..setLabelCount1(entries.length)
            ..setValueFormatter(NameFormatter(entries));
        },
        drawBarShadow: false,
        drawValueAboveBar: true,
        drawGridBackground: false,
        dragXEnabled: true,
        dragYEnabled: true,
        scaleXEnabled: true,
        scaleYEnabled: true,
        pinchZoomEnabled: false,
        maxVisibleCount: 60,
        description: desc,
        noDataText: '暂无数据');
    controller?.data = BarData([createDataset()]);
  }

  void beforeBuild() {
    initController();
    controller.animator
      ..reset()
      ..animateY2(1400, Easing.EaseInOutQuad);

    BarData data = controller?.data;
    data?.setDataSet(createDataset());
  }

  @override
  Widget build(BuildContext context) {
    beforeBuild();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: AspectRatio(
        aspectRatio: 1,
        child: BarChart(controller),
      ),
    );
  }
}
