/*
 * @Description: 场景轮播图卡片布局
 * @Author: iamsmiling
 * @Date: 2020-10-23 09:42:58
 * @LastEditTime: 2021-01-12 15:07:46
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taojuwu/config/text_style/taojuwu_text_style.dart';
import 'package:taojuwu/icon/ZYIcon.dart';
import 'package:taojuwu/repository/shop/product_detail/abstract/single_product_detail_bean.dart';
import 'package:taojuwu/repository/shop/product_detail/design/scene_design_product_detail_bean.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/widgets/zy_assetImage.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class SceneDesignProductCard extends StatelessWidget {
  final SceneDesignProductDetailBean bean;
  const SceneDesignProductCard(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        RouteHandler.goSceneDesignPage(context, bean?.id);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(children: [
                  // Image.network(UIKit.getNetworkImgPath(bean.picture)),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: ZYNetImage(
                  //     // width: MediaQuery.of(context).size.width,
                  //     fit: BoxFit.cover,
                  //     imgPath: bean.picture,
                  //   ),
                  // ),
                  Container(
                    // foregroundDecoration: BoxDecoration(
                    //     image: DecorationImage(
                    //         image: AssetImage(
                    //   UIKit.getAssetsImagePath(
                    //     'mask.jpg',
                    //   ),
                    // ))),
                    width: w,
                    alignment: Alignment.topLeft,
                    child: ZYNetImage(
                      imgPath: bean?.picture,
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  Positioned(
                    child: ZYAssetImage(
                      'mask.jpg',
                      fit: BoxFit.fitWidth,
                      height: 56,
                    ),
                    top: 0,
                    left: 0,
                    right: 0,
                  ),
                  Positioned(
                    child: Container(
                      // color: Color.fromARGB(125, 0, 0, 0),
                      // width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      child: Text(
                        '${bean?.room ?? ''} ${bean?.style ?? ''}',
                        style: TaojuwuTextStyle.WHITE_TEXT_STYLE,
                      ),
                    ),
                    top: 0,
                  )
                ]),
              ),
            ),
            // AspectRatio(aspectRatio: 3,

            // child: Row(
            //   ch
            // ),
            // ),
            AspectRatio(
              aspectRatio: 3,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 8, bottom: 0),
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: .68,
                      crossAxisSpacing: 8),
                  itemBuilder: (BuildContext context, int index) {
                    SingleProductDetailBean item = bean?.goodsList[index];

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              RouteHandler.goSceneDesignPage(context, bean?.id);
                            },
                            child: Stack(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(2),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 2),
                                              blurRadius: 2,
                                              color:
                                                  Color.fromARGB(45, 0, 0, 0)),
                                        ]),
                                    child: AspectRatio(
                                        aspectRatio: 1,
                                        // child: Text(item?.cover ?? ''),
                                        child: Builder(
                                          builder: (BuildContext context) {
                                            return ZYNetImage(
                                              imgPath: item?.cover,
                                            );
                                            // return Image.network(item?.cover);
                                          },
                                        )
                                        // child: Container(
                                        //   decoration: BoxDecoration(
                                        //       image: DecorationImage(
                                        //           image:
                                        //               NetworkImage(item?.cover))),
                                        // ),
                                        )),
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
                            child: Text(
                              '¥${item?.price}/米',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: min(5, bean?.goodsList?.length ?? 0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
