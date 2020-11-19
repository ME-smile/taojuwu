import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/event_bus/events/select_client_event.dart';
import 'package:taojuwu/repository/user/customer_model.dart';

import 'package:taojuwu/view/customer/widgets/menu_entry.dart';

import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/network_error.dart';
import 'package:taojuwu/widgets/search_button.dart';
import 'package:taojuwu/widgets/user_add_button.dart';
import 'package:taojuwu/widgets/zy_raised_button.dart';

class CustomerManagePage extends StatefulWidget {
  final int flag; // 0表示普通跳转 1 表示选择客户
  CustomerManagePage({Key key, this.flag: 0}) : super(key: key);

  @override
  _CustomerManagePageState createState() => _CustomerManagePageState();
}

class _CustomerManagePageState extends State<CustomerManagePage>
    with RouteAware {
  Map<String, dynamic> params = {
    'page_size': 20,
    'page_index': 1,
    'keyword': ''
  };

  bool isLoading = true;
  bool hasError = false;
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

  @override
  void didChangeDependencies() {
    Application.routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    fetchData();
    super.didPopNext();
  }

  void fetchData() {
    setState(() {
      hasError = false;
      isLoading = true;
    });
    OTPService.userList(context, params: params)
        .then((CustomerModelListResp response) {
      customerModelWrapper = response?.data;
      _handleData(customerModelWrapper);
      beans = customerModelWrapper?.data;
      _handleList(beans);
    }).catchError((err) {
      hasError = true;
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    Application.routeObserver.unsubscribe(this);
    super.dispose();
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
  int _suspensionHeight = 32;
  int _itemHeight = 50;
  String _suspensionTag = '#';
  CustomerModelWrapper customerModelWrapper;
  List<CustomerModelBean> beans;
  List<CustomerModelBean> hotBeans = [];
  void _handleList(List<CustomerModelBean> list) {
    hotBeans.clear();
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

  static const ENTRY_HEIGHT = 64.0;

  Widget _buildSusWidget(String susTag) {
    susTag = (susTag == "★" ? "热门城市" : susTag);
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xFFF5F5F9),
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
            Container(
                color: Theme.of(context).primaryColor,
                height: _itemHeight.toDouble(),
                child: ListTile(
                  isThreeLine: false,
                  dense: true,
                  title: Text(
                    model?.clientName,
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    // Navigator.pop(context, model);
                    if (widget.flag == 1) {
                      Application.eventBus.fire(SelectClientEvent(
                          TargetClient.fromCustomerModelBean(model)));
                      Navigator.of(context)..pop()..pop();
                    } else {
                      RouteHandler.goCustomerDetailPage(context, model?.id);
                    }
                  },
                )),
            Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
            )
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
          : hasError
              ? Container(
                  height: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: NetworkErrorWidget(
                    callback: fetchData,
                  ),
                )
              : Container(
                  child: AnimationLimiter(
                      child: AzListView(
                  data: beans,
                  topData: hotBeans,
                  header: AzListViewHeader(
                      height: (ENTRY_HEIGHT * entrys.length).toInt(),
                      builder: (BuildContext ctx) {
                        return Container(
                          color: Theme.of(context).primaryColor,
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
                                      flag: widget.flag,
                                      replace: widget.flag == 1);
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
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 48, vertical: 8),
        child: ZYRaisedButton(
          '添加新客户',
          () {
            RouteHandler.goCustomerEditPage(context, title: '添加客户');
          },
          verticalPadding: 12,
          fontsize: 15,
        ),
      ),
    );
  }
}
