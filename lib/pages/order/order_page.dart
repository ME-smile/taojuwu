import 'package:flutter/material.dart';
import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/no_data.dart';
import 'package:taojuwu/widgets/search_button.dart';
import 'package:taojuwu/widgets/v_spacing.dart';
import 'package:taojuwu/widgets/zy_future_builder.dart';

import 'widgets/order_card.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List items = Constants.ORDER_STATUS_TAB_MAP.values.toList();
  TabController _tabController;
  List nums;
  List<Map<String, int>> params = [
    {},
    {'status': 1},
    {'status': 2},
    {'status': 3},
    {'status': 4},
    {'status': 5},
    {'status': 6},
    {'status': 7},
  ];
  @override
  void initState() {
    super.initState();
    OTPService.orderList(context).then((OrderModelListResp response) {
      setState(() {
        nums = response?.data?.statusNum?.values?.toList();
      });
    }).catchError((err) => err);
    _tabController = TabController(length: items.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ZYFutureBuilder(
        futureFunc: OTPService.orderList,
        params: params[_tabController.index],
        builder: (BuildContext context, OrderModelListResp response) {
          return Scaffold(
              appBar: AppBar(
                title: Text('订单管理'),
                actions: <Widget>[SearchButton(type: 3)],
                centerTitle: true,
                bottom: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey,
                    labelPadding: EdgeInsets.only(
                        bottom: UIKit.height(10),
                        left: UIKit.width(10),
                        right: UIKit.width(10)),
                    tabs: List.generate(Constants.ORDER_STATUS_TAB_MAP.length,
                        (int i) {
                      return Text(
                        '${items[i]}(${nums == null ? 0 : nums[i]})',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(fontSize: UIKit.sp(32)),
                      );
                    })),
              ),
              body: TabBarView(
                  controller: _tabController,
                  children: List.generate(items?.length ?? 0, (int i) {
                    return OrderTabView(
                      params: params[i],
                    );
                  })));
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class OrderTabView extends StatelessWidget {
  final Map<String, int> params;
  const OrderTabView({Key key, this.params}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZYFutureBuilder(
        futureFunc: OTPService.orderList,
        params: params,
        builder: (BuildContext context, OrderModelListResp response) {
          OrderModelDataWrapper wrapper = response?.data;
          return wrapper?.data == null || wrapper?.data?.isEmpty == true
              ? NoData()
              : ListView.separated(
                  itemBuilder: (BuildContext context, int i) {
                    return OrderCard(wrapper?.data[i]);
                  },
                  separatorBuilder: (BuildContext context, int i) {
                    return VSpacing(20);
                  },
                  itemCount: wrapper?.data?.length ?? 0);
        });
  }
}
