import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/models/user/customer_model.dart';

import 'package:taojuwu/pages/customer/widgets/menu_entry.dart';
import 'package:taojuwu/providers/client_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/widgets/search_button.dart';
import 'package:taojuwu/widgets/user_add_button.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

class CustomerManagePage extends StatefulWidget {
  CustomerManagePage({Key key}) : super(key: key);

  @override
  _CustomerManagePageState createState() => _CustomerManagePageState();
}

class _CustomerManagePageState extends State<CustomerManagePage> {
  Map<String, dynamic> params = {
    'page_size': 20,
    'page_index': 1,
    'keyword': 0
  };
  ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  static List<Map<String, dynamic>> entrys = [
    {
      'iconPath': 'initial_customer@2x.png',
      'title': '初谈客户',
      'number': 0,
      'type': 0
    },
    {
      'iconPath': 'potential_customer@2x.png',
      'title': '意向客户',
      'number': 0,
      'type': 1
    },
    {
      'iconPath': 'track_customer@2x.png',
      'title': '跟进客户',
      'number': 0,
      'type': 2
    },
    {
      'iconPath': 'done_customer@2x.png',
      'title': '成交客户',
      'number': 0,
      'type': 3
    }
  ];
  int _suspensionHeight = 40;
  int _itemHeight = 50;
  String _suspensionTag = '#';
  CustomerModelWrapper customerModelWrapper;
  List<CustomerModelBean> beans;
  List<CustomerModelBean> hotBeans = [];
  void _handleList(List<CustomerModelBean> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      CustomerModelBean item = list[i];
      if (RegExp("[A-Z]").hasMatch(item.headWord)) {
        continue;
      } else {
        list[i].headWord = "#";
        if (!hotBeans.contains(item)) {
          hotBeans.add(item);
          // list.remove(item);
        }
      }
    }

    List<CustomerModelBean> tmpList = [];
    tmpList.addAll(beans);
    tmpList?.forEach((item) {
      if (hotBeans?.contains(item) == true) {
        beans?.remove(item);
      }
    });
    beans.sort((CustomerModelBean a, CustomerModelBean b) {
      return a.headWord.codeUnitAt(0) - b.headWord.codeUnitAt(0);
    });
  }

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  Widget _buildSusWidget(String susTag) {
    susTag = (susTag == "★" ? "热门城市" : susTag);
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  Widget _buildListItem(CustomerModelBean model) {
    String susTag = model.getSuspensionTag();
    susTag = (susTag == "★" ? "热门城市" : susTag);
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model?.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: Consumer<ClientProvider>(
              builder: (BuildContext context, ClientProvider provider, _) {
            return ListTile(
              title: Text(model?.clientName),
              onTap: () {
                // Navigator.pop(context, model);
                if (provider.isForSelectedClient) {
                  provider?.isForSelectedClient = false;
                  provider?.clientId = model?.id ?? -1;
                  provider?.saveClientInfo(
                      clientId: model?.id ?? -1, name: model?.clientName);
                  Navigator.of(context).pop();
                } else {
                  RouteHandler.goCustomerDetailPage(context, model?.id);
                }
              },
            );
          }),
        )
      ],
    );
  }

  _handleData(CustomerModelWrapper data) {
    entrys[0]['number'] = data?.status0;
    entrys[1]['number'] = data?.status1;
    entrys[2]['number'] = data?.status2;
    entrys[3]['number'] = data?.status3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('客户管理'),
        actions: <Widget>[
          SearchButton(
            type: 2,
          ),
          UserAddButton(),
        ],
      ),
      body: SingleChildScrollView(
        controller: controller,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ZYFutureBuilder(
              futureFunc: OTPService.userList,
              params: params,
              builder: (BuildContext context, CustomerModelListResp response) {
                customerModelWrapper = response?.data;
                _handleData(customerModelWrapper);
                beans = customerModelWrapper?.data;
                _handleList(beans);
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(entrys.length, (int i) {
                            final item = entrys[i];
                            return MenuEntry(
                              title: item['title'],
                              iconPath: item['iconPath'],
                              number: item['number'],
                              callback: () {
                                RouteHandler.goCustomerTablePage(
                                    context, item['type']);
                              },
                            );
                          }),
                        ),
                      ),
                      Flexible(
                          child: AzListView(
                        data: beans,
                        topData: hotBeans,

                        itemBuilder: (context, model) => _buildListItem(model),
                        suspensionWidget: _buildSusWidget(_suspensionTag),
                        isUseRealIndex: true,
                        itemHeight: _itemHeight,
                        suspensionHeight: _suspensionHeight,
                        onSusTagChanged: _onSusTagChanged,
                        // showCenterTip: false,
                      )),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
