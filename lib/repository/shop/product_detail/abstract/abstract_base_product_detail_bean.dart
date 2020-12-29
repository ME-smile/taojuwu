/*
 * @Description: //所有商品的抽象类基类
 * @Author: iamsmiling
 * @Date: 2020-10-21 13:03:47
 * @LastEditTime: 2020-12-28 11:04:37
 */

enum ProductType {
  //布艺帘
  FabricCurtainProductType,
  //卷帘
  RollingCurtainProductType,
  //窗纱
  GauzeCurtainProductType,

  //型材
  SectionalProductType,
  // 成品
  EndProductType,

  // 场景
  SceneDesignProductType,
  // 软装方案
  SoftDesignProductType,

  //购物车商品
  CartProductType
}

abstract class AbstractBaseProductDetailBean {}
