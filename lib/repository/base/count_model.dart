/*
 * @Description: 抽象类
 * @Author: iamsmiling
 * @Date: 2020-10-31 13:34:34
 * @LastEditTime: 2020-11-04 09:34:55
 */
import 'package:flutter/foundation.dart';

abstract class CountModel {
  int count;

  CountModel({
    @required this.count,
  });
}
