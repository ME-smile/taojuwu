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

class CustomerAgePieSector {
  final int index;
  final int count;
  final String label;
  final Color color;
  CustomerAgePieSector({this.index, this.label, this.count, this.color});
}

class AgePieChart extends StatefulWidget {
  final List<int> ageList;
  AgePieChart({Key key, this.ageList}) : super(key: key);

  @override
  _AgePieChartState createState() => _AgePieChartState();
}

class _AgePieChartState extends State<AgePieChart> {
  List<int> get ageList => widget.ageList;
  int get total {
    return ageList.reduce((int a, int b) => a + b);
  }

  PieDataSet initDataset() {
    List arr = ageList;
    Map dict = {
      0: '20岁以下',
      1: '20-35岁',
      2: '30-50岁',
      3: '50岁以上',
    };

    List<CustomerAgePieSector> list = total == 0
        ? [
            CustomerAgePieSector(
                color: Colors.black, index: -1, label: '暂无数据', count: 0)
          ]
        : List.generate(4, (int i) {
            return CustomerAgePieSector(
                index: i, label: '${dict[i]}\n${arr[i]}位', count: arr[i]);
          });

    List<PieEntry> entries = [];
    List<Color> colors = [];
    list.forEach((item) {
      entries.add(PieEntry(
        label: item.label,
        value: item.count.toDouble(),
      ));
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

  @override
  void initState() {
    super.initState();
    initController();
  }

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
        aspectRatio: 1.5,
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
