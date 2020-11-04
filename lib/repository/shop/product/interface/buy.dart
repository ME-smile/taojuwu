/*
 * @Description: 商品购买接口
 * @Author: iamsmiling
 * @Date: 2020-11-04 15:38:02
 * @LastEditTime: 2020-11-04 15:45:39
 */
import 'package:flutter/material.dart';

abstract class Buy {
  Future addToCart(BuildContext context, {Function callback});
}
