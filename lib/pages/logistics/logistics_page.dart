import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:taojuwu/models/logistics/logistics_data_model.dart';
import 'package:taojuwu/pages/logistics/logistics_data_card.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/v_spacing.dart';

class LogisticsPage extends StatefulWidget {
  final int id;
  LogisticsPage(this.id, {Key key}) : super(key: key);

  @override
  _LogisticsPageState createState() => _LogisticsPageState();
}

class _LogisticsPageState extends State<LogisticsPage> {
  int get id => widget.id;
  bool isLoading = true;
  RefreshController _refreshController;
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(
        initialRefresh: false, initialLoadStatus: LoadStatus.idle);
    fetchData();
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  LogisticsDataModelWrapper wrapper;
  List<GoodsPacketModel> packetList;
  void fetchData() {
    OTPService.logistics(context, params: {'order_id': id})
        .then((LogisticsDataModelResp response) {
      if (response?.valid == true) {
        isLoading = false;
        wrapper = response?.data;
        packetList = wrapper?.goodsPacketList;
        _refreshController?.refreshCompleted();
        if (mounted) setState(() {});
      }
    }).catchError((err) {
      setState(() {
        isLoading = false;
        _refreshController?.loadFailed();
      });

      return err;
    });
  }

  int get hasDeliveredPacketCount => wrapper?.hasDeliveredPacketCount ?? 0;
  bool get showBanner => hasDeliveredPacketCount > 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('订单跟踪'),
        centerTitle: true,
        bottom: PreferredSize(
            child: Visibility(
                visible: showBanner,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                      horizontal: UIKit.width(20), vertical: UIKit.height(20)),
                  color: Color(0xFFF5F5F5),
                  child: Text(
                    '订单分包裹邮寄，其中$hasDeliveredPacketCount个已寄出',
                    style: TextStyle(fontSize: UIKit.sp(28)),
                  ),
                )),
            preferredSize: Size.fromHeight(showBanner ? UIKit.height(90) : 0)),
      ),
      body: isLoading
          ? LoadingCircle()
          : SmartRefresher(
              enablePullDown: true,
              onRefresh: fetchData,
              controller: _refreshController,
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return LogisticsDataCard(
                      model: packetList[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return VSpacing(16);
                  },
                  itemCount: packetList?.length ?? 0),
            ),
    );
  }
}
