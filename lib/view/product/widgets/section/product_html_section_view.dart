/*
 * @Description: 商品详情html描述
 * @Author: iamsmiling
 * @Date: 2020-10-22 14:32:01
 * @LastEditTime: 2020-10-22 14:32:29
 */
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductHtmlDescSectionView extends StatelessWidget {
  final String html;
  const ProductHtmlDescSectionView(this.html, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.only(top: 8),
      child: Html(data: html),
      padding: EdgeInsets.symmetric(horizontal: 16),
    ));
  }
}
