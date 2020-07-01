import 'package:flutter/material.dart';
import 'package:taojuwu/models/data_center/sale_analysis_data_model.dart';
import 'package:taojuwu/pages/data_center/widgets/title_tag.dart';
import 'package:taojuwu/services/otp_service.dart';

import 'package:taojuwu/widgets/zy_future_builder.dart';

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
        // List<SaleGoodsCount> goodsList = wrapper?.goodsList;
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
