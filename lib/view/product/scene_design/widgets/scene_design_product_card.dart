/*
 * @Description: 场景瀑布流卡片布局
 * @Author: iamsmiling
 * @Date: 2020-10-23 11:08:17
 * @LastEditTime: 2020-10-30 11:01:10
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/design/base_design_product_bean.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/view/goods/base/thumbnail_card.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class SceneProjectGoodsCard extends StatelessWidget {
  ///[imgFlex]图片缩放比例
  final int imgFlex;

  ///[bean]
  final BaseDesignProductBean bean;
  const SceneProjectGoodsCard({this.bean, key, this.imgFlex = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        RouteHandler.goSceneDesignPage(context, bean?.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [BoxShadow(color: Color.fromARGB(100, 0, 0, 0))],
              border: Border.all(color: const Color(0xFFF2F2F2))),
          child: Column(
            children: [
              Flexible(
                  flex: imgFlex,
                  child: ZYNetImage(
                    width: size.width,
                    height: size.height,
                    fit: BoxFit.cover,
                    imgPath: bean?.picture,
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(min(bean?.goodsList?.length ?? 0, 3),
                      (int index) {
                    return Flexible(
                        child: Container(
                      margin: const EdgeInsets.all(4.0),
                      child: ThumbnailCard(bean?.goodsList[index]?.cover),
                    ));
                  }),
                ),
              ),
              Container(
                child: Text(
                  '${bean?.room ?? ''},${bean?.style ?? ''}',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(bottom: 12, left: 8),
              )
            ],
          ),
        ),
      ),
    );
  }
}
