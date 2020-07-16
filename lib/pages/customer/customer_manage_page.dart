import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/user/customer_model.dart';

import 'package:taojuwu/pages/customer/widgets/menu_entry.dart';

import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/search_button.dart';
import 'package:taojuwu/widgets/user_add_button.dart';

class CustomerManagePage extends StatefulWidget {
  final int flag; // 0表示普通跳转 1 表示选择客户
  CustomerManagePage({Key key, this.flag: 0}) : super(key: key);

  @override
  _CustomerManagePageState createState() => _CustomerManagePageState();
}

class _CustomerManagePageState extends State<CustomerManagePage> {
  Map<String, dynamic> params = {
    'page_size': 20,
    'page_index': 1,
    'keyword': ''
  };

  bool isLoading = true;
  double height = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Constants.TRANSITION_DURATION, () {
      fetchData();
    });
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      // RenderObject renderObject = headerBuildContext.findRenderObject();
      setState(() {});
    });
  }

  void fetchData() {
    OTPService.userList(context, params: params)
        .then((CustomerModelListResp response) {
      if (mounted) {
        setState(() {
          customerModelWrapper = response?.data;
          _handleData(customerModelWrapper);
          beans = customerModelWrapper?.data;
          _handleList(beans);
          isLoading = false;
        });
      }
    }).catchError((err) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
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

  static const ENTRY_HEIGHT = 50.0;

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

  void saveInfoToTargetClient(CustomerModelBean model) {
    TargetClient targetClient = TargetClient.instance;
    targetClient.setClientName(model?.clientName);
    targetClient.setClientId(model?.id);
  }

  Widget _buildListItem(CustomerModelBean model) {
    String susTag = model.getSuspensionTag();
    susTag = (susTag == "★" ? "热门城市" : susTag);
    return AnimationConfiguration.staggeredList(
      position: model?.index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
            child: Column(
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
                    // Navigator.pop(context, model);
                    if (widget.flag == 1) {
                      saveInfoToTargetClient(model);
                      Navigator.of(context).pop();
                    } else {
                      RouteHandler.goCustomerDetailPage(context, model?.id);
                    }
                  },
                ))
          ],
        )),
      ),
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
      body: isLoading
          ? LoadingCircle()
          : Container(
              child: AnimationLimiter(
                  child: AzListView(
              data: beans,
              topData: hotBeans,
              header: AzListViewHeader(
                  height: (ENTRY_HEIGHT * entrys.length).toInt(),
                  builder: (BuildContext ctx) {
                    return Container(
                      // alignment: Alignment.centerLeft,
                      // padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(entrys.length, (int i) {
                          final item = entrys[i];
                          return MenuEntry(
                            title: item['title'],
                            iconPath: item['iconPath'],
                            number: item['number'],
                            showBorder: i != entrys.length - 1,
                            callback: () {
                              RouteHandler.goCustomerTablePage(
                                  context, item['type'],
                                  flag: widget.flag, replace: widget.flag == 1);
                            },
                          );
                        }),
                      ),
                    );
                  }),
              itemBuilder: (context, model) => _buildListItem(model),
              suspensionWidget: _buildSusWidget(_suspensionTag),
              isUseRealIndex: true,
              itemHeight: _itemHeight,
              suspensionHeight: _suspensionHeight,
              onSusTagChanged: _onSusTagChanged,
              // showCenterTip: false,
            ))),
    );
  }
}
