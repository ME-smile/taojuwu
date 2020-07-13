import 'package:flutter/material.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/user/category_customer_model.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/no_data.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

class CustomerTablePage extends StatelessWidget {
  final int type;
  final int flag; // 0表示普通跳转 1 表示选择客户
  const CustomerTablePage({Key key, this.type, this.flag: 0}) : super(key: key);

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
    // 'page_index': 1,
    // 'page_size': 20,
  };

  void saveInfoToTargetClient(CategoryCustomerModelBean bean) {
    TargetClient targetClient = TargetClient.instance;
    targetClient.setClientId(bean?.id);
    targetClient.setClientName(bean?.clientName);
  }

  Widget _tableCell(dynamic text, BuildContext context, int id,
      {CategoryCustomerModelBean bean}) {
    return TableCell(
        child: InkWell(
      onTap: () {
        if (flag == 1) {
          saveInfoToTargetClient(bean);
          Navigator.of(context).pop();
        } else {
          RouteHandler.goCustomerDetailPage(context, id);
        }
      },
      child: Padding(
        child: Center(
            child: Text(
          '$text' ?? '-',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        )),
        padding: EdgeInsets.symmetric(vertical: UIKit.height(20)),
      ),
    ));
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
      body: Container(
        child: ZYFutureBuilder(
            futureFunc: OTPService.categoryUserList,
            params: params,
            builder:
                (BuildContext context, CategoryCustomerModelListResp response) {
              wrapper = response.data;
              beans = wrapper.data;
              // return ListView.separated(
              //     shrinkWrap: true,
              //     itemBuilder: (BuildContext context, int i) {
              //       CategoryCustomerModelBean bean = beans[i];
              //       return Row(
              //         children: <Widget>[
              //           _tableCell(bean?.clientName ?? '-', context, bean?.id,
              //               bean: bean),
              //           _tableCell(
              //               Constants.GENDER_MAP[bean?.clientSex] ?? '未知',
              //               context,
              //               bean?.id,
              //               bean: bean),
              //           _tableCell(bean?.clientAge ?? '-', context, bean?.id,
              //               bean: bean),
              //           _tableCell(bean?.goodCategory ?? '-', context, bean?.id,
              //               bean: bean),
              //           _tableCell(bean?.enterTime ?? '-', context, bean?.id,
              //               bean: bean),
              //         ],
              //       );
              //     },
              //     separatorBuilder: (BuildContext context, int i) {
              //       return Divider();
              //     },
              //     itemCount: beans?.length ?? 0);
              return Container(
                child: beans?.isEmpty == true
                    ? NoData()
                    : Table(
                        children: List.generate(beans?.length ?? 0, (int i) {
                          CategoryCustomerModelBean bean = beans[i];

                          return TableRow(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: .5,
                                          color: themeData.dividerColor))),
                              children: [
                                _tableCell(
                                    bean?.clientName ?? '-', context, bean?.id,
                                    bean: bean),
                                _tableCell(
                                    Constants.GENDER_MAP[bean?.clientSex] ??
                                        '未知',
                                    context,
                                    bean?.id,
                                    bean: bean),
                                _tableCell(
                                    bean?.clientAge ?? '-', context, bean?.id,
                                    bean: bean),
                                _tableCell(bean?.goodCategory ?? '-', context,
                                    bean?.id,
                                    bean: bean),
                                _tableCell(
                                    bean?.enterTime ?? '-', context, bean?.id,
                                    bean: bean),
                              ]);
                        }),
                      ),
              );
            }),
      ),
    );
  }
}
