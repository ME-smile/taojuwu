import 'package:flutter/material.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';

import 'package:mp_chart/mp/core/data/line_data.dart';

import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/enums/y_axis_label_position.dart';

import 'package:mp_chart/mp/core/utils/color_utils.dart';

import 'package:taojuwu/models/data_center/passenger_statistics_data_model.dart';

import '../formatter.dart';

class PassengerFlowLineChart extends StatefulWidget {
  final List<PassengerStatisticsDataModel> models;
  final int type;
  PassengerFlowLineChart({Key key, this.models: const [], this.type})
      : super(key: key);

  @override
  _PassengerFlowLineChartState createState() => _PassengerFlowLineChartState();
}

class _PassengerFlowLineChartState extends State<PassengerFlowLineChart> {
  List<PassengerStatisticsDataModel> get models => widget.models ?? [];
  int get type => widget.type;
  List<Entry> entries = [];

  LineDataSet createDataset() {
    List<Entry> list = [];

    for (int i = 0; i < models?.length ?? 0; i++) {
      print(
          '${models[i].date}--------${models[i].data}---客流量---------------------');

      PassengerStatisticsDataModel model = models[i];
      print(
          'x: ${i.toDouble()}---------y:${model?.value?.toDouble()}------data:${model?.date}');
      Entry entry = Entry(
          x: i.toDouble(), y: model?.value?.toDouble(), data: model?.date);
      list.add(entry);
      // if (entries.contains(entry) == false) {

      // }
    }
    entries = list;
    print(entries.length);

    // if (entries?.isEmpty == true) {
    //   entries.add(
    //     Entry(x: 0.0, y: 0.0, data: DateTime.now()),
    //   );
    // }

    LineDataSet dataSet = LineDataSet(entries, 'passenger-flow');

    dataSet.setMode(Mode.CUBIC_BEZIER);
    dataSet.setCubicIntensity(0.2);
    dataSet.setDrawFilled(true);
    dataSet.setDrawCircles(true);
    dataSet.setLineWidth(.5);
    dataSet.setCircleRadius(3);
    dataSet.setCircleColor(Color(0xFF5C89FF));
    // dataSet.setHighLightColor(Color.fromARGB(255, 244, 117, 117));
    dataSet.setColor1(Color(0xFF5C89FF));
    dataSet.setFillColor(ColorUtils.WHITE);
    dataSet.setFillAlpha(100);
    dataSet.setDrawHorizontalHighlightIndicator(false);
    dataSet.setFillFormatter(A());
    dataSet.setDrawCircleHole(false);

    return dataSet;
  }

  LineChartController controller;

  void initController() {
    Description desc = Description()..enabled = false;
    controller = LineChartController(
        // marker: ,
        drawMarkers: true,
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..textColor = (ColorUtils.BLACK)
            ..position = (YAxisLabelPosition.OUTSIDE_CHART)
            ..axisLineWidth = (.5)
            ..drawGridLines = (false)
            ..setAxisMinValue(0)
            ..setAxisMaxValue(100)
            ..setLabelCount1(10)
            ..axisLineColor = (ColorUtils.BLACK);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight.enabled = (false);
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..textColor = Colors.black
            ..drawGridLines = (false)
            ..position = XAxisPosition.BOTTOM
            ..setValueFormatter(DateTimeFormatter(type: type, entries: entries))
            ..setGranularity(1);
          // ..setValueFormatter((controller));
        },
        legendSettingFunction: (legend, controller) {
          (controller as LineChartController).setViewPortOffsets(0, 0, 0, 0);
          legend.enabled = (false);
          var data = (controller as LineChartController).data;
          if (data != null) {
            var formatter = data.getDataSetByIndex(0).getFillFormatter();
            if (formatter is A) {
              formatter.setPainter(controller);
            }
          }
        },
        dragXEnabled: true,
        dragYEnabled: true,
        scaleXEnabled: false,
        scaleYEnabled: false,
        pinchZoomEnabled: true,
        description: desc);
  }

  void beforeBuild() {
    initController();
    controller?.axisLeftSettingFunction = (axisLeft, controller) {
      axisLeft
        ..textColor = (ColorUtils.BLACK)
        ..position = (YAxisLabelPosition.OUTSIDE_CHART)
        ..axisLineWidth = (.5)
        ..drawGridLines = (false)
        ..setAxisMinValue(0)
        ..setLabelCount1(models?.length)
        ..axisLineColor = (ColorUtils.BLACK);
    };
    controller?.xAxisSettingFunction = (xAxis, controller) {
      xAxis
        ..textColor = Colors.black
        ..drawGridLines = (false)
        ..position = XAxisPosition.BOTTOM
        ..setLabelCount1(models?.length)
        ..setValueFormatter(DateTimeFormatter(type: type, entries: entries))
        ..setGranularity(1);
      // ..setValueFormatter((controller));
    };
    controller?.legendSettingFunction = (legend, controller) {
      (controller as LineChartController).setViewPortOffsets(0, 0, 0, 0);
      legend.enabled = (false);
      var data = (controller as LineChartController).data;
      if (data != null) {
        var formatter = data.getDataSetByIndex(0).getFillFormatter();
        if (formatter is A) {
          formatter.setPainter(controller);
        }
      }
    };

    controller.data = LineData();
    controller?.data?.setDataSet(createDataset());
  }

  @override
  void didUpdateWidget(PassengerFlowLineChart oldWidget) {
    controller.animator
      ..reset()
      ..animateXY1(1000, 1000);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    beforeBuild();
    return Container(
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: AspectRatio(
        aspectRatio: 2,
        child: LineChart(controller),
      ),
    );
  }
}
