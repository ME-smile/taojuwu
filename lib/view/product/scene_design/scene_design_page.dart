/*
 * @Description: 软装方案详情
 * @Author: iamsmiling
 * @Date: 2020-10-23 11:05:49
 * @LastEditTime: 2020-10-23 13:19:24
 */
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/repository/shop/product/design/scene_design_product_bean.dart';
import 'package:taojuwu/repository/shop/scene_detail_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/view/product/scene_design/section/recommend_scene_design_product_section_view.dart';
import 'package:taojuwu/view/product/scene_design/section/scene_design_product_detail_section_view.dart';
import 'package:taojuwu/view/product/scene_design/section/scene_design_relative_product_section_view.dart';
import 'package:taojuwu/viewmodel/product/base/provider/base_product_provider.dart';
import 'package:taojuwu/widgets/loading.dart';

class SceneDesignPage extends StatefulWidget {
  final BaseProductProvider provider;
  final int goodsId;
  final int scenesId;
  SceneDesignPage(this.provider, this.goodsId, this.scenesId, {Key key})
      : super(key: key);

  @override
  _SceneDesignPageState createState() => _SceneDesignPageState();
}

class _SceneDesignPageState extends State<SceneDesignPage> {
  bool isLoading = true;
  SceneDesignProductBean currentBean;
  List<SceneDesignProductBean> list;
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() {
    OTPService.sceneDetail(context,
            params: {'goods_id': widget.goodsId, 'scenes_id': widget.scenesId})
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
            : ChangeNotifierProvider<BaseProductProvider>.value(
                value: widget.provider,
                builder: (BuildContext context, _) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('相关场景'),
                      centerTitle: true,
                    ),
                    body: Container(
                      color: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomScrollView(
                        shrinkWrap: true,
                        slivers: [
                          SliverToBoxAdapter(
                              child: SceneDesignProductDetailSectionView(
                                  currentBean)),
                          SliverToBoxAdapter(
                              child: SceneDesignRelativeProductSectionView(
                                  currentBean?.goodsList)),
                          SliverToBoxAdapter(
                              child:
                                  RecommendSceneDesignProductSectionView(list))
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
