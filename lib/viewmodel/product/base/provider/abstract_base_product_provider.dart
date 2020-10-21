/*
 * @Description:所有商品下单基类
 * @Author: iamsmiling
 * @Date: 2020-10-20 17:46:48
 * @LastEditTime: 2020-10-21 14:07:00
 */

import 'package:flutter/material.dart';
import 'package:taojuwu/repository/shop/product/abstract/base_product_bean.dart';
import 'package:taojuwu/singleton/target_client.dart';

abstract class AbstractBaseProductProvider {
  BuildContext context;

  BaseProductBean productBean; // 当前商品

  TargetClient targetClient; // 目标客户

}
