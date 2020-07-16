import 'package:flutter/material.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/pages/order/widgets/order_card.dart';
import 'package:taojuwu/services/otp_service.dart';

import 'package:taojuwu/widgets/no_data.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

import 'package:taojuwu/widgets/zy_future_builder.dart';

class OrderSearchPage extends StatelessWidget {
  final String keyword;
  const OrderSearchPage({Key key, this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZYFutureBuilder(
        futureFunc: OTPService.orderList,
        params: {'keyword': keyword},
        builder: (BuildContext context, OrderModelListResp response) {
          OrderModelDataWrapper wrapper = response.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('搜索结果'),
              centerTitle: true,
            ),
            body: wrapper == null || wrapper?.data?.isEmpty == true
                ? NoData(
                    isFromSearch: true,
                  )
                : ListView.separated(
                    itemBuilder: (BuildContext context, int i) {
                      return OrderCard(
                        wrapper.data[i],
                        canClick: true,
                      );
                    },
                    separatorBuilder: (BuildContext context, int i) {
                      return VSpacing(20);
                    },
                    itemCount: wrapper?.data?.length ?? 0),
          );
        });
  }
}
