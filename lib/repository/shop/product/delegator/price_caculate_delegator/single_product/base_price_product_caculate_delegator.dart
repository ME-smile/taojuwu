/*
 * @Description: 计算价格的基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 14:27:52
 * @LastEditTime: 2020-10-21 14:33:52
 */
import '../abstract_price_caculator_delegator.dart';

class BasePriceProductCaculateDelegator extends AbstractPriceCaculateDelegator {
  @override
  double get totalPrice => throw UnimplementedError();
}
