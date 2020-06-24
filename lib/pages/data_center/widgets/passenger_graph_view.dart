import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/data_center/statistics_data_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

import 'title_tag.dart';

class PassengerGraphView extends StatefulWidget {
  final int type;
  PassengerGraphView({Key key, this.type}) : super(key: key);

  @override
  _PassengerGraphViewState createState() => _PassengerGraphViewState();
}

class _PassengerGraphViewState extends State<PassengerGraphView> {
  /// Create one series with sample hard coded data.
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  PassengerFlowData passengerFlowData;
  PassengerStatisticsDataModelDataWrapper wrapper;
  List<PassengerStatisticsDataModel> models;
  fetchData() {
    OTPService.statisticsData(context, params: {
      'type': 2,
      'date': '',
    }).then((PassengerStatisticsDataModelResp response) {
      Future.delayed(Constants.TRANSITION_DURATION, () {
        setState(() {
          isLoading = false;
          wrapper = response?.data;
          passengerFlowData = wrapper?.passengerFlowData;
          models = wrapper?.statisticsDataModels;
        });
      });
    }).catchError((err) => err);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return isLoading
        ? LoadingCircle()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
            color: themeData.primaryColor,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                  Container(
                    height: UIKit.height(360),
                    child: DonutAutoLabelChart.withData(passengerFlowData),
                  ),
                  TitleTag('转单率趋势图'),
                  Container(
                    height: UIKit.height(400),
                    child: CustomAxisTickFormatters(
                      models,
                    ),
                  ),
                  VSpacing(20),
                ],
              ),
            ),
          );
  }
}

class DonutAutoLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutAutoLabelChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory DonutAutoLabelChart.withData(PassengerFlowData data) {
    return new DonutAutoLabelChart(
      _createData(data),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,

        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        //
        // [ArcLabelDecorator] will automatically position the label inside the
        // arc if the label will fit. If the label will not fit, it will draw
        // outside of the arc with a leader line. Labels can always display
        // inside or outside using [LabelPosition].
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 100,
            symbolRenderer: CircleSymbolRenderer(isSolid: false),
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<ConvertionRateData, double>> _createData(
      PassengerFlowData model) {
    final data = [
      new ConvertionRateData(model?.convertionRate, '转单率',
          color: charts.MaterialPalette.blue.shadeDefault),

      new ConvertionRateData(model?.unconvertionRate, '未转单率',
          color: charts.MaterialPalette.black),
      // new LinearSales(0, 100),
      // new LinearSales(1, 75),
      // new LinearSales(2, 25),
      // new LinearSales(3, 5),
    ];

    return [
      new charts.Series<ConvertionRateData, double>(
        id: 'Sales',
        domainFn: (ConvertionRateData bean, _) => 1,
        measureFn: (ConvertionRateData bean, _) => bean.percentage,
        data: data,
        colorFn: (ConvertionRateData bean, _) => bean.color,

        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (ConvertionRateData bean, _) =>
            '${bean.label}:${bean.percentageStr}',
      )
    ];
  }
}

class CustomAxisTickFormatters extends StatelessWidget {
  final bool animate;
  final List<PassengerStatisticsDataModel> models;
  CustomAxisTickFormatters(this.models, {this.animate});

  List<TickSpec<DateTime>> get xTickers {
    List<TickSpec<DateTime>> tickers = [];
    for (int i = 0; i < models?.length; i++) {
      if (i % 2 == 0) {
        tickers.add(TickSpec(
          models[i].date,
        ));
      }
    }
    return tickers;
  }

  List<charts.Series<PassengerFlowDayData, DateTime>> get series {
    final data = List.generate(
        models?.length, (int i) => PassengerFlowDayData(models[i]));
    return [
      new charts.Series<PassengerFlowDayData, DateTime>(
        id: 'cost',
        domainFn: (PassengerFlowDayData bean, _) => bean?.date,
        measureFn: (PassengerFlowDayData bean, _) => bean?.value,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    /// Formatter for numeric ticks using [NumberFormat] to format into currency
    ///
    /// This is what is used in the [NumericAxisSpec] below.

    /// Formatter for numeric ticks that uses the callback provided.
    ///
    /// Use this formatter if you need to format values that [NumberFormat]
    /// cannot provide.
    ///
    /// To see this formatter, change [NumericAxisSpec] to use this formatter.
    // final customTickFormatter =
    //   charts.BasicNumericTickFormatterSpec((num value) => 'MyValue: $value');

    return new charts.TimeSeriesChart(series,
        animate: true,
        // Sets up a currency formatter for the measure axis.
        // primaryMeasureAxis: new charts.NumericAxisSpec(
        //     tickFormatterSpec: simpleCurrencyFormatter),
        primaryMeasureAxis: charts.NumericAxisSpec(
            tickProviderSpec: BasicNumericTickProviderSpec(
                zeroBound: false,
                desiredMinTickCount: 10,
                desiredMaxTickCount: 20)),

        /// Customizes the date tick formatter. It will print the day of month
        /// as the default format, but include the month and year if it
        /// transitions to a new month.
        ///
        /// minute, hour, day, month, and year are all provided by default and
        /// you can override them following this pattern.

        domainAxis: new charts.DateTimeAxisSpec(
            tickProviderSpec: charts.StaticDateTimeTickProviderSpec(xTickers),
            tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                day: new charts.TimeFormatterSpec(
                    format: 'd', transitionFormat: 'M/d'))));
    // domainAxis: new charts.DateTimeAxisSpec(
    //     tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
    //         day: new charts.TimeFormatterSpec(
    //             format: 'd', transitionFormat: 'MM/dd/yyyy'))));
  }
}

/// Sample time series data type.
class MyRow {
  final DateTime timeStamp;
  final int cost;
  MyRow(this.timeStamp, this.cost);
}

class ConvertionRateData {
  final double percentage;
  final String label;
  final charts.Color color;
  String get percentageStr =>
      '${double.parse(percentage.toStringAsFixed(2)) * 100}%';
  ConvertionRateData(this.percentage, this.label, {this.color});
}

class PassengerFlowDayData {
  final PassengerStatisticsDataModel model;
  DateTime get date => model?.date ?? '';
  int get value => model?.value ?? 0;
  PassengerFlowDayData(this.model);
}

// class PassengerBezierChart extends StatelessWidget {
//   final List<PassengerStatisticsDataModel> models;
//   const PassengerBezierChart({Key key, this.models}) : super(key: key);

//   getData() {
//     return models?.map((item) =>
//         DataPoint<DateTime>(value: item.value?.toDouble(), xAxis: item.date));
//   }

//   DateTime get fromDate => models?.first?.date;
//   DateTime get toDate => models?.last?.date;
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 3,
//       child: BezierChart(
//           fromDate: fromDate,
//           toDate: toDate,
//           onIndicatorVisible: (val) {
//             print("Indicator Visible :$val");
//           },
//           onDateTimeSelected: (datetime) {
//             print("selected datetime: $datetime");
//           },
//           onScaleChanged: (scale) {
//             print("Scale: $scale");
//           },
//           config: BezierChartConfig(
//             footerHeight: 0,
//             displayYAxis: true,
//             showVerticalIndicator: true,

//             verticalIndicatorFixedPosition: false,
//             snap: true,
//             xAxisTextStyle:
//                 TextStyle(fontSize: UIKit.sp(16), color: Color(0xFF333333)),
//           ),
//           bezierChartScale: BezierChartScale.WEEKLY,
//           footerDateTimeBuilder: (DateTime value, BezierChartScale scaleType) {
//             return DateUtil.formatDate(value, format: 'MM/dd');
//           },
//           series: [
//             BezierLine(
//                 lineColor: const Color(0xFF5C89FF),
//                 data: List.generate(
//                     models?.length ?? 0,
//                     (int i) => DataPoint<DateTime>(
//                         value: models[i].value?.toDouble(),
//                         xAxis: models[i]?.date)))
//           ]),
//     );
//   }
// }
