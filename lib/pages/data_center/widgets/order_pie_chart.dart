import 'package:flutter/material.dart';
import 'package:mp_chart/mp/chart/pie_chart.dart';
import 'package:mp_chart/mp/controller/pie_chart_controller.dart';
import 'package:mp_chart/mp/core/animator.dart';
import 'package:mp_chart/mp/core/data/pie_data.dart';
import 'package:mp_chart/mp/core/data_set/pie_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/pie_entry.dart';
import 'package:mp_chart/mp/core/enums/legend_horizontal_alignment.dart';
import 'package:mp_chart/mp/core/enums/legend_orientation.dart';
import 'package:mp_chart/mp/core/enums/legend_vertical_alignment.dart';
import 'package:mp_chart/mp/core/render/pie_chart_renderer.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:mp_chart/mp/core/value_formatter/percent_formatter.dart';

class ConvertionRateData {
  final double percentage;
  final String text;
  final Color color;
  String get percentageStr =>
      '${double.parse(percentage.toStringAsFixed(2)) * 100}%';
  String get label =>
      '$text:${double.parse(percentage.toStringAsFixed(2)) * 100}%';
  ConvertionRateData(this.percentage, this.text, {this.color});
}

class OrderPieChart extends StatefulWidget {
  final double convertionRate;
  final double uncovertionRate;
  OrderPieChart({Key key, this.convertionRate, this.uncovertionRate})
      : super(key: key);

  @override
  _OrderPieChartState createState() => _OrderPieChartState();
}

class _OrderPieChartState extends State<OrderPieChart> {
  double get convertionRate => widget.convertionRate;
  double get unconvertionRate => widget.uncovertionRate;

  double get total => convertionRate + unconvertionRate;
  bool get hasData => total != 0;

  @override
  void initState() {
    super.initState();

    initController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void beforeBuild() {
    controller.animator
      ..reset()
      ..animateY2(1400, Easing.EaseInOutQuad);
    PieData data = controller?.data;
    data.setDataSet(createDataset());

    // data.notifyDataChanged();
  }

  PieDataSet createDataset() {
    List<ConvertionRateData> list = hasData
        ? [
            ConvertionRateData(
              convertionRate,
              '转单率',
              color: Color(0xFF5C89FF),
            ),
            ConvertionRateData(unconvertionRate, '非转单率', color: Colors.black),
          ]
        : [ConvertionRateData(1.0, '暂无数据', color: Colors.black)];
    List<Color> colors = [];
    List<PieEntry> entries = [];

    list.forEach((item) {
      entries.add(PieEntry(label: item.text, value: item.percentage));
      colors.add(item.color);
    });
    PieDataSet dataSet = new PieDataSet(entries, "Election Results");
    dataSet.setColors1(colors);
    // dataSet.setSelectionShift(0);

    // dataSet.setValueLinePart1OffsetPercentage(80.0);
    // dataSet.setValueLinePart1Length(0.2);
    // dataSet.setValueLinePart2Length(0.4);
    return dataSet;
  }

  PieChartController controller;

  void initController() {
    Description desc = Description()..enabled = false;
    PercentFormatter formatter = PercentFormatter();
    controller = PieChartController(
        legendSettingFunction: (legend, controller) {
          formatter.setPieChartPainter(controller);
          legend
            ..verticalAlignment = (LegendVerticalAlignment.TOP)
            ..horizontalAlignment = (LegendHorizontalAlignment.RIGHT)
            ..orientation = (LegendOrientation.VERTICAL)
            ..drawInside = (false)
            ..enabled = (false);
        },
        rendererSettingFunction: (renderer) {
          (renderer as PieChartRenderer)
            ..setHoleColor(ColorUtils.WHITE)
            ..setHoleColor(ColorUtils.WHITE)
            ..setTransparentCircleColor(ColorUtils.WHITE);
        },
        rotateEnabled: true,
        drawHole: false,
        drawCenterText: true,
        extraLeftOffset: 0,
        extraTopOffset: 0,
        extraRightOffset: 0,
        extraBottomOffset: 0,
        usePercentValues: true,
        holeRadiusPercent: 10,
        drawMarkers: true,
        drawSlicesUnderHole: true,

        // transparentCircleRadiusPercent: 61,
        highLightPerTapEnabled: true,
        description: desc);
    controller.data = PieData(createDataset())
      ..setValueFormatter(formatter)
      ..setValueTextSize(11)
      ..setValueTextColor(ColorUtils.WHITE);
  }

  @override
  Widget build(BuildContext context) {
    beforeBuild();
    return Container(
      height: 300,
      width: 300,
      child: PieChart(controller),
    );
  }
}
