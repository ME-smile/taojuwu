/*
 * @Description: 商品详情
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-09-27 15:36:37
 */
import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/event_bus/events/select_client_event.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/view/goods/curtain/widgets/footer/goods_detail_footer.dart';
import 'package:taojuwu/view/goods/curtain/widgets/header/goods_detail_header.dart';
import 'package:taojuwu/view/goods/curtain/widgets/profile/goods_detail_profile.dart';
import 'package:taojuwu/viewmodel/goods/curtain_viewmodel.dart';
import 'package:taojuwu/widgets/loading.dart';

import 'widgets/attrs/goods_detail_attrs.dart';

class CurtainDetailPage extends StatefulWidget {
  final int id; // 商品id
  CurtainDetailPage(
    this.id, {
    Key key,
  }) : super(key: key);

  @override
  _CurtainDetailPageState createState() => _CurtainDetailPageState();
}

class _CurtainDetailPageState extends State<CurtainDetailPage> {
  int get id => widget.id;

  TargetClient mTargetClient;

  StreamSubscription _streamSubscription;

  @override
  void initState() {
    _streamSubscription = Application.eventBus.on().listen((event) {
      if (event is SelectClientEvent) {
        setState(() {
          mTargetClient = event.mTargetClient;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CurtainViewModel(context, id),
      child: Builder(
        builder: (BuildContext ctx) {
          CurtainViewModel viewModel = ctx.watch<CurtainViewModel>();
          return PageTransitionSwitcher(
              transitionBuilder: (
                Widget child,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: viewModel.isLoading ? LoadingCircle() : _buildContent());
        },
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<CurtainViewModel>(
        builder: (BuildContext context, CurtainViewModel viewModel, _) {
      ProductBean bean = viewModel.bean;
      return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[GoodsDetailHeader(bean)];
          },
          body: CustomScrollView(
            slivers: <Widget>[
              GoodsDetailProfile(bean),
              GoodsDetailAttrs(
                viewModel.curtainType,
              ),
              SliverToBoxAdapter(
                child: Html(data: bean?.description ?? ''),
              )
            ],
          ),
        ),
        bottomNavigationBar: GoodsDetailFooter(viewModel),
      );
    });
  }
}
