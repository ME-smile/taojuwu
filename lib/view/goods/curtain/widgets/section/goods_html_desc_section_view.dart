/*
 * @Description: 商品html详情描述
 * @Author: iamsmiling
 * @Date: 2020-10-12 14:51:38
 * @LastEditTime: 2020-10-16 14:37:00
 */
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class GoodsHtmlDescSectionView extends StatelessWidget {
  final String html;
  const GoodsHtmlDescSectionView(this.html, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(html);
    return SliverToBoxAdapter(
        child: Container(
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.only(top: 8),
      child: Html(data: html),
      padding: EdgeInsets.symmetric(horizontal: 16),
    ));
  }
}
