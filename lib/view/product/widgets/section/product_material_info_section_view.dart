/*
 * @Description:  商品成分信息卡片视图
 * @Author: iamsmiling
 * @Date: 2020-11-24 17:27:32
 * @LastEditTime: 2020-11-24 18:20:17
 */

import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/utils/common_kit.dart';

class ProductMaterialInfoSectionView extends StatelessWidget {
  final ProductMaterialDetailBean bean;
  const ProductMaterialInfoSectionView(this.bean, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !CommonKit.isNullOrEmpty(bean?.list),
      child: Container(
        margin: EdgeInsets.only(top: 8),
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                '商品信息',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: const Color(0xFF1B1B1B),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                children: bean?.list
                    ?.map((e) => Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 72,
                                margin: EdgeInsets.only(right: 48),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  e?.key ?? '',
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFF999999)),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  e?.value ?? '',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: const Color(0xFF333333),
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ))
                    ?.toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
