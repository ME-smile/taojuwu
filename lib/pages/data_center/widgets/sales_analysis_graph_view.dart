import 'package:flutter/material.dart';
import 'package:taojuwu/pages/data_center/widgets/title_tag.dart';
import 'package:taojuwu/utils/ui_kit.dart';

import 'passenger_graph_view.dart';

class SalesAnalysisGraphView extends StatefulWidget {
  SalesAnalysisGraphView({Key key}) : super(key: key);

  @override
  _SalesAnalysisGraphViewState createState() => _SalesAnalysisGraphViewState();
}

class _SalesAnalysisGraphViewState extends State<SalesAnalysisGraphView> {
  @override
  Widget build(BuildContext context) {
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
  const CustomerSegmentFeature({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2;
    return Container(
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              TitleTag('性别'),
              Container(
                width: width,
                height: width,
                child: DonutAutoLabelChart.withSampleData(),
              ),
              Text('女性：30位 75%'),
              Text('男性：10位 25%')
            ],
          ),
          Column(
            children: <Widget>[
              TitleTag('年龄段'),
              Container(
                width: width,
                height: width,
                child: DonutAutoLabelChart.withSampleData(),
              ),
              Text('女性：30位 75%'),
              Text('男性：10位 25%')
            ],
          )
        ],
      ),
    );
  }
}

class CustomerPreferStyleView extends StatelessWidget {
  const CustomerPreferStyleView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleTag('偏好风格'),
          Container(
            height: UIKit.height(400),
            child: CustomAxisTickFormatters.withSampleData(),
          )
        ],
      ),
    );
  }
}
