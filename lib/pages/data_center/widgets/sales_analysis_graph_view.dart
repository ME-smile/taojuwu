import 'package:flutter/material.dart';
import 'package:taojuwu/models/data_center/sale_analysis_data_model.dart';
import 'package:taojuwu/pages/data_center/widgets/title_tag.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'age_pie_chart.dart';
import 'date_tag.dart';
import 'gender_pie_chart.dart';

class SalesAnalysisGraphView extends StatefulWidget {
  final int type;
  SalesAnalysisGraphView({Key key, this.type}) : super(key: key);

  @override
  _SalesAnalysisGraphViewState createState() => _SalesAnalysisGraphViewState();
}

class _SalesAnalysisGraphViewState extends State<SalesAnalysisGraphView> {
  @override
  Widget build(BuildContext context) {
    return ZYFutureBuilder(
      futureFunc: OTPService.analysisData,
      builder: (BuildContext context, SaleAnalysisDataModelResp response) {
        SaleAnalysisDataModelWrapper wrapper = response?.data;
        List ageList = wrapper?.ageList;
        List<SaleGoodsCount> goodsList = wrapper?.goodsList;
        List genderList = wrapper?.genderList;
        String date = wrapper?.time;
        return SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                DateTag(
                  date: date ?? '0.00',
                ),
                CustomerSegmentFeature(
                  ageList: ageList,
                  genderList: genderList,
                ),
                CustomerPreferStyleView(
                  goodsList: goodsList,
                )
              ],
            ),
          ),
        );
      },
      loadingWidget: buildLoadingWidget(),
      params: {
        'type': widget.type,
      },
    );
  }

  Widget buildLoadingWidget() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            CustomerSegmentFeature(),
            CustomerPreferStyleView()
          ],
        ),
      ),
    );
  }
}

class CustomerSegmentFeature extends StatelessWidget {
  final List<int> ageList;
  final List<int> genderList;
  const CustomerSegmentFeature(
      {Key key,
      this.genderList: const [0, 0, 0],
      this.ageList: const [0, 0, 0, 0]})
      : super(key: key);

  int get female => genderList == null ? 0 : genderList[1] ?? 0;
  int get male => genderList == null ? 0 : genderList[2] ?? 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              TitleTag('性别'),
              // Container(
              //   width: width,
              //   height: width,
              //   child: DonutAutoLabelChart.withSampleData(),
              // ),

              GenderPieChart(
                female: female,
                male: male,
              )
            ],
          ),
          Column(
            children: <Widget>[
              TitleTag('年龄段'),
              // Container(
              //   width: width,
              //   height: width,
              //   child: DonutAutoLabelChart.withSampleData(),
              // ),
              AgePieChart(
                ageList: ageList,
              )
            ],
          )
        ],
      ),
    );
  }
}

class CustomerAgePieSector {
  final int index;
  final int count;
  final String label;
  final charts.Color color;
  CustomerAgePieSector({this.index, this.label, this.count, this.color});
}

class CustomerAgePieChart extends StatelessWidget {
  final List<int> ageList;
  const CustomerAgePieChart({Key key, this.ageList: const [0, 0, 0, 0]})
      : super(key: key);

  int get total {
    return ageList.reduce((int a, int b) => a + b);
  }

  List<CustomerAgePieSector> get sectorList {
    if (total == 0) {
      return [CustomerAgePieSector(index: 0, label: '暂无数据', count: 1)];
    }
    List arr = ageList;
    if (ageList == null || ageList.length != 4) {
      arr = [0, 0, 0, 0];
    }
    Map dict = {
      0: '20岁以下',
      1: '20-35岁',
      2: '30-50岁',
      3: '50岁以上',
    };

    return List.generate(4, (int i) {
      return CustomerAgePieSector(
          index: i, label: '${dict[i]}\n${arr[i]}位', count: arr[i]);
    });
  }

  List<charts.Series<CustomerAgePieSector, int>> get series {
    return [
      charts.Series<CustomerAgePieSector, int>(
          id: 'age',
          labelAccessorFn: (CustomerAgePieSector sector, _) => sector.label,
          domainFn: (CustomerAgePieSector sector, _) => sector.index,
          measureFn: (CustomerAgePieSector sector, _) => sector.count,
          // colorFn: (CustomerAgePieSector sector, _) => sector.color,
          data: sectorList)
    ];
  }

  String getLegendText(int index) {
    CustomerAgePieSector sector = sectorList[index];
    return sector.label;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width / 2,
      child: AspectRatio(
        aspectRatio: .8,
        child: new charts.PieChart(series,
            animate: true,
            behaviors: [
              charts.DatumLegend(
                  position: charts.BehaviorPosition.inside,
                  showMeasures: true,
                  desiredMaxRows: 2,
                  measureFormatter: (num value) {
                    return sectorList[value].label;
                  })
            ],
            defaultRenderer:
                new charts.ArcRendererConfig(arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.auto),
            ])),
      ),
    );
  }
}

class CustomerPreferStyleBarChart extends StatelessWidget {
  final List<SaleGoodsCount> goodsList;
  const CustomerPreferStyleBarChart({Key key, this.goodsList: const []})
      : super(key: key);

  List<charts.Series<SaleGoodsCount, String>> get series {
    return [
      charts.Series<SaleGoodsCount, String>(
          id: 'style',
          labelAccessorFn: (SaleGoodsCount bean, _) => bean.name,
          domainFn: (SaleGoodsCount bean, _) => bean.name,
          measureFn: (SaleGoodsCount bean, _) => bean.count,
          // colorFn: (CustomerAgePieSector sector, _) => sector.color,
          data: goodsList ?? [])
    ];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: new charts.BarChart(
          series,
          animate: true,
        ),
      ),
    );
  }
}

class CustomerPreferStyleView extends StatelessWidget {
  final List<SaleGoodsCount> goodsList;
  const CustomerPreferStyleView({Key key, this.goodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleTag('偏好风格'),
          // Container(
          //   height: UIKit.height(400),
          //   child: CustomAxisTickFormatters.withSampleData(),
          // )
          CustomerPreferStyleBarChart(
            goodsList: goodsList,
          )
        ],
      ),
    );
  }
}
