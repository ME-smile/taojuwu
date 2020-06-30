import 'package:flutter/material.dart';

import 'package:taojuwu/models/data_center/passenger_statistics_data_model.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';

import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

import 'date_tag.dart';
import 'title_tag.dart';
import 'order_pie_chart.dart';
import 'passenger_flow_line_chart.dart';

class PassengerGraphView extends StatefulWidget {
  final int type;
  PassengerGraphView({Key key, this.type}) : super(key: key);

  @override
  _PassengerGraphViewState createState() => _PassengerGraphViewState();
}

class _PassengerGraphViewState extends State<PassengerGraphView> {
  int get type => widget.type;
  bool isLoading = true;

  PassengerFlowData passengerFlowData;
  PassengerStatisticsDataModelDataWrapper wrapper;
  List<PassengerStatisticsDataModel> models;

  String date;
  void handleData(PassengerStatisticsDataModelResp response) {
    wrapper = response?.data;
    passengerFlowData = wrapper?.passengerFlowData;
    models = wrapper?.statisticsDataModels ?? [];
    date = wrapper?.time;
  }

  Widget buildLoadingWidget(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
      color: themeData.primaryColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DateTag(),
            TitleTag('自然客流'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('初谈：0'),
                Text('意向：0'),
                Text('跟进：0'),
                Text('成交：0')
              ],
            ),
            TitleTag('转单率'),
            OrderPieChart(
              convertionRate: 0.5,
              uncovertionRate: 0.5,
            ),
            // OrderPieChart(intRateModels),
            TitleTag('转单率趋势图'),

            // PassengerLinerChart([]),
            // PassengerBezierChart(models: models),
            VSpacing(20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return ZYFutureBuilder(
        futureFunc: OTPService.passengerData,
        params: {
          'type': widget.type,
          'date': '',
        },
        loadingWidget: buildLoadingWidget(context),
        builder:
            (BuildContext context, PassengerStatisticsDataModelResp response) {
          handleData(response);
          return Container(
            margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
            color: themeData.primaryColor,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DateTag(
                    date: date,
                  ),
                  TitleTag('自然客流'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('初谈：${passengerFlowData?.status0Num ?? 0}'),
                      Text('意向：${passengerFlowData?.status1Num ?? 0}'),
                      Text('跟进：${passengerFlowData?.status2Num ?? 0}'),
                      Text('成交：${passengerFlowData?.status3Num ?? 0}')
                    ],
                  ),
                  TitleTag('转单率'),
                  // OrderPieChart(rateModels),
                  OrderPieChart(
                    convertionRate: 0.5,
                    uncovertionRate: 0.5,
                  ),
                  TitleTag('转单率趋势图'),
                  // PassengerLinerChart(
                  //   models,
                  // ),
                  PassengerFlowLineChart(
                    models: models,
                    type: type,
                  ),
                  // PassengerBezierChart(
                  //   models: models,
                  //   type: widget.type,
                  // ),
                  VSpacing(20),
                ],
              ),
            ),
          );
        });
  }
}

// class DonutAutoLabelChart extends StatelessWidget {
//   final bool animate;
//   List<PassengerStatisticsDataModel> models;
//   DonutAutoLabelChart(this.models, {this.animate});

//   /// Creates a [PieChart] with sample data and no transition.
//   factory DonutAutoLabelChart.withData(PassengerFlowData data) {
//     return new DonutAutoLabelChart(
//       _createData(data),
//       // Disable animations for image tests.
//       animate: true,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new charts.PieChart(seriesList,
//         animate: animate,

//         // Configure the width of the pie slices to 60px. The remaining space in
//         // the chart will be left as a hole in the center.
//         //
//         // [ArcLabelDecorator] will automatically position the label inside the
//         // arc if the label will fit. If the label will not fit, it will draw
//         // outside of the arc with a leader line. Labels can always display
//         // inside or outside using [LabelPosition].
//         //
//         // Text style for inside / outside can be controlled independently by
//         // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
//         //
//         // Example configuring different styles for inside/outside:
//         //       new charts.ArcLabelDecorator(
//         //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
//         //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
//         defaultRenderer:
//             new charts.ArcRendererConfig(arcWidth: 100, arcRendererDecorators: [
//           new charts.ArcLabelDecorator(
//               labelPosition: charts.ArcLabelPosition.outside),
//         ]));
//   }

//   /// Create one series with sample hard coded data.
//   static List<charts.Series<ConvertionRateData, double>> _createData(
//       PassengerFlowData model) {
//     final data = [
//       new ConvertionRateData(0.25, '',
//           color: charts.MaterialPalette.cyan.shadeDefault),
//       new ConvertionRateData(0.25, '未转单率', color: charts.MaterialPalette.black),
//       new ConvertionRateData(0.25, '',
//           color: charts.MaterialPalette.cyan.shadeDefault),
//       new ConvertionRateData(0.25, '转单率', color: charts.MaterialPalette.black),

//       // new OrderPieChartSector(0, 100),
//       // new OrderPieChartSector(1, 75),
//       // new OrderPieChartSector(2, 25),
//       // new OrderPieChartSector(3, 5),
//     ];

//     return [
//       new charts.Series<ConvertionRateData, double>(
//         id: 'Sales',
//         domainFn: (ConvertionRateData bean, _) => 1,
//         measureFn: (ConvertionRateData bean, _) => bean.percentage,
//         data: data,
//         colorFn: (ConvertionRateData bean, _) => bean.color,
//         // Set a label accessor to control the text of the arc label.
//         labelAccessorFn: (ConvertionRateData bean, _) =>
//             '${bean.label}:${bean.percentageStr}',
//       )
//     ];
//   }
// }
