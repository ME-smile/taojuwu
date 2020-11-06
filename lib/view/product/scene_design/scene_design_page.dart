/*
 * @Description: 软装方案详情
 * @Author: iamsmiling
 * @Date: 2020-10-23 11:05:49
 * @LastEditTime: 2020-11-04 10:55:26
 */
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/abstract_base_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/design/scene_design_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/scene_detail_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/view/product/scene_design/section/recommend_scene_design_product_section_view.dart';
import 'package:taojuwu/view/product/scene_design/section/scene_design_product_detail_section_view.dart';
import 'package:taojuwu/view/product/scene_design/section/scene_design_relative_product_section_view.dart';
import 'package:taojuwu/widgets/loading.dart';
import 'package:taojuwu/widgets/user_choose_button.dart';

class SceneDesignPage extends StatefulWidget {
  final int scenesId;

  ///[fromProductDetailBean]从哪个商品点进来看的
  final AbstractBaseProductDetailBean fromProductDetailBean;
  SceneDesignPage(this.scenesId, {Key key, this.fromProductDetailBean})
      : super(key: key);

  @override
  _SceneDesignPageState createState() => _SceneDesignPageState();
}

class _SceneDesignPageState extends State<SceneDesignPage> {
  bool isLoading = true;
  int get id => widget.scenesId;
  SceneDesignProductDetailBean currentBean;
  List<SceneDesignProductDetailBean> list;
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() {
    OTPService.sceneDetail(context, params: {'scenes_id': widget.scenesId})
        .then((SceneDetailModelResp response) {
          if (response?.valid == true) {
            SceneProjectDetailWrapper detailWrapper = response?.data;
            currentBean = detailWrapper?.currentBean;
            list = detailWrapper?.list;
          }
        })
        .catchError((err) => err)
        .whenComplete(() {
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
            : Scaffold(
                appBar: AppBar(
                  title: Text('相关场景'),
                  centerTitle: true,
                  actions: [const UserChooseButton()],
                ),
                body: Container(
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomScrollView(
                    shrinkWrap: true,
                    slivers: [
                      SliverToBoxAdapter(
                          child:
                              SceneDesignProductDetailSectionView(currentBean)),
                      SliverToBoxAdapter(
                          child: SceneDesignRelativeProductSectionView(
                              id, currentBean?.goodsList)),
                      SliverToBoxAdapter(
                          child: RecommendSceneDesignProductSectionView(list))
                    ],
                  ),
                ),
              ));
  }
}
