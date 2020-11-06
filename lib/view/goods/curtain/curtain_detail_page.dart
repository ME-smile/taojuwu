/*
 * @Description: 商品详情
 * @Author: iamsmiling
 * @Date: 2020-09-25 12:47:45
 * @LastEditTime: 2020-11-02 10:19:01
 */

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/view/goods/curtain/widgets/footer/goods_detail_footer.dart';
import 'package:taojuwu/view/goods/curtain/widgets/header/goods_detail_header.dart';
import 'package:taojuwu/view/goods/curtain/widgets/section/related_goods_section_view.dart';
import 'package:taojuwu/view/goods/curtain/widgets/section/scene_project_section_view.dart';
import 'package:taojuwu/view/goods/curtain/widgets/section/soft_project_section_view.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_viewmodel.dart';
import 'package:taojuwu/viewmodel/goods/binding/curtain/curtain_viewmodel.dart';
import 'package:taojuwu/widgets/loading.dart';

import 'widgets/profile/goods_detail_profile.dart';
import 'widgets/section/goods_attrs_section_view.dart';
import 'widgets/section/goods_html_desc_section_view.dart';
import 'widgets/section/recommended_goods_section_view.dart';

class CurtainDetailPage extends StatelessWidget {
  final int id;
  const CurtainDetailPage(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BaseGoodsViewModel>(
      create: (BuildContext context) => CurtainViewModel.fromId(context, id),
      child: Builder(builder: (BuildContext ctx) {
        return PageTransitionSwitcher(transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        }, child: Consumer<BaseGoodsViewModel>(
          builder: (BuildContext context, BaseGoodsViewModel viewModel, _) {
            return (viewModel as CurtainViewModel).isLoading
                ? LoadingCircle()
                : _buildContent();
          },
        ));
      }),
    );
  }

  Widget _buildContent() {
    return Consumer<BaseGoodsViewModel>(
        builder: (BuildContext context, BaseGoodsViewModel viewModel, _) {
      ProductDetailBean bean = viewModel.bean;
      return Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[GoodsDetailHeader(bean)];
          },
          body: CustomScrollView(
            shrinkWrap: true,
            slivers: <Widget>[
              GoodsDetailProfile(bean),
              GoodsAttrsSectionView(
                  (viewModel as CurtainViewModel).curtainType),
              RelatedGoodsSectionView(viewModel.relatedGoodsList),
              SceneProjectSectionView(viewModel.sceneProjectList),
              SoftProjectSectionView(viewModel.softProjectList),
              GoodsHtmlDescSectionView(viewModel.bean?.description),
              RecommendGoodsSectionView(viewModel.recommendGoodsList),
            ],
          ),
        ),
        bottomNavigationBar: GoodsDetailFooter(viewModel),
      );
    });
  }
}
