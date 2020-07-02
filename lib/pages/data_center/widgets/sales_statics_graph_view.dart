import 'package:flutter/material.dart';

import 'package:taojuwu/models/data_center/sale_statistics_data_model.dart';
import 'package:taojuwu/pages/data_center/widgets/date_tag.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'sales_analysis_line_chart.dart';
import 'sales_goods_statistics_bar_chart.dart';
import 'share_data_widget.dart';

class SalesStaticsGraphView extends StatefulWidget {
  final int type;
  SalesStaticsGraphView({Key key, this.type: 4}) : super(key: key);

  @override
  _SalesStaticsGraphViewState createState() => _SalesStaticsGraphViewState();
}

class _SalesStaticsGraphViewState extends State<SalesStaticsGraphView> {
  int get type => widget.type;

  void fetchData() {
    Map<String, dynamic> params = ShareDataWidget.of(context).data;
    OTPService.saleData(context, params: params)
        .then((SaleStatisticsDataModelResp response) {
      if (response.valid) {
        handleData(response);
      }
    }).catchError((err) => err);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  List<SalesGoodsModel> goodsList;
  List<SaleStatisticsDataModel> models;
  String date;
  void handleData(SaleStatisticsDataModelResp response) {
    SaleStatisticsDataModelWrapper wrapper = response?.data;
    goodsList = wrapper?.goodsList;
    models = wrapper?.models;
    date = wrapper?.time;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // ThemeData themeData = Theme.of(context);
    return Container(
      child: Column(
        children: <Widget>[
          DateTag(
            date: date,
          ),
          Expanded(
              child: SingleChildScrollView(
            key: UniqueKey(),
            child: ListBody(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _TextGraphView(),
                SalesGoodsStaticsBarChart(
                  goodsList: goodsList,
                ),
                SalesAnalysisLineChart(
                  models: models,
                  type: widget.type,
                ),
                VSpacing(20),
                Offstage(
                  offstage: true,
                  child: Text(ShareDataWidget.of(context).data.toString()),
                )
              ],
            ),
          ))
        ],
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
