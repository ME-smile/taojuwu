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

class CustomerGenderPieSector {
  final int index;
  final double rate;
  final String label;
  final Color color;
  CustomerGenderPieSector({this.index, this.label, this.rate, this.color});
}

class GenderPieChart extends StatefulWidget {
  final int female;
  final int male;
  GenderPieChart({Key key, this.female, this.male}) : super(key: key);

  @override
  _GenderPieChartState createState() => _GenderPieChartState();
}

class _GenderPieChartState extends State<GenderPieChart> {
  int get male => widget.male;
  int get female => widget.female;
  int get total => male + female;
  double get malePercentage => male == 0 ? 0.0 : male / total;
  double get femalePercentage => female == 0 ? 0.0 : female / total;

  String get malePercentageStr => '${malePercentage.toStringAsFixed(2)}%';
  String get femalePercentageStr => '${malePercentage.toStringAsFixed(2)}%';

  @override
  void initState() {
    super.initState();
    initController();
  }

  PieDataSet initDataset() {
    List<CustomerGenderPieSector> list = total == 0
        ? [
            CustomerGenderPieSector(
                index: -1, color: Colors.black, label: '暂无数据', rate: 1)
          ]
        : [
            CustomerGenderPieSector(
                index: 0,
                color: Color(0xFF5C89FF),
                label: '男性$female位',
                rate: malePercentage),
            CustomerGenderPieSector(
                index: 0,
                color: Color(0xFF5C89FF),
                label: '女性$male位',
                rate: femalePercentage)
          ];
    List<Color> colors = [];
    List<PieEntry> entries = [];
    list.forEach((item) {
      entries.add(PieEntry(label: item.label, value: item.rate));
      colors.add(item.color);
    });
    PieDataSet dataSet = new PieDataSet(entries, "Election Results");
    dataSet.setColors1(colors);
    dataSet.setSelectionShift(0);

    dataSet.setValueLinePart1OffsetPercentage(80.0);
    dataSet.setValueLinePart1Length(0.2);
    dataSet.setValueLinePart2Length(0.4);
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
        extraLeftOffset: 20,
        extraTopOffset: 10,
        extraRightOffset: 20,
        extraBottomOffset: 10,
        usePercentValues: true,
        holeRadiusPercent: 10,
        drawMarkers: true,
        drawSlicesUnderHole: true,

        // transparentCircleRadiusPercent: 61,
        highLightPerTapEnabled: true,
        description: desc);
    controller.data = PieData(initDataset())
      ..setValueFormatter(formatter)
      ..setValueTextSize(11)
      ..setValueTextColor(ColorUtils.WHITE);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: AspectRatio(
        aspectRatio: 1,
        child: _initPieChart(),
      ),
    );
  }

  Widget _initPieChart() {
    PieChart pieChart = PieChart(controller);

    controller.animator
      ..reset()
      ..animateY2(1400, Easing.EaseInOutQuad);
    return pieChart;
  }
}
