/*
 * @Description: 商品详情页
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:55:05
 * @LastEditTime: 2020-10-21 15:01:11
 */
import 'package:flutter/material.dart';

import 'package:taojuwu/services/otp_service.dart';

class ProductDetailPage extends StatefulWidget {
  final int goodsId;
  const ProductDetailPage(this.goodsId, {Key key}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isLoading = true;

  @override
  void initState() {
    OTPService.productDetail(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text('1234567800');
    // return ChangeNotifierProvider<SingleProductProvider>(
    //   create: (context)=>(),
    // );
  }
}
