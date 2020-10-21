/*
 * @Description: 场景推荐
 * @Author: iamsmiling
 * @Date: 2020-10-09 14:27:32
 * @LastEditTime: 2020-10-16 11:15:26
 */
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/view/goods/base/title_tip.dart';
import 'package:taojuwu/view/goods/base/trailing_tip.dart';
import 'package:taojuwu/view/goods/scene_project/scene_project_page.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/base_goods_viewmodel.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class SceneProjectSectionView extends StatelessWidget {
  final List<SceneProjectBean> list;
  const SceneProjectSectionView(this.list, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Visibility(
        visible: !CommonKit.isNullOrEmpty(list),
        child: Container(
          color: Theme.of(context).primaryColor,
          margin: EdgeInsets.only(
            top: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleTip(title: '场景推荐'),
                      TrailingTip(
                        text: '查看',
                        // callback: () => showRelateGoodsPopupWindow(
                        //     context, relatedGoodsList),
                      )
                    ]),
              ),
              AspectRatio(
                aspectRatio: 1.16,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Swiper(
                    itemCount: list.length,
                    viewportFraction: .96,
                    pagination: new SwiperPagination(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        builder: DotSwiperPaginationBuilder(
                            size: 6.0,
                            activeSize: 6.0,
                            activeColor: Colors.black,
                            color: Colors.black.withOpacity(.3))),
                    itemBuilder: (BuildContext context, int i) {
                      return SceneProjectCard(list[i]);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SceneProjectCard extends StatelessWidget {
  final SceneProjectBean bean;
  const SceneProjectCard(this.bean, {Key key}) : super(key: key);

  void _jumpTo(BuildContext ctx, int sceneId) {
    BaseGoodsViewModel viewModel =
        Provider.of<BaseGoodsViewModel>(ctx, listen: false);
    Navigator.push(ctx, CupertinoPageRoute(builder: (BuildContext context) {
      return SceneProjectPage(viewModel, viewModel.bean?.goodsId, sceneId);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _jumpTo(context, bean?.scenesId),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.75,
              child: Stack(children: [
                Align(
                  alignment: Alignment.center,
                  child: ZYNetImage(
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.contain,
                    imgPath: bean.picture,
                  ),
                ),
                Container(
                  color: Color.fromARGB(125, 0, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '${bean?.space},${bean?.style}',
                    style: TaojuwuTextStyle.WHITE_TEXT_STYLE,
                  ),
                )
              ]),
            ),
            AspectRatio(
              aspectRatio: 3,
              child: GridView.builder(
                padding: EdgeInsets.only(top: 8, bottom: 0),
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: .64,
                    crossAxisSpacing: 8),
                itemBuilder: (BuildContext context, int index) {
                  ProjectGoodsBean item = bean?.goodsList[index];
                  return Container(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ZYNetImage(
                              imgPath: item?.picCoverMid,
                            ),
                            Container(
                              color: index == 4
                                  ? Colors.black.withAlpha(80)
                                  : null,
                              width: MediaQuery.of(context).size.width,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child:
                                    index == 4 ? Icon(ZYIcon.three_dot) : null,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('¥${item?.displayPrice}'),
                        )
                      ],
                    ),
                  );
                },
                itemCount: min(5, bean?.goodsList?.length ?? 0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
