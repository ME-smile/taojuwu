import 'package:flutter/material.dart';
import 'package:taojuwu/models/user/customer_detail_model.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

import 'widgets/custoemr_info_frame.dart';
import 'widgets/customer_profile_header.dart';

import 'widgets/kongo_bar.dart';

class CustomerDetailPage extends StatelessWidget {
  final int id;

  const CustomerDetailPage(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8F8),
      appBar: AppBar(
        title: Text('客户详情'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                RouteHandler.goCustomerEditPage(context, title: '编辑客户', id: id);
              },
              child: Text('编辑')),
        ],
      ),
      body: ZYFutureBuilder(
          futureFunc: OTPService.customerDetail,
          params: {'id': id},
          builder: (BuildContext context, CustomerDetailModelResp response) {
            CustomerDetailModel bean = response.data;
            return SingleChildScrollView(
              child: Column(children: <Widget>[
                CustomerProfileHeader(
                  name: bean?.clientName,
                  type: bean?.clientType,
                  age: bean?.clientAge,
                  address: bean?.address,
                  gender: bean?.clientSex,
                ),
                KongoBar(
                  id: bean?.id,
                  name: bean?.clientName,
                ),
                CustomerInfoFrame(
                  model: bean,
                )
              ]),
            );
          }),
    );
  }
}
