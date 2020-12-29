/*
 * @Description:型材页面
 * @Author: iamsmiling
 * @Date: 2020-12-28 10:51:57
 * @LastEditTime: 2020-12-29 15:31:18
 */

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/end_product/sectional_product_detail_bean.dart';
import 'package:taojuwu/view/product/base/base_product_detail_state.dart';
import 'package:taojuwu/view/product/end_product/widgets/sectionalbar_product_attr_action_bar.dart';
import 'package:taojuwu/view/product/mixin/product_attr_holder.dart';
import 'package:taojuwu/view/product/widgets/product_detail_footer.dart';
import 'package:taojuwu/view/product/widgets/product_detail_header.dart';
import 'package:taojuwu/view/product/widgets/product_detail_profile.dart';
import 'package:taojuwu/view/product/widgets/section/product_detail_img_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/product_material_info_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/recommend_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/relative_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/scene_design_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/soft_design_product_section_view.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/network_error.dart';

class SectionalbarProductDetailPage extends BaseProductDetailPage {
  final int goodsId;
  SectionalbarProductDetailPage(this.goodsId, {Key key}) : super(goodsId);

  @override
  _SectionalbarProductDetailPageState createState() =>
      _SectionalbarProductDetailPageState();
}

class _SectionalbarProductDetailPageState
    extends BaseProductDetailPageState<SectionalbarProductDetailPage>
    with ProductAttrHolder {
  // 发起请求

  @override
  Future sendRequest() {
    setState(() {
      hasError = false;
      isLoading = true;
    });
    return fetchData(context, widget.goodsId).catchError((err) {
      hasError = true;
    }).whenComplete(() {
      setState(() {
        isLoading = false;
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
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            ProductDetailHeader(productDetailBean)
                          ];
                        },
                        body: CustomScrollView(
                          shrinkWrap: true,
                          slivers: [
                            ProductDetailProfile(
                              productDetailBean,
                            ),
                            SectionalbarProductAttrBar(
                              bean: productDetailBean
                                  as SectionalProductDetailBean,
                              // setState: setState,
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
                              child: ProductMaterialInfoSectionView(
                                  productDetailBean?.materialInfoDetailBean),
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
