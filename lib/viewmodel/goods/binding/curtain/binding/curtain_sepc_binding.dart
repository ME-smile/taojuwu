/*
 * @Description: 商品属性相关的逻辑
 * @Author: iamsmiling
 * @Date: 2020-09-27 10:16:14
 * @LastEditTime: 2020-09-30 17:39:52
 */
import 'package:taojuwu/repository/order/measure_data_model.dart';

import 'package:taojuwu/repository/shop/sku_attr/goods_attr_bean.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/curtain_goods_binding.dart';

mixin CurtainSpecBinding on CurtainGoodsBinding {
  //属性列表
  List<GoodsSkuAttr> skuList = [];

  //空间属性 空间在另一个页面 所以没有存放到数组中
  GoodsSkuAttr skuRoom;
  // 需要获取的参数列表
  List<int> get typeList {
    return isWindowSunblind ? [3, 4, 5, 8, 12, 13] : [3, 4, 5, 13];
  }

  //当前选中的窗帘
  GoodsSkuAttrBean get curWindowGauzeAttrBean => getSelectedElement(3);

  bool get hasWindowGauze =>
      curWindowGauzeAttrBean?.name?.contains('不要窗纱') == false ?? false;
  // 当前选中的型材
  GoodsSkuAttrBean get curPartAttrBean => getSelectedElement(5);
  // 当前选中的里布
  GoodsSkuAttrBean get curWindowShadeAttrBean => getSelectedElement(12);

  //当前选中的幔头
  GoodsSkuAttrBean get curCanopyAttrBean => getSelectedElement(8);
  // 选中的配饰
  List<GoodsSkuAttrBean> get selectedAccessoryBeans =>
      getAllSelectedAccessories();

  // 当前选中的空间
  GoodsSkuAttrBean get curRoomAttrBean => getSelectedElement(1);

  /*
   * @Author: iamsmiling
   * @description: 闯入一个type参数，获取当前的属性选择的属性值
   * @param : int type
   * @return {type}  GoodsSkuAttrBean  当前属性的选中值
   * @Date: 2020-09-30 13:12:33
   */
  GoodsSkuAttrBean getSelectedElement(int type) {
    List<GoodsSkuAttrBean> list = getSelectedElementList(type);
    if (CommonKit.isNullOrEmpty(list)) return null;
    return list?.firstWhere((element) => element.isChecked);
  }

  List<GoodsSkuAttrBean> getAllSelectedAccessories() {
    List<GoodsSkuAttrBean> list = getSelectedElementList(13);
    if (CommonKit.isNullOrEmpty(list)) return null;
    return list?.where((element) => element.isChecked)?.toList();
  }

  List<GoodsSkuAttrBean> getSelectedElementList(int type) {
    GoodsSkuAttr attr;
    List<GoodsSkuAttrBean> list = [];
    for (int i = 0; i < skuList.length; i++) {
      GoodsSkuAttr item = skuList[i];
      if (item?.type == type) {
        attr = item;
        list = attr?.data ?? [];
        break;
      }
    }
    return list;
  }

  //确保_fetchData只会被初始化一次的标识位
  bool _hasInit = false;
  @override
  void addListener(listener) {
    super.addListener(listener);
    if (!_hasInit)
      _fetchData().whenComplete(() {
        _hasInit = true;
      });
  }

  Future _fetchData() async {
    _getCommonAttrData();
    _getRoomAttrData();
  }

  Future _getCommonAttrData() async {
    // 获取型材类型
    MeasureDataModelResp response = await getMeasureData();
    // 获取到测装数据，并保存引用
    measureData = response?.data?.measureData;
    String partsType = measureData?.partsType;
    List<Future<GoodsSkuAttrWrapperResp>> futures = typeList
        .map((e) => OTPService.skuAttr(context, params: {
              'client_uid': clientId,
              'parts_type': partsType,
              'goods_id': goodsId,
              'type': e
            }).then((GoodsSkuAttrWrapperResp response) {
              if (response?.valid == true) {
                skuList.add(response?.data);
              }
            }).catchError((err) => err))
        .toList();
    await Future.wait(futures);
    skuList?.sort((GoodsSkuAttr a, GoodsSkuAttr b) => a.type - b.type);
    notifyListeners();
  }

  Future _getRoomAttrData() {
    return OTPService.skuAttr(context, params: {'goods_id': goodsId, 'type': 1})
        .then((GoodsSkuAttrWrapperResp response) {
      if (response?.valid == true) {
        skuRoom = response.data;
      }
    }).catchError((err) => err);
  }

  /*
   * @Author: iamsmiling
   * @description:点击选中属性
   * @param : GoodsSkuAttr 当前操作的属性  i 当前属性值在属性值列表中的下标
   * @return {type} 
   * @Date: 2020-09-30 13:15:29
   */
  void selectAttrBean(GoodsSkuAttr attr, int i) {
    List<GoodsSkuAttrBean> list = attr?.data ?? [];
    if (attr.canMultiSelect) {
      GoodsSkuAttrBean bean = list[i];
      bean.isChecked = !bean.isChecked;
    } else {
      for (int j = 0; j < list.length; j++) {
        GoodsSkuAttrBean bean = list[j];
        bean.isChecked = i == j;
      }
    }
    attr.hasSelectedAttr = true;
  }

  /*
   * @Author: iamsmiling
   * @description: 属性充值默认选中第一个
   * @param : 
   * @return {type} 
   * @Date: 2020-09-29 09:25:09
   */
  void resetAttr() {
    skuList.forEach((e) {
      for (int i = 0; i < e.data.length; i++) {
        e.data[i].isChecked = i == 0;
      }
    });
    notifyListeners();
  }
}
