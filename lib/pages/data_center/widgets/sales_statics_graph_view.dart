import 'package:flutter/material.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'passenger_graph_view.dart';

class SalesStaticsGraphView extends StatefulWidget {
  SalesStaticsGraphView({Key key}) : super(key: key);

  @override
  _SalesStaticsGraphViewState createState() => _SalesStaticsGraphViewState();
}

class _SalesStaticsGraphViewState extends State<SalesStaticsGraphView> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: UIKit.height(30), horizontal: UIKit.width(20)),
        color: themeData.primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _TextGraphView(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
              child: Text(
                '各类目销量数据',
                style:
                    themeData.textTheme.title.copyWith(fontSize: UIKit.sp(24)),
              ),
            ),
            Container(
              height: UIKit.height(360),
              child: SimpleBarChart.withSampleData(),
            ),
            Text(
              '近一年销售分析',
              style: themeData.textTheme.title.copyWith(fontSize: UIKit.sp(24)),
            ),
            Container(
              height: UIKit.height(360),
              child: DonutAutoLabelChart.withSampleData(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextGraphView extends StatelessWidget {
  const _TextGraphView({Key key}) : super(key: key);
  static const List items = [
    {'title': '订单销售总金额', 'data': '0.0'},
    {'title': '已收金额', 'data': '0.0'},
    {'title': '未收金额', 'data': '0.0'}
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (int i) {
          return _dataItem(items[i]['title'], items[i]['data']);
        }),
      ),
    );
  }

  Widget _dataItem(String title, String data) {
    return Container(
      child: Column(
        children: <Widget>[Text(title), Text(data)],
      ),
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class CustomAxisTickFormatters extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  CustomAxisTickFormatters(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory CustomAxisTickFormatters.withSampleData() {
    return new CustomAxisTickFormatters(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Formatter for numeric ticks using [NumberFormat] to format into currency
    ///
    /// This is what is used in the [NumericAxisSpec] below.
    final simpleCurrencyFormatter =
        new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
            new NumberFormat.compactSimpleCurrency());

    /// Formatter for numeric ticks that uses the callback provided.
    ///
    /// Use this formatter if you need to format values that [NumberFormat]
    /// cannot provide.
    ///
    /// To see this formatter, change [NumericAxisSpec] to use this formatter.
    // final customTickFormatter =
    //   charts.BasicNumericTickFormatterSpec((num value) => 'MyValue: $value');

    return new charts.TimeSeriesChart(seriesList,
        animate: animate,
        // Sets up a currency formatter for the measure axis.
        primaryMeasureAxis: new charts.NumericAxisSpec(
            tickFormatterSpec: simpleCurrencyFormatter),

        /// Customizes the date tick formatter. It will print the day of month
        /// as the default format, but include the month and year if it
        /// transitions to a new month.
        ///
        /// minute, hour, day, month, and year are all provided by default and
        /// you can override them following this pattern.
        domainAxis: new charts.DateTimeAxisSpec(
            tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                day: new charts.TimeFormatterSpec(
                    format: 'd', transitionFormat: 'MM/dd/yyyy'))));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<MyRow, DateTime>> _createSampleData() {
    final data = [
      new MyRow(new DateTime(2017, 9, 25), 6),
      new MyRow(new DateTime(2017, 9, 26), 8),
      new MyRow(new DateTime(2017, 9, 27), 6),
      new MyRow(new DateTime(2017, 9, 28), 9),
      new MyRow(new DateTime(2017, 9, 29), 11),
      new MyRow(new DateTime(2017, 9, 30), 15),
      new MyRow(new DateTime(2017, 10, 01), 25),
      new MyRow(new DateTime(2017, 10, 02), 33),
      new MyRow(new DateTime(2017, 10, 03), 27),
      new MyRow(new DateTime(2017, 10, 04), 31),
      new MyRow(new DateTime(2017, 10, 05), 23),
    ];

    return [
      new charts.Series<MyRow, DateTime>(
        id: 'Cost',
        domainFn: (MyRow row, _) => row.timeStamp,
        measureFn: (MyRow row, _) => row.cost,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class MyRow {
  final DateTime timeStamp;
  final int cost;
  MyRow(this.timeStamp, this.cost);
}
