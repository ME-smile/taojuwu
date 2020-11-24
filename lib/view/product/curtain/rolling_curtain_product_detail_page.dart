/*
 * @Description: 卷帘详情
 * @Author: iamsmiling
 * @Date: 2020-10-26 14:14:35
 * @LastEditTime: 2020-11-24 17:59:28
 */
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/rolling_curtain_product_detail_bean.dart';
import 'package:taojuwu/view/product/base/base_curtain_product_detail_state.dart';
import 'package:taojuwu/view/product/base/base_product_detail_state.dart';
import 'package:taojuwu/view/product/widgets/product_detail_footer.dart';
import 'package:taojuwu/view/product/widgets/product_detail_header.dart';
import 'package:taojuwu/view/product/widgets/product_detail_profile.dart';
import 'package:taojuwu/view/product/widgets/section/product_detail_img_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/product_material_info_section_view.dart';

import 'package:taojuwu/view/product/widgets/section/recommend_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/relative_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/rolling_curtain_product_attrs_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/scene_design_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/soft_design_product_section_view.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/network_error.dart';

class RollingCurtainProductDetailPage extends BaseProductDetailPage {
  final int id;
  final bool isMeasureOrderGoods;
  RollingCurtainProductDetailPage(this.id,
      {Key key, this.isMeasureOrderGoods = false})
      : super(id, isMeasureOrderGoods: isMeasureOrderGoods);

  @override
  _RollingCurtainProductDetailPageState createState() =>
      _RollingCurtainProductDetailPageState();
}

class _RollingCurtainProductDetailPageState
    extends BaseCurtainProductDetailState<RollingCurtainProductDetailPage> {
  // 发起请求
  Future sendRequest() {
    setState(() {
      hasError = false;
      isLoading = true;
    });
    return fetchData(context, widget.goodsId,
            isMeasureOrderGoods: widget.isMeasureOrderGoods)
        .then((_) {
      (productDetailBean as RollingCurtainProductDetailBean)
          .fetchRoomAttrData()
          .then((_) {
        copyData();
        // updateMeasureData();
      }).catchError((err) {
        hasError = true;
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
            : hasError
                ? Scaffold(
                    appBar: AppBar(),
                    body: Container(
                        height: double.maxFinite,
                        color: Theme.of(context).primaryColor,
                        child: NetworkErrorWidget(callback: sendRequest)),
                  )
                : Scaffold(
                    backgroundColor: const Color(0xFFF8F8F8),
                    body: NestedScrollView(
                        controller: scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            ProductDetailHeader(productDetailBean)
                          ];
                        },
                        body: CustomScrollView(
                          shrinkWrap: true,
                          slivers: [
                            ProductDetailProfile(productDetailBean),
                            RollingCurtainProductAttrsSectionView(
                                productDetailBean),
                            // // RollingCurtainProductAttrSectionView(ProductDetailBean),
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
                              child: ProductMaterialInfoSectionView(
                                  productDetailBean?.materialInfoDetailBean),
                            ),
                            SliverToBoxAdapter(
                              child: ProductDetailImgSectionView(
                                  productDetailBean?.detailImgList),
                            ),

                            SliverToBoxAdapter(
                              child: RecommendedProductSectionView(
                                  recommendProductList),
                            ),
                          ],
                        )),
                    bottomNavigationBar: ProductDeatilFooter(
                      productDetailBean,
                      callback: scrollToTop,
                    ),
                  ));
  }
}
