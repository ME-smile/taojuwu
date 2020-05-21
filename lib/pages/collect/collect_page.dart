import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/models/shop/collect_list_model.dart';
import 'package:taojuwu/models/shop/product_bean.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/providers/client_provider.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/utils/ui_kit.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/no_data.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class CollectPage extends StatefulWidget {
  final int id;
  final String name;
  CollectPage({Key key, this.id, this.name}) : super(key: key);

  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  final List<String> tabs = ['窗帘'];
  CollectListWrapper wrapper;
  List<ProductBean> beanList;
  // ValueNotifier<List<ProductBean>> beans;
  int get count => beanList?.length ?? 0;
  @override
  void initState() {
    super.initState();
    OTPService.collectList(context, params: {'client_uid': widget.id})
        .then((CollectListResp response) {
      setState(() {
        isLoading = false;
        wrapper = response?.data;
        beanList = wrapper?.data;
      });
    }).catchError((err) => err);
    tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
  }

  bool isLoading = true;

  cancelCollect(BuildContext context, ProductBean bean) {
    OTPService.cancelCollect(params: {
      'fav_id': bean?.goodsId ?? -1,
      'client_uid': widget.id ?? -1,
    }).then((ZYResponse response) {
      CommonKit.showInfo(response.message);
      Navigator.of(context).pop();
      if (response?.valid == true) {
        setState(() {
          beanList?.remove(bean);
        });
      }
    }).catchError((err) => err);
  }

  void remove(BuildContext ctx, ProductBean bean) {
    showCupertinoDialog(
        context: ctx,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('删除'),
            content: Text('您确定要从收藏夹中删除该商品吗?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text('确定'),
                onPressed: () {
                  cancelCollect(context, bean);
                },
              ),
            ],
          );
        });
  }

  Widget buildCollectCard(BuildContext context, ProductBean bean, int index) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return GestureDetector(
      onLongPress: () {
        remove(context, bean);
      },
      onTap: () {
        ClientProvider clientProvider =
            Provider.of<ClientProvider>(context, listen: false);
        clientProvider?.clientId = widget.id;
        clientProvider?.name = widget?.name;
        RouteHandler.goCurtainDetailPage(
          context,
          bean?.goodsId ?? -1,
        );
      },
      child: Container(
        child: Row(
          children: <Widget>[
            ZYNetImage(
              imgPath: UIKit.getNetworkImgPath(bean?.picCoverMicro),
              isCache: false,
              height: UIKit.height(180),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: UIKit.width(20)),
              height: UIKit.height(180),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    bean?.goodsName ?? '',
                    style: textTheme.title,
                  ),
                  Text(
                    bean?.categoryName ?? '',
                    style: textTheme.caption.copyWith(fontSize: UIKit.sp(28)),
                  ),
                  Text(bean?.displayPrice ?? '')
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingCircle()
        : Scaffold(
            appBar: AppBar(
              title: Text('收藏夹'),
              centerTitle: true,
              bottom: PreferredSize(
                  child: TabBar(
                      controller: tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: List.generate(tabs.length, (int i) {
                        return Text('${tabs[i]}($count)');
                      })),
                  preferredSize: Size.fromHeight(20)),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: UIKit.width(20), vertical: UIKit.height(20)),
                child: beanList == null || beanList?.isNotEmpty != true
                    ? NoData()
                    : ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return buildCollectCard(context, beanList[i], i);
                        },
                        separatorBuilder: (BuildContext context, int i) {
                          return Divider();
                        },
                        itemCount: beanList?.length ?? 0)),
          );
  }
}
