import 'package:flutter/material.dart';

import 'package:taojuwu/models/data_center/passenger_statistics_data_model.dart';
import 'package:taojuwu/pages/data_center/widgets/share_data_widget.dart';

import 'package:taojuwu/services/otp_service.dart';

import 'package:taojuwu/widgets/v_spacing.dart';

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

  PassengerFlowData passengerFlowData;
  PassengerStatisticsDataModelDataWrapper wrapper;
  List<PassengerStatisticsDataModel> models;

  String date;
  void handleData(PassengerStatisticsDataModelResp response) {
    wrapper = response?.data;
    passengerFlowData = wrapper?.passengerFlowData;
    models = wrapper?.statisticsDataModels ?? [];
    date = wrapper?.time;
    if (mounted) {
      setState(() {});
    }
  }

  void fetchData() {
    Map<String, dynamic> params = ShareDataWidget.of(context).data;
    OTPService.passengerData(context, params: params)
        .then((PassengerStatisticsDataModelResp response) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          DateTag(date: date),
          Expanded(
              child: SingleChildScrollView(
            key: UniqueKey(),
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
                // OrderPieChart(rateModels),
                OrderPieChart(
                  convertionRate: passengerFlowData != null
                      ? passengerFlowData?.convertionRate
                      : 0,
                  uncovertionRate: passengerFlowData != null
                      ? passengerFlowData?.unconvertionRate
                      : 0,
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
