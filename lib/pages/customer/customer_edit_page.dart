import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/models/user/customer_detail_model.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/pages/customer/widgets/feature_info_segment.dart';

import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

import 'widgets/base_info_segment.dart';

class CustomerEditPage extends StatefulWidget {
  final String title;
  final int id;
  CustomerEditPage({Key key, this.title: '编辑客户', this.id}) : super(key: key);

  @override
  _CustomerEditPageState createState() => _CustomerEditPageState();
}

class _CustomerEditPageState extends State<CustomerEditPage> {
  final Map<String, String> params = {
    'id': '',
    'client_name': '',
    'client_mobile': '',
    'client_wx': '',
    'client_sex': '',
    'enter_time': '',
    'style': '',
    'goods_category_id': '',
    'province_id': '',
    'city_id': '',
    'district_id': '',
    'shop_id': '',
    'client_age': '',
    'detail_address': ''
  };
  CustomerDetailModel bean;
  void initParams(CustomerDetailModel bean) {
    params['id'] = '${bean?.id ?? ''}';
    params['client_name'] = '${bean?.clientName ?? ''}';
    params['client_sex'] = '${bean?.clientSex ?? '0'}';
    params['client_mobile'] = '${bean?.clientMobile ?? ''}';
    params['client_wx'] = '${bean?.clientWx ?? ''}';
    params['enter_time'] = '${bean?.createAt ?? ''}';
    params['province_id'] = '${bean?.provinceId ?? ''}';
    params['city_id'] = '${bean?.cityId ?? ''}';
    params['district_id'] = '${bean?.districtId ?? ''}';
    params['client_age'] = '${bean?.clientAge ?? ''}';
    params['shop_id'] = '${bean?.shopId ?? ''}';
    params['detail_address'] = '${bean?.detailAddress ?? ''}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                String name = params['client_name'] ?? '';
                if (name == null || name.trim().isEmpty) {
                  return CommonKit.showInfo('用户名不能为空哦');
                }
                if (name.length > 12 || name.length < 2) {
                  return CommonKit.showInfo('用户名在2-12个字符之间哟');
                }
                if (!RegexUtil.isMobileSimple(params['client_mobile'].trim())) {
                  return CommonKit.showInfo('请输入正确的手机号');
                }

                OTPService.addUser(params).then((ZYResponse response) {
                  if (response?.valid == true) {
                    Navigator.of(context).pop();
                    // RouteHandler.goCustomerPage(context,
                    //     isReplaceMode: true);
                  }
                }).catchError((err) => err);
              },
              child: Text('完成'))
        ],
      ),
      body: SingleChildScrollView(
        child: widget.id == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BaseInfoSegment(
                    params: params,
                  ),
                  FeatureInfoSegment(
                    params: params,
                  ),
                ],
              )
            : ZYFutureBuilder(
                futureFunc: OTPService.customerDetail,
                params: {'id': widget.id},
                builder:
                    (BuildContext context, CustomerDetailModelResp response) {
                  bean = response.data;
                  initParams(bean);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      BaseInfoSegment(
                        model: bean,
                        params: params,
                      ),
                      FeatureInfoSegment(
                        model: bean,
                        params: params,
                      ),
                    ],
                  );
                }),
      ),
    );
  }
}
