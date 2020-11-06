/*
 * @Description: 成品详情
 * @Author: iamsmiling
 * @Date: 2020-10-26 14:15:00
 * @LastEditTime: 2020-11-04 14:23:06
 */

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/end_product/base_end_product_detail_bean.dart';
import 'package:taojuwu/view/product/base/base_product_detail_state.dart';
import 'package:taojuwu/view/product/end_product/widgets/end_product_attr_action_bar.dart';
import 'package:taojuwu/view/product/widgets/product_detail_footer.dart';
import 'package:taojuwu/view/product/widgets/product_detail_header.dart';
import 'package:taojuwu/view/product/widgets/product_detail_profile.dart';
import 'package:taojuwu/view/product/widgets/section/product_detail_img_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/recommend_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/relative_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/scene_design_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/soft_design_product_section_view.dart';
import 'package:taojuwu/widgets/loading.dart';

class EndProductDetailPage extends BaseProductDetailPage {
  final int goodsId;
  EndProductDetailPage(this.goodsId, {Key key}) : super(goodsId);

  @override
  _EndProductDetailPageState createState() => _EndProductDetailPageState();
}

class _EndProductDetailPageState
    extends BaseProductDetailPageState<EndProductDetailPage> {
  // 发起请求

  @override
  Future sendRequest() {
    return fetchData(context, widget.goodsId).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    }).then((_) {
      // ProductDetailBean?.fetchRoomAttrData();
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
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[ProductDetailHeader(productDetailBean)];
                    },
                    body: CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        ProductDetailProfile(
                          productDetailBean,
                        ),
                        EndProductAttrActionBar(
                          bean: productDetailBean as BaseEndProductDetailBean,
                          setState: setState,
                        ),
                        RelativeProductSectionView(relativeProductList),
                        SliverToBoxAdapter(
                          child: SceneDesignProductSectionView(
                              sceneDesignProductList),
                        ),

                        SliverToBoxAdapter(
                          child: SoftDesignProductSectionView(
                            softDesignProductList,
                            goodsId: productDetailBean?.goodsId,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: ProductDetailImgSectionView(
                              productDetailBean?.detailImgList),
                        ),
                        // ProductHtmlDescSectionView(ProductDetailBean?.description),
                        SliverToBoxAdapter(
                          child: RecommendedProductSectionView(
                              recommendProductList),
                        ),
                      ],
                    )),
                bottomNavigationBar: ProductDeatilFooter(productDetailBean),
              ));
  }
}
