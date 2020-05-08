import 'package:flutter/material.dart';
import 'package:taojuwu/pages/data_center/widgets/passenger_graph_view.dart';
import 'package:taojuwu/utils/ui_kit.dart';

import 'widgets/sales_analysis_graph_view.dart';
import 'widgets/sales_statics_graph_view.dart';

class DataCenterPage extends StatefulWidget {
  DataCenterPage({Key key}) : super(key: key);

  @override
  _DataCenterPageState createState() => _DataCenterPageState();
}

class _DataCenterPageState extends State<DataCenterPage> {
  static const tabs = ['客流统计', '销售统计', '销售分析'];
  static const options = ['本周', '本月', '本季度', '本年', '更多'];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('数据中心'),
            centerTitle: true,
            bottom: PreferredSize(
                child: Column(
                  children: <Widget>[
                    TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: List.generate(tabs.length, (int i) {
                          return Text('${tabs[i]}');
                        })),
                    Container(
                      color: const Color(0xFFFFFAFAFA),
                      padding: EdgeInsets.symmetric(vertical: UIKit.height(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(options.length, (int i) {
                          return Text('${options[i]}');
                        }),
                      ),
                    ),
                  ],
                ),
                preferredSize: Size.fromHeight(60)),
          ),
          body: TabBarView(children: [
            PassengerGraphView(),
            SalesStaticsGraphView(),
            SalesAnalysisGraphView()
          ]),
        ));
  }
}
