import 'package:flutter/material.dart';
import 'package:taojuwu/models/order/order_edit_log_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

class OrderEditLogPage extends StatelessWidget {
  final int id;
  final int type;
  const OrderEditLogPage({Key key, this.id, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑记录'),
        centerTitle: true,
        backgroundColor: themeData.scaffoldBackgroundColor,
      ),
      body: ZYFutureBuilder(
          futureFunc: OTPService.orderEditLog,
          params: {'order_id': id, 'type': type},
          builder: (BuildContext context, OrderEditLogModelResp response) {
            OrderEditLogModelWrapper wrapper = response?.data;
            List<OrderEitLogModel> models = wrapper?.list;
            return ListView.separated(
                itemBuilder: (BuildContext context, int i) {
                  return OrderEditLogCard(
                    model: models[i],
                  );
                },
                separatorBuilder: (BuildContext context, int i) {
                  return Divider(
                    height: .5,
                    indent: UIKit.width(20),
                    endIndent: UIKit.width(20),
                  );
                },
                itemCount: models?.length ?? 0);
          }),
    );
  }
}

class OrderEditLogCard extends StatelessWidget {
  final OrderEitLogModel model;
  const OrderEditLogCard({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.symmetric(
          horizontal: UIKit.width(20), vertical: UIKit.height(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            model?.userName ?? '',
            style:
                TextStyle(fontSize: UIKit.sp(30), fontWeight: FontWeight.w500),
          ),
          VSpacing(10),
          Text(
            '${model?.recordName ?? ''}${model?.recordTime ?? ''}',
            style:
                TextStyle(fontSize: UIKit.sp(26), fontWeight: FontWeight.w400),
          ),
          VSpacing(10),
          Text(
            '${model?.actionTimeStr ?? ''}',
            style: textTheme.caption,
          ),
        ],
      ),
    );
  }
}
