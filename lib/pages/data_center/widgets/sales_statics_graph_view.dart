import 'package:flutter/material.dart';

import 'package:taojuwu/models/data_center/sale_statistics_data_model.dart';
import 'package:taojuwu/pages/data_center/widgets/date_tag.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

import 'sales_analysis_line_chart.dart';
import 'sales_goods_statistics_bar_chart.dart';

class SalesStaticsGraphView extends StatefulWidget {
  final int type;
  SalesStaticsGraphView({Key key, this.type: 4}) : super(key: key);

  @override
  _SalesStaticsGraphViewState createState() => _SalesStaticsGraphViewState();
}

class _SalesStaticsGraphViewState extends State<SalesStaticsGraphView> {
  int get type => widget.type;
  Widget buildLoadingWidget(BuildContext context) {
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

            Text(
              '近一年销售分析',
              style: themeData.textTheme.title.copyWith(fontSize: UIKit.sp(24)),
            ),
            // Container(
            //   height: UIKit.height(360),
            //   child: DonutAutoLabelChart.withSampleData(),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ThemeData themeData = Theme.of(context);
    return ZYFutureBuilder(
        futureFunc: OTPService.saleData,
        params: {
          'type': widget.type,
          'date': '',
        },
        loadingWidget: buildLoadingWidget(context),
        builder: (BuildContext context, SaleStatisticsDataModelResp response) {
          SaleStatisticsDataModelWrapper wrapper = response?.data;
          List<SalesGoodsModel> goodsList = wrapper?.goodsList;
          List<SaleStatisticsDataModel> models = wrapper?.models;
          String date = wrapper?.time;
          return Container(
            margin: EdgeInsets.symmetric(
                vertical: UIKit.height(30), horizontal: UIKit.width(20)),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  DateTag(
                    date: date,
                  ),
                  _TextGraphView(),
                  SalesGoodsStaticsBarChart(
                    goodsList: goodsList,
                  ),
                  SalesAnalysisLineChart(
                    models: models,
                    type: widget.type,
                  )
                ],
              ),
            ),
          );
        });
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
