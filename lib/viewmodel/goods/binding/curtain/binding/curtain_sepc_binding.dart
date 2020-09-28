/*
 * @Description: 商品属性相关的逻辑
 * @Author: iamsmiling
 * @Date: 2020-09-27 10:16:14
 * @LastEditTime: 2020-09-27 17:35:50
 */
import 'package:taojuwu/repository/order/measure_data_model.dart';
import 'package:taojuwu/repository/shop/sku_attr/accessory_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/canopy_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/craft_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/part_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/room_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/window_gauze_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/window_shade_attr.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/viewmodel/goods/binding/base/curtain_goods_binding.dart';

mixin CurtainSpecBinding on CurtainGoodsBinding {
  WindowGauzeAttr windowGauzeAttr; //窗纱  --单选

  CraftAttr craftAttr; //工艺  --单选

  RoomAttr roomAttr; // 空间  --单选

  PartAttr partAttr; // 配件 即型材  配件==型材  --单选

  WindowShadeAttr windowShadeAttr; //里布  --单选

  CanopyAttr canopyAttr; //幔头 --单选

  AccessoryAttr accessoryAttr; //配饰  --多选 ===窗帘订单装饰品   唯一可以多选的属性

  WindowGauzeAttrBean curWindowGauzeAttrBean; // 当前选中大的窗纱

  CraftAttrBean curCraftAttrBean; // 当前选中的工艺

  PartAttrBean curPartAttrBean; // 当前选中的型材

  WindowShadeAttrBean curWindowShadeAttrBean; // 当前选中的里布

  CanopyAttrBean curCanopyAttrBean; //当前选中幔头

  RoomAttrBean curRoomAttrBean; //当前选中的空间

  List<AccessoryAttrBean> get selectedAccessoryBeans {
    List<AccessoryAttrBean> data = accessoryAttr?.data;
    if (data == null || data.isEmpty) return null;
    return data.where((element) => element.isChecked).toList();
  }

  bool get hasWindowGauze =>
      curWindowGauzeAttrBean?.name?.contains('不要窗纱') == false;

  @override
  void addListener(listener) {
    // TODO: 请求网络接口
    print("--------发起网路请求，初始阿虎商品属性");
    fetchData();
    super.addListener(listener);
  }

  Future fetchData() async {
    String partsType = ''; // 获取型材类型
    await getMeasureData()
        .then((MeasureDataModelResp response) {
          partsType = response?.data?.measureData?.partsType;
        })
        .catchError((err) => err)
        .then((_) {
          OTPService.fetchCurtainAllAttrsData(context, params: {
            'client_uid': clientId,
            'parts_type': partsType,
            'goods_id': goodsId,
          })
              .then((data) {
                if (data == null || data.isEmpty) return;
                windowGauzeAttr = data[0];
                craftAttr = data[1];
                partAttr = data[2];
                windowShadeAttr = data[3];
                canopyAttr = data[4];
                accessoryAttr = data[5];
                roomAttr = data[6];
                initAttrs(
                    windowGauzeAttr: windowGauzeAttr,
                    craftAttr: craftAttr,
                    partAttr: partAttr,
                    windowShadeAttr: windowShadeAttr,
                    canopyAttr: canopyAttr,
                    accessoryAttr: accessoryAttr,
                    roomAttr: roomAttr);
              })
              .catchError((err) => err)
              .whenComplete(() {
                notifyListeners();
              });
        });
  }

  //  初始化商品属性，默认选中第一个
  void initAttrs({
    WindowGauzeAttr windowGauzeAttr,
    CraftAttr craftAttr,
    PartAttr partAttr,
    WindowShadeAttr windowShadeAttr,
    CanopyAttr canopyAttr,
    AccessoryAttr accessoryAttr,
    RoomAttr roomAttr,
  }) {
    curWindowGauzeAttrBean = _getFirst(windowGauzeAttr); //窗纱
    curCraftAttrBean = _getFirst(craftAttr); // 工艺
    curPartAttrBean = _getFirst(partAttr); //型材
    curWindowShadeAttrBean = _getFirst(windowShadeAttr); //里布
    curCanopyAttrBean = _getFirst(canopyAttr);
  }

  dynamic _getFirst(dynamic attr) {
    var data = attr?.data;
    if (data == null || data.isEmpty) return null;
    return data.first;
  }

  String get accText {
    String tmp = selectedAccessoryBeans
        ?.map((item) => item?.name ?? '')
        ?.toList()
        ?.join(',');
    if (tmp == null || tmp?.isEmpty == true) {
      return '无';
    }
    return tmp;
  }
}