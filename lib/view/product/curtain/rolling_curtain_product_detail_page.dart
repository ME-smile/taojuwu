/*
 * @Description: 卷帘详情
 * @Author: iamsmiling
 * @Date: 2020-10-26 14:14:35
 * @LastEditTime: 2020-11-04 14:23:53
 */
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/curtain/rolling_curtain_product_bean.dart';
import 'package:taojuwu/view/product/base/base_curtain_product_detail_state.dart';
import 'package:taojuwu/view/product/base/base_product_detail_state.dart';
import 'package:taojuwu/view/product/widgets/product_detail_footer.dart';
import 'package:taojuwu/view/product/widgets/product_detail_header.dart';
import 'package:taojuwu/view/product/widgets/product_detail_profile.dart';
import 'package:taojuwu/view/product/widgets/section/product_detail_img_section_view.dart';

import 'package:taojuwu/view/product/widgets/section/recommend_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/relative_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/rolling_curtain_product_attrs_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/scene_design_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/soft_design_product_section_view.dart';
import 'package:taojuwu/widgets/loading.dart';

class RollingCurtainProductDetailPage extends BaseProductDetailPage {
  final int id;
  RollingCurtainProductDetailPage(this.id, {Key key}) : super(id);

  @override
  _RollingCurtainProductDetailPageState createState() =>
      _RollingCurtainProductDetailPageState();
}

class _RollingCurtainProductDetailPageState
    extends BaseCurtainProductDetailState<RollingCurtainProductDetailPage> {
  // 发起请求
  Future sendRequest() {
    return fetchData(context, widget.goodsId).then((_) {
      (productBean as RollingCurtainProductBean).fetchRoomAttrData().then((_) {
        copyData();
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: isLoading
            ? LoadingCircle()
            : Scaffold(
                backgroundColor: const Color(0xFFF8F8F8),
                body: NestedScrollView(
                    controller: scrollController,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[ProductDetailHeader(productBean)];
                    },
                    body: CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        ProductDetailProfile(productBean),
                        RollingCurtainProductAttrsSectionView(productBean),
                        // RollingCurtainProductAttrSectionView(productBean),
                        RelativeProductSectionView(relativeProductList),
                        SliverToBoxAdapter(
                          child: SceneDesignProductSectionView(
                              sceneDesignProductList),
                        ),

                        SliverToBoxAdapter(
                          child: SoftDesignProductSectionView(
                            softDesignProductList,
                            goodsId: productBean?.goodsId,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: ProductDetailImgSectionView(
                              productBean?.detailImgList),
                        ),
                        // ProductHtmlDescSectionView(productBean?.description),
                        SliverToBoxAdapter(
                          child: RecommendedProductSectionView(
                              recommendProductList),
                        ),
                      ],
                    )),
                bottomNavigationBar: ProductDeatilFooter(
                  productBean,
                  callback: scrollToTop,
                ),
              ));
  }
}
