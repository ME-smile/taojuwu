/*
 * @Description: 商品详情
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-09-27 17:33:42
 */

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/footer/goods_detail_footer.dart';
import 'package:taojuwu/view/goods/curtain/widgets/header/goods_detail_header.dart';
import 'package:taojuwu/view/goods/curtain/widgets/profile/goods_detail_profile.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';
import 'package:taojuwu/widgets/loading.dart';

import 'widgets/attrs/goods_detail_attrs.dart';

class CurtainDetailPage extends StatelessWidget {
  final int id;
  const CurtainDetailPage(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CurtainViewModel(context, id),
      child: Consumer<CurtainViewModel>(
        builder: (BuildContext context, CurtainViewModel viewModel, _) {
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
