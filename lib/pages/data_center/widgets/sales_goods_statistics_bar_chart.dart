import 'package:flutter/material.dart';
import 'package:mp_chart/mp/chart/bar_chart.dart';
import 'package:mp_chart/mp/controller/bar_chart_controller.dart';
import 'package:mp_chart/mp/core/animator.dart';
import 'package:mp_chart/mp/core/data/bar_data.dart';
import 'package:mp_chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/bar_entry.dart';
import 'package:mp_chart/mp/core/enums/legend_form.dart';
import 'package:mp_chart/mp/core/enums/legend_orientation.dart';
import 'package:mp_chart/mp/core/enums/legend_vertical_alignment.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/enums/y_axis_label_position.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:taojuwu/models/data_center/sale_statistics_data_model.dart';
import 'package:taojuwu/pages/data_center/formatter.dart';

class SalesGoodsStaticsBarChart extends StatefulWidget {
  final List<SalesGoodsModel> goodsList;
  SalesGoodsStaticsBarChart({Key key, this.goodsList}) : super(key: key);

  @override
  _SalesGoodsStaticsBarChartState createState() =>
      _SalesGoodsStaticsBarChartState();
}

class _SalesGoodsStaticsBarChartState extends State<SalesGoodsStaticsBarChart> {
  List<SalesGoodsModel> get goodsList => widget.goodsList;
  List<BarEntry> entries = [];

  @override
  void initState() {
    super.initState();
    initController();
  }

  BarDataSet initDataset() {
    List<SalesGoodsModel> list = goodsList ?? [];
    for (int i = 0; i < list?.length ?? 0; i++) {
      SalesGoodsModel model = goodsList[i];
      entries
          .add(BarEntry(x: i.toDouble(), y: model?.money, data: model?.name));
    }
    if (entries?.isEmpty == true) {
      entries.add(BarEntry(x: 0.0, y: 0.0, data: ''));
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
            ..setAxisMinimum(0);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight.enabled = (false);
        },
        legendSettingFunction: (legend, controller) {
          legend
            ..verticalAlignment = LegendVerticalAlignment.BOTTOM
            ..orientation = LegendOrientation.HORIZONTAL
            ..drawInside = false
            ..shape = LegendForm.SQUARE
            ..formSize = 20
            ..textSize = 11
            ..textColor = ColorUtils.RED
            ..xEntrySpace = 4;
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..position = XAxisPosition.BOTTOM
            ..drawGridLines = false
            ..setValueFormatter(NameFormatter(entries))
            ..setGranularity(1.0)
            ..setLabelCount1(7);
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
    controller.data = BarData([initDataset()]);
  }

  Widget buildBarChart() {
    controller.animator
      ..reset()
      ..animateY2(1400, Easing.EaseInOutQuad);
    return BarChart(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: AspectRatio(
        aspectRatio: 1,
        child: buildBarChart(),
      ),
    );
  }
}
