import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/refresh_customer_data.dart';
import 'package:taojuwu/repository/user/customer_detail_model.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/widgets/loading.dart';

import 'widgets/custoemr_info_frame.dart';
import 'widgets/customer_profile_header.dart';

import 'widgets/kongo_bar.dart';

class CustomerDetailPage extends StatefulWidget {
  final int id;

  const CustomerDetailPage(this.id, {Key key}) : super(key: key);

  @override
  _CustomerDetailPageState createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  CustomerDetailModel bean;
  bool isLoading = true;

  StreamSubscription subscription;
  @override
  void initState() {
    super.initState();
    fetchData();

    subscription =
        Application.eventBus.on<RefreshCustomerData>().listen((event) {
      fetchData();
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    subscription = null;
    super.dispose();
  }

  fetchData() {
    OTPService.customerDetail(context, params: {'id': widget.id})
        .then((CustomerDetailModelResp response) {
      setState(() {
        bean = response.data;
        isLoading = false;
      });
    });
  }

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
                RouteHandler.goCustomerEditPage(context,
                        title: '编辑客户', id: widget.id)
                    .then((value) {
                  if (value != null) {
                    setState(() {
                      bean = value;
                    });
                  }
                });
              },
              child: Text('编辑')),
        ],
      ),
      body: isLoading
          ? LoadingCircle()
          : SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
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
            ),
    );
  }
}
