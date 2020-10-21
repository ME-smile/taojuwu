/*
 * @Description: 相关场景   当前页面业务逻辑较少
 * @Author: iamsmiling
 * @Date: 2020-10-12 16:32:02
 * @LastEditTime: 2020-10-16 11:20:22
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/repository/shop/scene_detail_model.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/view/goods/scene_project/section/scene_project_detail_section_view.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_viewmodel.dart';
import 'package:taojuwu/widgets/loading.dart';

import 'section/scene_project_recommedation_section_view.dart';
import 'section/scene_project_related_goods_section_view.dart';

class SceneProjectPage extends StatefulWidget {
  final BaseGoodsViewModel viewModel; // viewmdel 操作句柄
  final int goodsId;
  final int scenesId;
  const SceneProjectPage(this.viewModel, this.goodsId, this.scenesId, {Key key})
      : super(key: key);

  @override
  _SceneProjectPageState createState() => _SceneProjectPageState();
}

class _SceneProjectPageState extends State<SceneProjectPage> {
  SceneProjectDetailWrapper detailWrapper;
  SceneProjectBean currentBean;
  List<SceneProjectBean> beanList;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    OTPService.sceneDetail(context,
            params: {'goods_id': widget.goodsId, 'scenes_id': widget.scenesId})
        .then((SceneDetailModelResp response) {
          if (response?.valid == true) {
            SceneProjectDetailWrapper detailWrapper = response?.data;
            currentBean = detailWrapper?.curSoftProject;
            beanList = detailWrapper?.projectList;
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('相关场景'),
      ),
      body: isLoading
          ? LoadingCircle()
          : ChangeNotifierProvider.value(
              value: widget.viewModel,
              builder: (BuildContext context, _) {
                return Container(
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomScrollView(
                    shrinkWrap: true,
                    slivers: [
                      SliverToBoxAdapter(
                          child: SceneProjectDetailSectionView(currentBean)),
                      SliverToBoxAdapter(
                          child: SceneProjectRelatedGoodsSectionView(
                              currentBean?.goodsList)),
                      SliverToBoxAdapter(
                          child: SoftProjectRecommendationSectionView(beanList))
                    ],
                  ),
                );
              },
            ),
    );
  }
}
