/*
 * @Description: 商品详情页
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:55:05
 * @LastEditTime: 2020-11-19 18:57:17
 */
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/curtain/fabric_curtain_product_detail_bean.dart';
import 'package:taojuwu/view/product/base/base_curtain_product_detail_state.dart';
import 'package:taojuwu/view/product/base/base_product_detail_state.dart';
import 'package:taojuwu/view/product/widgets/product_detail_footer.dart';
import 'package:taojuwu/view/product/widgets/section/fabric_curtain_product_attrs_section_view.dart';
import 'package:taojuwu/view/product/widgets/product_detail_header.dart';
import 'package:taojuwu/view/product/widgets/product_detail_profile.dart';
import 'package:taojuwu/view/product/widgets/section/product_detail_img_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/recommend_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/relative_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/scene_design_product_section_view.dart';
import 'package:taojuwu/view/product/widgets/section/soft_design_product_section_view.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/network_error.dart';

class FabricCurtainProductDetailPage extends BaseProductDetailPage {
  final int goodsId;
  FabricCurtainProductDetailPage(this.goodsId, {Key key}) : super(goodsId);

  @override
  _CurtainProductDetailPageState createState() =>
      _CurtainProductDetailPageState();
}

class _CurtainProductDetailPageState
    extends BaseCurtainProductDetailState<FabricCurtainProductDetailPage> {
// 发起请求
  Future sendRequest() {
    setState(() {
      hasError = false;
      isLoading = true;
    });
    return fetchData(context, widget.goodsId).then((_) {
      (productDetailBean as FabricCurtainProductDetailBean).fetchAttrsData(() {
        setState(() {
          isLoading = false;
        });
      });
    }).then((_) {
      // 初始化商品属性

      (productDetailBean as FabricCurtainProductDetailBean)
          .fetchRoomAttrData()
          .whenComplete(() {
        copyData();
        updateMeasureData();
      });
    }).catchError((err) {
      setState(() {
        hasError = true;
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
                    backgroundColor: const Color(0xFFF8F8FB),
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
                            FabricCurtainProductAttrSectionView(
                                productDetailBean),
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
    // return ChangeNotifierProvider<SingleProductProvider>(
    //   create: (context)=>(),
    // );
  }
}
