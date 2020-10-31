/*
 * @Description: 商品详情数据转态的基类
 * @Author: iamsmiling
 * @Date: 2020-10-29 14:10:44
 * @LastEditTime: 2020-10-30 13:51:30
 */
import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/view/product/mixin/base_product_holder.dart';
import 'package:taojuwu/view/product/mixin/client_select_listener.dart';

abstract class BaseProductDetailPage extends StatefulWidget {
  final int goodsId;
  BaseProductDetailPage(this.goodsId, {Key key}) : super(key: key);

  @override
  BaseProductDetailPageState createState() => BaseProductDetailPageState();
}

class BaseProductDetailPageState<T> extends State<BaseProductDetailPage>
    with RouteAware, BaseProductHolder, TargetClientHolder {
  @override
  set client(TargetClient target) {
    TargetClientHolder.targetClient = target;
    productBean?.client = client;
  }

  Future sendRequest() {
    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    sendRequest();
    super.addListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Application.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.relase();
    super.clear();
    Application.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    if (mounted) setState(() {});
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
