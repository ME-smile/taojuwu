/*
 * @Description: 场景轮播图卡片布局
 * @Author: iamsmiling
 * @Date: 2020-10-23 09:42:58
 * @LastEditTime: 2020-10-31 08:26:25
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/product/abstract/base_product_bean.dart';
import 'package:taojuwu/repository/shop/product/design/scene_design_product_bean.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class SceneDesignProductCard extends StatelessWidget {
  final SceneDesignProductBean bean;
  const SceneDesignProductCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => _jumpTo(context, bean?.scenesId),
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
                Positioned(
                  child: ZYAssetImage(
                    'mask.jpg',
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                  ),
                  top: 0,
                ),
                Positioned(
                  child: Container(
                    color: Color.fromARGB(125, 0, 0, 0),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '${bean?.room},${bean?.style}',
                      style: TaojuwuTextStyle.WHITE_TEXT_STYLE,
                    ),
                  ),
                  top: 0,
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
                  BaseProductBean item = bean?.goodsList[index];
                  return Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            RouteHandler.goSceneDesignPage(context, bean?.id);
                          },
                          child: Stack(
                            children: [
                              ZYNetImage(
                                imgPath: item?.cover,
                              ),
                              Container(
                                color: index == 4
                                    ? Colors.black.withAlpha(80)
                                    : null,
                                width: MediaQuery.of(context).size.width,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: index == 4
                                      ? Icon(ZYIcon.three_dot)
                                      : null,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('¥${item?.price}'),
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
