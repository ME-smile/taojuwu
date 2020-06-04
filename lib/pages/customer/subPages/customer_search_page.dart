import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';

import 'package:taojuwu/models/user/customer_model.dart';

import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/widgets/no_data.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

class CustomerSearchPage extends StatefulWidget {
  final String keyword;

  CustomerSearchPage({
    Key key,
    this.keyword,
  }) : super(key: key);

  @override
  _CustomerSearchPageState createState() => _CustomerSearchPageState();
}

class _CustomerSearchPageState extends State<CustomerSearchPage> {
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
        }
      }
    }
    beans.sort((CustomerModelBean a, CustomerModelBean b) {
      return a.headWord.codeUnitAt(0) - b.headWord.codeUnitAt(0);
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
          child: ListTile(
            title: Text(model?.clientName),
            onTap: () {
              RouteHandler.goCustomerDetailPage(context, model?.id);
            },
          ),
        )
      ],
    );
  }

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZYFutureBuilder(
        futureFunc: OTPService.userList,
        params: {'keyword': widget.keyword},
        builder: (BuildContext context, CustomerModelListResp response) {
          customerModelWrapper = response?.data;

          beans = customerModelWrapper?.data;
          _handleList(beans);
          return Scaffold(
            appBar: AppBar(
              title: Text('搜索结果'),
              centerTitle: true,
            ),
            body: beans == null || beans?.isEmpty == true
                ? NoData(
                    isFromSearch: true,
                  )
                : AzListView(
                    data: beans,
                    topData: hotBeans,
                    itemBuilder: (context, model) => _buildListItem(model),
                    suspensionWidget: _buildSusWidget(_suspensionTag),
                    isUseRealIndex: true,
                    itemHeight: _itemHeight,
                    suspensionHeight: _suspensionHeight,
                    onSusTagChanged: _onSusTagChanged,
                    // showCenterTip: false,
                  ),
          );
        });
  }
}
