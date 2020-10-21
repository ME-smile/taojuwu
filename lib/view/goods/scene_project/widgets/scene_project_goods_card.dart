/*
 * @Description: 场景推荐卡片布局
 * @Author: iamsmiling
 * @Date: 2020-10-13 09:32:16
 * @LastEditTime: 2020-10-16 13:32:37
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/view/goods/base/thumbnail_card.dart';
import 'package:taojuwu/widgets/zy_netImage.dart';

class SceneProjectGoodsCard extends StatelessWidget {
  ///[imgFlex]图片缩放比例
  final int imgFlex;

  ///[bean]
  final ProjectBean bean;
  const SceneProjectGoodsCard({this.bean, key, this.imgFlex = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ClipRRect(
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
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(min(bean?.goodsList?.length ?? 0, 3),
                    (int index) {
                  return Flexible(
                      child: Container(
                    margin: const EdgeInsets.all(4.0),
                    child: ThumbnailCard(bean?.goodsList[index]?.picCoverMid),
                  ));
                }),
              ),
            ),
            Container(
              child: Text(
                '${bean?.space ?? ''},${bean?.style ?? ''}',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 12, left: 8),
            )
          ],
        ),
      ),
    );
  }
}
