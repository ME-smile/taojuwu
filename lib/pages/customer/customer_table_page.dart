import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/user/category_customer_model.dart';
import 'package:taojuwu/providers/client_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

class CustomerTablePage extends StatelessWidget {
  final int type;
  const CustomerTablePage({Key key, this.type}) : super(key: key);

  static List<Widget> tableHeader = [
    _tableHeader('姓名'),
    _tableHeader('性别'),
    _tableHeader('年龄'),
    _tableHeader('意向产品'),
    _tableHeader('入店时间'),
  ];

  static Widget _tableHeader(String title) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }

  static Map<String, dynamic> params = {
    'page_index': 1,
    'page_size': 20,
  };

  static Widget _tableCell(dynamic text, BuildContext context, int id,
      {CategoryCustomerModelBean bean}) {
    return TableCell(
      child:
          Consumer(builder: (BuildContext context, ClientProvider provider, _) {
        return InkWell(
          onTap: () {
            if (provider.isForSelectedClient) {
              RouteHandler.goCurtainDetailPage(context, provider?.goodsId ?? 0);
              provider?.isForSelectedClient = false;
              provider?.name = text;
              provider?.tel = bean?.clientMobile;
              provider?.gender = '${bean?.clientSex}';
              provider?.clientId = bean?.id;
              provider?.saveClientInfo(
                  name: text,
                  clientId: id,
                  tel: '${bean?.clientMobile}',
                  provinceId: '${bean?.provinceId}',
                  cityId: '${bean?.cityId}',
                  gender: '${bean?.clientSex}',
                  districtId: '${bean?.districtId}');
            } else {
              RouteHandler.goCustomerDetailPage(context, id);
            }
          },
          child: Padding(
            child: Center(child: Text('$text' ?? '-')),
            padding: EdgeInsets.symmetric(vertical: UIKit.height(30)),
          ),
        );
      }),
    );
  }

  static CategoryCustomerModelListWrapper wrapper;
  static List<CategoryCustomerModelBean> beans;
  @override
  Widget build(BuildContext context) {
    params.addAll({'client_type': type});
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('初谈客户'),
        centerTitle: true,
        bottom: PreferredSize(
            child: Row(
              children: tableHeader,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            preferredSize: Size.fromHeight(UIKit.height(48))),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: ZYFutureBuilder(
              futureFunc: OTPService.categoryUserList,
              params: params,
              builder: (BuildContext context,
                  CategoryCustomerModelListResp response) {
                wrapper = response.data;
                beans = wrapper.data;

                return Table(
                  children: List.generate(beans.length, (int i) {
                    CategoryCustomerModelBean bean = beans[i];
                    return TableRow(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: themeData.dividerColor))),
                        children: [
                          _tableCell(bean?.clientName ?? '-', context, bean?.id,
                              bean: bean),
                          _tableCell(
                              Constants.GENDER_MAP[bean?.clientSex] ?? '未知',
                              context,
                              bean?.id,
                              bean: bean),
                          _tableCell(bean?.clientAge ?? '-', context, bean?.id,
                              bean: bean),
                          _tableCell(
                              bean?.goodCategory ?? '-', context, bean?.id,
                              bean: bean),
                          _tableCell(bean?.enterTime ?? '-', context, bean?.id,
                              bean: bean),
                        ]);
                  }),
                );
              }),
        ),
      ),
    );
  }
}
