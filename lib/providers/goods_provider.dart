import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:taojuwu/repository/order/order_detail_model.dart';
import 'package:taojuwu/repository/shop/cart_list_model.dart';
import 'package:taojuwu/repository/shop/product_bean.dart';
import 'package:taojuwu/repository/shop/sku_attr/accessory_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/canopy_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/craft_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/part_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/room_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/window_gauze_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/window_pattern_attr.dart';
import 'package:taojuwu/repository/shop/sku_attr/window_shade_attr.dart';
import 'package:taojuwu/repository/zy_response.dart';
import 'package:taojuwu/router/handlers.dart';
import 'package:taojuwu/services/otp_service.dart';
import 'package:taojuwu/singleton/target_client.dart';
import 'package:taojuwu/singleton/target_order_goods.dart';
import 'package:taojuwu/utils/toast_kit.dart';

class GoodsProvider with ChangeNotifier {
  bool get isMeasureOrderGoods =>
      TargetOrderGoods.instance.orderGoodsId != null;
  ProductBean _goods;
  WindowGauzeAttr _windowGauzeAttr;
  CraftAttr _craftAttr;
  RoomAttr _roomAttr;
  PartAttr _partAttr;
  WindowShadeAttr _windowShadeAttr;
  CanopyAttr _canopyAttr;
  AccessoryAttr _accessoryAttr;
  OrderGoodsMeasureData _measureData;

  WindowGauzeAttrBean _curwindowGauzeAttrBean;
  CraftAttrBean _curCraftAttrBean;
  PartAttrBean _curPartAttrBean;
  WindowShadeAttrBean _curWindowShadeAttrBean;
  CanopyAttrBean _curCanopyAttrBean;

  // List<AccessoryAttrBean> _allAccessoryAttrBeans;
  // List<AccessoryAttrBean> _curAccessoryAttrBeans;

  //因为需要对工艺和型材进行筛选
  List<CraftAttrBean> _initCraftAttrBeanList = [];
  List<PartAttrBean> _initPartAttrBeanList = [];
  RoomAttrBean _curRoomAttrBean;

  String _width = '0.0';
  String _height = '0.0';
  String _dy = '0.0';
  int _cartCount = 0;
  int get cartCount => _cartCount;

  Map<String, dynamic> get cartDetail {
    return {
      'sku_id': '${goods?.skuId}' ?? '',
      'goods_id': '${goods?.goodsId}' ?? '',
      'goods_name': '${goods?.goodsName}' ?? '',
      'shop_id': '${goods?.shopId}' ?? '',
      'price': '${goods?.price}' ?? '',
      'picture': '${goods?.picture}' ?? '',
      'num': '1'
    };
  }

  set cartCount(int count) {
    _cartCount = count;
    notifyListeners();
  }

  bool get isFixedHeight => true;
  String get curInstallMode {
    List list = WindowPatternAttr.installOptionMap[windowPatternStr];
    Map<String, dynamic> map =
        list?.firstWhere((item) => item['is_checked'] == true);
    return map['text'];
  }

  String get curWindowPatternName =>
      WindowPatternAttr.patternsText[curWindowPattern];

  String get curOpenMode {
    List list = WindowPatternAttr.openOptionMap[curWindowPatternName] ?? [];

    for (int i = 0; i < list?.length ?? 0; i++) {
      Map<String, dynamic> item = list[i];
      if (item['is_checked']) {
        return item['text'];
      }
    }
    return '打开方式未确认';
  }

  OrderGoodsMeasureData get measureData => _measureData;

  bool get isWindowGauze => goods?.goodsSpecialType == 3;
  bool get isWindowRoller => goods?.goodsSpecialType == 2;
  int _curWindowPattern = 0;
  int _curWindowStyle = 0;
  int _curWindowType = 0;
  int tmpWindowPattern = 0;
  int tmpWindowStyle = 0;
  int tmpWindowType = 0;

  int _curInstallOptionIndex = 0;
  int _createType = 1;

  // 是否允许添加到购物车的操作
  bool _canAddToCart = true;

  bool get canAddToCart => _canAddToCart;

  set canAddToCart(bool flag) {
    _canAddToCart = flag;
    notifyListeners();
  }

  void filterCraft() {
    List<CraftAttrBean> list = _initCraftAttrBeanList;
    if (list?.isNotEmpty != true) return;

    //有盒去掉打孔工艺

    String screenWord1 = '打孔';
    List<CraftAttrBean> tmp1 = [];

    // 有盒
    if (_curWindowType == 1) {
      for (int i = 0; i < list?.length; i++) {
        CraftAttrBean bean = list[i];
        if (bean?.name?.contains(screenWord1) == false &&
            tmp1?.contains(bean) == false) {
          tmp1.add(bean);
        }
      }
    } else {
      tmp1 = list;
    }
    //有窗纱,留下双配件工艺   无窗纱,留下单配件工艺
    String screenWord2 = '不要'; //不要窗纱

    String screenWord3 = '单';
    String screenWord4 = '双';

    List<CraftAttrBean> tmp2 = [];
    //不要窗纱的情况；
    if (_curwindowGauzeAttrBean?.name?.contains(screenWord2) == true) {
      for (int i = 0; i < tmp1?.length; i++) {
        CraftAttrBean bean = tmp1[i];

        if (bean?.name?.contains(screenWord3) == true &&
            tmp2?.contains(bean) == false) {
          //留下单配件工艺
          tmp2.add(bean);
        }
      }
    } else {
      //要窗纱的情况；
      for (int i = 0; i < tmp1?.length; i++) {
        CraftAttrBean bean = tmp1[i];
        if (bean?.name?.contains(screenWord4) == true &&
            tmp2?.contains(bean) == false) {
          //留下单配件工艺
          tmp2.add(bean);
        }
      }
    }

    _craftAttr?.data = tmp2;
    _curCraftAttrBean =
        _craftAttr?.data?.isNotEmpty == true ? _craftAttr?.data?.first : null;
  }

  void filterParts() {
    List<PartAttrBean> list = _initPartAttrBeanList;

    if (list?.isNotEmpty != true) return;
    String screenWord1 = 'GD';
    List<PartAttrBean> tmp1 = [];
    // 有盒
    if (_curWindowType == 1) {
      for (int i = 0; i < list?.length; i++) {
        PartAttrBean bean = list[i];
        if (bean?.name?.contains(screenWord1) == true &&
            tmp1?.contains(bean) == false) {
          tmp1.add(bean);
        }
      }
    } else {
      tmp1 = list;
    }
    List<PartAttrBean> tmp2 = [];
    if (curCraftAttrBean?.name?.contains('打孔') == true) {
      for (int i = 0; i < tmp1?.length; i++) {
        PartAttrBean bean = list[i];
        if (bean?.name?.contains('LMG') == true) {
          tmp2.add(bean);
        }
      }
    } else {
      tmp2 = tmp1;
    }
    _partAttr?.data = tmp2;
    _curPartAttrBean =
        _partAttr?.data?.isNotEmpty == true ? _partAttr?.data?.first : null;
  }

  void initDataWithFilter(
      {OrderGoodsMeasureData measureData,
      ProductBean bean,
      WindowGauzeAttr windowGauzeAttr,
      CraftAttr craftAttr,
      PartAttr partAttr,
      WindowShadeAttr windowShadeAttr,
      CanopyAttr canopyAttr,
      AccessoryAttr accessoryAttr,
      RoomAttr roomAttr,
      int cartCount}) {
    initData(
        measureData: measureData,
        bean: bean,
        windowGauzeAttr: windowGauzeAttr,
        craftAttr: craftAttr,
        partAttr: partAttr,
        windowShadeAttr: windowShadeAttr,
        canopyAttr: canopyAttr,
        accessoryAttr: accessoryAttr,
        roomAttr: roomAttr,
        cartCount: cartCount);
    filterCraft();
    filterParts();
  }

  dynamic getElementById(List<dynamic> list, int id) {
    if (list == null || list?.isEmpty == true || id == 0 || id == null)
      return null;

    if (list.every((element) => element?.id == id)) {
      return list.firstWhere((element) => element?.id == id);
    } else {
      return list?.first;
    }
  }

  initDataFromGoodsAttr(data, Map<int, dynamic> idMap) {
    _windowGauzeAttr = data[0];
    int wndowGauzeAttrId = idMap[3];
    _curwindowGauzeAttrBean =
        getElementById(_windowGauzeAttr?.data, wndowGauzeAttrId);
    // _curwindowGauzeAttrBean = _windowGauzeAttr?.data?.isNotEmpty == true &&
    //         (wndowGauzeAttrId != 0 && wndowGauzeAttrId != null)
    //     ? windowGauzeAttr?.data
    //             ?.firstWhere((element) => element?.id == wndowGauzeAttrId) ??
    //         _windowGauzeAttr?.data?.first
    //     : null;
    _partAttr = data[1];
    int partAttrId = idMap[5];
    _curPartAttrBean = getElementById(_partAttr?.data, partAttrId);
    // _curPartAttrBean = _partAttr?.data?.isNotEmpty == true &&
    //         (partAttrId != 0 && partAttrId != null)
    //     ? _partAttr?.data?.firstWhere((element) => element.id == partAttrId) ??
    //         _partAttr?.data?.first
    //     : null;
    _canopyAttr = data[2];
    int canopyAttrId = idMap[8];
    _curCanopyAttrBean = getElementById(_canopyAttr?.data, canopyAttrId);
    // _curCanopyAttrBean = _canopyAttr?.data?.isNotEmpty == true &&
    //         (canopyAttrId != 0 && canopyAttrId != null)
    //     ? _canopyAttr?.data
    //             ?.firstWhere((element) => element?.id == canopyAttrId) ??
    //         _canopyAttr?.data?.first
    //     : null;
    _windowShadeAttr = data[3];
    int windowShadeAttrId = idMap[12];
    _curWindowShadeAttrBean =
        getElementById(_windowShadeAttr?.data, windowShadeAttrId);
    // _curWindowShadeAttrBean = _windowShadeAttr?.data?.isNotEmpty == true &&
    //         windowShadeAttrId != 0
    //     ? _windowShadeAttr?.data
    //             ?.firstWhere((element) => element?.id == windowShadeAttrId) ??
    //         _windowShadeAttr?.data?.first
    //     : null;
    _accessoryAttr = data[4];
    idMap[13] = idMap[13] is List ? idMap[13] : [idMap[13]];
    List accessoryAttrIdList =
        idMap[13]?.map((e) => e is int ? e : int.parse(e))?.toList();

    _accessoryAttr?.data?.forEach((element) {
      element?.isChecked =
          accessoryAttrIdList.contains(element?.id) ? true : false;
    });
    notifyListeners();
  }

  void initData(
      {OrderGoodsMeasureData measureData,
      ProductBean bean,
      WindowGauzeAttr windowGauzeAttr,
      CraftAttr craftAttr,
      PartAttr partAttr,
      WindowShadeAttr windowShadeAttr,
      CanopyAttr canopyAttr,
      AccessoryAttr accessoryAttr,
      RoomAttr roomAttr,
      int cartCount}) {
    _measureData = measureData;
    _goods = bean;
    _windowGauzeAttr = windowGauzeAttr;
    _craftAttr = craftAttr;
    _initCraftAttrBeanList?.clear();
    _initPartAttrBeanList?.clear();
    craftAttr?.data?.forEach((item) {
      if (_initCraftAttrBeanList?.contains(item) == false) {
        _initCraftAttrBeanList?.add(item);
      }
    });
    partAttr?.data?.forEach((item) {
      if (_initPartAttrBeanList?.contains(item) == false) {
        _initPartAttrBeanList?.add(item);
      }
    });

    _partAttr = partAttr;
    // _initPartAttr = partAttr;
    _canopyAttr = canopyAttr;
    _roomAttr = roomAttr;
    _accessoryAttr = accessoryAttr;
    _windowShadeAttr = windowShadeAttr;
    _curwindowGauzeAttrBean = _windowGauzeAttr?.data?.isNotEmpty == true
        ? _windowGauzeAttr?.data?.first
        : null;
    _curCraftAttrBean =
        _craftAttr?.data?.isNotEmpty == true ? _craftAttr?.data?.first : null;
    _curPartAttrBean =
        _partAttr?.data?.isNotEmpty == true ? _partAttr?.data?.first : null;
    _curWindowShadeAttrBean = _windowShadeAttr?.data?.isNotEmpty == true
        ? _windowShadeAttr?.data?.first
        : null;
    _curCanopyAttrBean =
        _canopyAttr?.data?.isNotEmpty == true ? _canopyAttr?.data?.first : null;
    _curRoomAttrBean =
        _roomAttr?.data?.isNotEmpty == true ? _roomAttr?.data?.first : null;
    _cartCount = cartCount;
    if (measureData != null) {
      initMeasureData();
    }
  }

  int get goodsType => goods?.goodsSpecialType;
  int get goodsId => _goods?.goodsId ?? -1;
  WindowGauzeAttrBean get curWindowGauzeAttrBean => _curwindowGauzeAttrBean;
  CraftAttrBean get curCraftAttrBean => _curCraftAttrBean;
  PartAttrBean get curPartAttrBean => _curPartAttrBean;
  WindowShadeAttrBean get curWindowShadeAttrBean => _curWindowShadeAttrBean;
  CanopyAttrBean get curCanopyAttrBean => _curCanopyAttrBean;
  int get createType => _createType;
  String get curAccessoryAttrBeansName =>
      curAccessoryAttrBeans?.map((e) => e?.name)?.toList()?.join(',') ?? '无';
  List<AccessoryAttrBean> get curAccessoryAttrBeans =>
      accessoryAttr?.data?.isNotEmpty == true
          ? accessoryAttr?.data
                  ?.where((item) => item.isChecked == true)
                  ?.toList() ??
              []
          : null;
  RoomAttrBean get curRoomAttrBean => _curRoomAttrBean;

  List<Map<String, dynamic>> get installOptions =>
      WindowPatternAttr.installOptionMap[windowPatternStr];

  List<Map<String, dynamic>> get openOptions =>
      WindowPatternAttr.openOptionMap[curWindowPatternName];
  List get openSubOptions =>
      WindowPatternAttr.openSubOptionMap['$curWindowPatternName/$curOpenMode'];
  int get curWindowPattern => _curWindowPattern;
  int get curWindowStyle => _curWindowStyle;
  int get curWindowType => _curWindowType;

  bool get isShade => _curwindowGauzeAttrBean?.name?.contains('无');

  double get widthCM => double.parse(_width ?? '0.0');
  double get heightCM => double.parse(_height ?? '0.0');
  double get dyCM => double.parse(_dy ?? '0.0');
  double get widthM => (widthCM / 100);
  String get widthCMStr => _width == '0.0' ? null : _width;
  String get heightCMStr => _height == '0.0' ? null : _height;
  String get dyCMStr => _dy == '0.0' ? null : _dy;
  String get widthMStr => widthM.toStringAsFixed(2);
  double get heightM =>
      double.parse(((double.parse(_height ?? '0.0')) / 100).toStringAsFixed(3));
  String get heightMStr => heightM.toStringAsFixed(2);
  get measureId => _goods?.measureId;
  ProductBean get goods => _goods;
  WindowGauzeAttr get windowGauzeAttr => _windowGauzeAttr;
  CraftAttr get craftAttr => _craftAttr;
  RoomAttr get roomAttr => _roomAttr;
  PartAttr get partAttr => _partAttr;
  WindowShadeAttr get windowShadeAttr => _windowShadeAttr;
  CanopyAttr get canopyAttr => _canopyAttr;
  AccessoryAttr get accessoryAttr => _accessoryAttr;

  bool get hasSetDy {
    if (_dy == '0.0' || _dy?.isNotEmpty != true || _dy == null) {
      return false;
    }
    return true;
  }

  String get sizeText =>
      _hasSetSize ? '宽 ${widthMStr ?? ''}米 高${heightMStr ?? ''}米' : '尺寸';
  String get dyText => hasSetDy ? '${_dy}cm' : '离地距离(cm)';
  String get unit => isWindowRoller ? '元/平方米' : '元/米';
  String get windowPatternStr =>
      '${WindowPatternAttr.patternsText[curWindowPattern ?? 0]}/${WindowPatternAttr.stylesText[curWindowStyle ?? 0]}/${WindowPatternAttr.typesText[curWindowType ?? 0]}';
  int get windowPatternId => WindowPatternAttr.patternIdMap[windowPatternStr];
  String get measureDataStr =>
      '${curRoomAttrBean?.name ?? ''}\n宽 ${widthMStr ?? ''}米 高${heightMStr ?? ''}米';

  int get curInstallOptionIndex => _curInstallOptionIndex;

  int get curOpenOptionIndex => WindowPatternAttr.openModeMap[curOpenMode];
  String get dy => _dy;

  void checkInstallMode(int i) {
    for (int j = 0; j < installOptions?.length; j++) {
      Map<String, dynamic> item = installOptions[j];
      item['is_checked'] = i == j ? true : false;
    }
    notifyListeners();
  }

  void checkOpenMode(int i) {
    for (int j = 0; j < openOptions?.length; j++) {
      Map<String, dynamic> item = openOptions[j];

      item['is_checked'] = i == j ? true : false;
    }
    notifyListeners();
  }

  void checkOpenSubOption(int i, int j) {
    Map<String, dynamic> item = openSubOptions[i];

    for (int k = 0; k < item['options']?.length; k++) {
      Map<String, dynamic> tmp = item['options'][k];
      tmp['is_checked'] = j == k ? true : false;
    }
    notifyListeners();
  }

  String get accText {
    String tmp = curAccessoryAttrBeans
        ?.map((item) => item?.name ?? '')
        ?.toList()
        ?.join(',');
    if (tmp == null || tmp?.isEmpty == true) {
      return '无';
    }
    return tmp;
  }

  get openModeParams {
    if (curOpenOptionIndex == 2) {
      return {curOpenMode: checkedSubOption};
    }
    return [curOpenMode];
  }

  void like(
    int goodsId,
  ) {
    if (!TargetClient().hasSelectedClient) {
      ToastKit.showInfo('请选择客户');
      return;
    }
    Map<String, dynamic> collectParams = {
      // 'fav_type':'goods',
      'fav_id': goodsId,
      'client_uid': TargetClient().clientId
    };
    if (hasLike == false) {
      OTPService.collect(params: collectParams).then((ZYResponse response) {
        if (response?.valid == true) {
          hasLike = true;
        }
      }).catchError((err) => err);
    } else {
      OTPService.cancelCollect(params: collectParams)
          .then((ZYResponse response) {
        if (response?.valid == true) {
          hasLike = false;
        }
      }).catchError((err) => err);
    }
  }

  Map get checkedSubOption {
    Map tmp = {};
    for (int i = 0; i < openSubOptions?.length; i++) {
      Map item = openSubOptions[i];
      for (int j = 0; j < item['options']?.length; j++) {
        Map dict = item['options'][j];
        if (dict['is_checked'] == true) {
          tmp[item['name']] = [dict['text']];
        }
      }
    }

    return tmp;
  }

  String get checkedSubOptionStr {
    List list = [];
    checkedSubOption?.forEach((key, value) {
      String tmp = '${key[0]}${value?.first[0]}';

      list.add(tmp);
    });

    return list?.join('');
  }

  setWindowPatternByName(String pattern) {
    if (pattern == null || pattern.isEmpty) return;
    List<String> list = pattern?.split('/');
    for (int i = 0; i < WindowPatternAttr.patternsText?.length; i++) {
      String item = WindowPatternAttr.patternsText[i];
      if (item == list[0]) {
        _curWindowPattern = i;
        break;
      }
    }
    for (int i = 0; i < WindowPatternAttr.stylesText?.length; i++) {
      String item = WindowPatternAttr.stylesText[i];
      if (item == list[1]) {
        _curWindowStyle = i;
        break;
      }
    }
    for (int i = 0; i < WindowPatternAttr.typesText?.length; i++) {
      String item = WindowPatternAttr.typesText[i];
      if (item == list[2]) {
        _curWindowType = i;
        break;
      }
    }
  }

  bool _hasSetSize = false;
  bool get hasSetSize => _hasSetSize;
  bool get hasLike => goods?.isCollect == 1;

  set hasLike(bool flag) {
    goods?.isCollect = flag ? 1 : 0;
    notifyListeners();
  }

  bool get hasWindowGauze =>
      curWindowGauzeAttrBean?.name?.contains('不要窗纱') == false;
  set curWindowGauzeAttrBean(WindowGauzeAttrBean bean) {
    _curwindowGauzeAttrBean = bean;
    filterCraft();
    notifyListeners();
  }

  set curInstallOptionIndex(int index) {
    _curInstallOptionIndex = index;
    notifyListeners();
  }

  set measureData(OrderGoodsMeasureData data) {
    _measureData = data;
    notifyListeners();
  }

  set curCraftAttrBean(CraftAttrBean bean) {
    _curCraftAttrBean = bean;
    filterParts();
    notifyListeners();
  }

  set hasSetSize(bool flag) {
    _hasSetSize = flag;
    notifyListeners();
  }

  void initInstallMode(
    String mode,
  ) {
    installOptions?.forEach((item) {
      String tmp = item['text'];

      item['is_checked'] =
          mode.contains(tmp) == true || tmp?.contains(mode) == true
              ? true
              : false;
    });
  }

  void initMeasureData() {
    _width = measureData?.width;
    _height = measureData?.height;
    _dy = measureData?.verticalGroundHeight;
    setWindowPatternByName(measureData?.windowType);

    List<String> arr = [];

    // Map tmp = jsonDecode(measureData?.data);
    // String id = tmp?.keys?.first;
    // if (tmp != null) {
    //   if (tmp[id] != null) {
    //     if (tmp[id]['selected'] != null &&
    //         tmp[id]['selected']['打开方式'] != null) {
    //       Map<String, dynamic> dict = tmp[id]['selected']['打开方式'];
    //       String firstKey = dict?.keys?.first;
    //       Map map = dict[firstKey];
    //       print(firstKey?.contains('分墙体') == true);
    //       if (firstKey?.contains('分墙体') == true) {
    //         map?.values?.forEach((item) {
    //           arr.add(item?.first);
    //         });
    //       }
    //     }
    //   }
    // }
    initInstallMode(measureData?.installType);
    initOpenMode(measureData?.openType, subOpenModes: arr);
  }

  void initOpenMode(String mode, {List<String> subOpenModes}) {
    const String WAIT_TO_CONFIRM = '待确认';
    if (mode == null &&
        mode?.isEmpty == true &&
        mode?.contains(WAIT_TO_CONFIRM) == true) {
      return;
    }
    openOptions?.forEach((item) {
      String tmp = item['text'];
      item['is_checked'] =
          mode.contains(tmp) == true || tmp?.contains(mode) == true
              ? true
              : false;
    });
    if (mode?.contains('分墙体') == true && subOpenModes?.isNotEmpty == true) {
      for (int i = 0; i < subOpenModes?.length; i++) {
        String str = subOpenModes[i];
        List<Map> options = WindowPatternAttr
                .openSubOptionMap['$curWindowPatternName/$curOpenMode'][i]
            ['options'];
        options?.forEach((item) {
          bool isChecked = (item['text']?.contains(str) == true ||
              str?.contains(item['text']) == true);
          item['is_checked'] = isChecked ? true : false;
        });
      }
    }
  }

  // void initWindowPattern(String windowPattern, String installMode,
  //     String openMode, String measureData) {
  //   setWindowPatternByName(windowPattern);
  //   initInstallMode(
  //     installMode,
  //   );
  // }

  void initSize(OrderGoodsMeasureData measureData) {
    _width = measureData?.width;
    _height = measureData?.height;
    _dy = measureData?.verticalGroundHeight;
    notifyListeners();
  }

  void resetSize() {
    _width = '0.0';
    _height = '0.0';
    _dy = '0.0';
    notifyListeners();
  }

  set curPartAttrBean(PartAttrBean bean) {
    _curPartAttrBean = bean;
    notifyListeners();
  }

  set curWindowShadeAttrBean(WindowShadeAttrBean bean) {
    _curWindowShadeAttrBean = bean;
    notifyListeners();
  }

  set curCanopyAttrBean(CanopyAttrBean bean) {
    _curCanopyAttrBean = bean;
    notifyListeners();
  }

  void checkAccessoryAttrBean(AccessoryAttrBean bean) {
    bean.isChecked = !bean.isChecked;

    notifyListeners();
  }

  set curRoomAttrBean(RoomAttrBean bean) {
    _curRoomAttrBean = bean;
    notifyListeners();
  }

  set curWindowPattern(int pattern) {
    _curWindowPattern = pattern;
    notifyListeners();
  }

  set curWindowStyle(int style) {
    _curWindowStyle = style;
    notifyListeners();
  }

  set curWindowType(int type) {
    _curWindowType = type;

    notifyListeners();
  }

  set width(String width) {
    _width = width;
    notifyListeners();
  }

  set height(String height) {
    _height = height;
    notifyListeners();
  }

  set dy(String dy) {
    _dy = dy;
    notifyListeners();
  }

  set isCollect(int flag) {
    goods?.isCollect = flag;
    notifyListeners();
  }

  set measureId(var id) {
    _goods?.measureId = id;
    notifyListeners();
  }

  void saveWindowAttrs() {
    _curWindowPattern = tmpWindowPattern;
    _curWindowStyle = tmpWindowStyle;
    _curWindowType = tmpWindowType;
    filterCraft();
    filterParts();
    notifyListeners();
  }

  double get area {
    double area = widthM * heightM;
    return area > 0 ? area < 1 ? 1 : area : 0;
  }

  double get unitPrice {
    return goods?.price.runtimeType == double
        ? goods?.price
        : double.parse(goods?.price ?? '0.00');
  }

  double get accPrice {
    double tmp = 0.0;
    curAccessoryAttrBeans?.forEach((item) {
      tmp += item.price;
    });
    return tmp;
  }

  double get windowShadeClothPrice {
    return curWindowShadeAttrBean?.price ?? 0.0;
  }

  double get windowGauzePrice {
    // if (goods.goodsSpecialType == 1) return 0.0
    return curWindowGauzeAttrBean?.price ?? 0.0;
  }

  double get partPrice {
    // if (goods.goodsSpecialType == 1) return 0.0;
    return curPartAttrBean?.price ?? 0.0;
  }

  double get canopyPrice {
    // if (goods.goodsSpecialType == 1) return 0.0;
    return curCanopyAttrBean?.price ?? 0.0;
  }

  String get totalPrice {
    double tmp = unitPrice;

    if (isWindowRoller) {
      return (unitPrice * area).toStringAsFixed(2);
    } else {
      // 配饰价格计算 acc-->accesspry
      double heightFactor = 1.0;
      double mainHeightFactor = 1.0;
      if (heightCM > 270) {
        heightFactor = 1.5;
        if (!isFixedHeight) {
          mainHeightFactor = (widthM + heightM - 2.65) / widthM;
        }
      }

      if (hasWindowGauze) {
        tmp = unitPrice * widthM * mainHeightFactor * 2 +
            (windowShadeClothPrice + windowGauzePrice) *
                2 *
                widthM *
                heightFactor +
            canopyPrice * widthM +
            partPrice * widthM * 2 +
            accPrice;
      } else {
        tmp = unitPrice * widthM * mainHeightFactor * 2 +
            (windowShadeClothPrice + windowGauzePrice) *
                2 *
                widthM *
                heightFactor +
            canopyPrice * widthM +
            partPrice * widthM +
            accPrice;
      }
    }
    return tmp.toStringAsFixed(2);
  }

  void clearGoodsInfo() {
    _width = '0.0';
    _height = '0.0';
    _dy = '0.0';
    _goods = null;
    _initCraftAttrBeanList?.clear();
    _initPartAttrBeanList?.clear();
    _curWindowPattern = 0;
    _curWindowStyle = 0;
    _curWindowType = 0;
    WindowPatternAttr.reset();
  }

  Map<String, dynamic> get getWindowGauzeAttrArgs {
    return {
      //工艺方式
      '1': {
        'name': curRoomAttrBean?.name ?? '',
        'id': curRoomAttrBean?.id ?? ''
      },
      '4': {
        'name': curCraftAttrBean?.name ?? '',
        'id': curCraftAttrBean?.id ?? ''
      },
      //型材
      '5': {
        'name': curPartAttrBean?.name ?? '',
        'id': curPartAttrBean?.id ?? ''
      },
      '9': [
        // {'name': '宽', 'value': provider?.width},
        // {'name': '高', 'value': provider?.height},
        {'name': '宽', 'value': '${widthCM ?? ''}'},
        {'name': '高', 'value': '${heightCM ?? ''}'}
      ],
      // 配饰
      '13': (curAccessoryAttrBeans?.isEmpty == true
                  ? [accessoryAttr?.data?.first]
                  : curAccessoryAttrBeans)
              ?.map((item) => {'name': item.name, 'id': item.id})
              ?.toList() ??
          []
    };
  }

  Map<String, dynamic> get getWindowRollerAttrArgs {
    return {
      //工艺方式
      '1': {
        'name': curRoomAttrBean?.name ?? '',
        'id': curRoomAttrBean?.id ?? ''
      },
      //窗型
      '2': {
        'name': windowPatternStr,
        'id': WindowPatternAttr.patternIdMap[windowPatternStr]
      },
      '9': [
        // {'name': '宽', 'value': provider?.width},
        // {'name': '高', 'value': provider?.height},
        {'name': '宽', 'value': '${widthCM ?? ''}'},
        {'name': '高', 'value': '${heightCM ?? ''}'}
      ],
    };
  }

  Map<String, dynamic> get attrArgs {
    return isWindowGauze == true
        ? getWindowGauzeAttrArgs
        : isWindowRoller == true
            ? getWindowRollerAttrArgs
            : {
                //空间
                '1': {
                  'name': curRoomAttrBean?.name ?? '',
                  'id': curRoomAttrBean?.id ?? ''
                },
                //窗型
                '2': {
                  'name': windowPatternStr,
                  'id': WindowPatternAttr.patternIdMap[windowPatternStr]
                },
                //窗纱
                '3': {
                  'name': curWindowGauzeAttrBean?.name ?? '',
                  'id': curWindowGauzeAttrBean?.id ?? ''
                },
                //工艺方式
                '4': {
                  'name': curCraftAttrBean?.name ?? '',
                  'id': curCraftAttrBean?.id ?? ''
                },
                //型材
                '5': {
                  'name': curPartAttrBean?.name ?? '',
                  'id': curPartAttrBean?.id ?? ''
                },
                '8': {
                  'name': curCanopyAttrBean?.name ?? '',
                  'id': curCanopyAttrBean?.id ?? '',
                },
                //帘身款式
                // '6': {},
                // // 帘身面料
                // '7': {},
                //幔头
                // '8': {'name': '', 'id': ''},

                '9': [
                  // {'name': '宽', 'value': provider?.width},
                  // {'name': '高', 'value': provider?.height},
                  {'name': '宽', 'value': '${widthCM ?? ''}'},
                  {'name': '高', 'value': '${heightCM ?? ''}'}
                ],
                //遮光里布
                '12': {
                  'name': curWindowShadeAttrBean?.name ?? '',
                  'id': curWindowShadeAttrBean?.id ?? ''
                },
                // 配饰
                '13': (curAccessoryAttrBeans?.isEmpty == true
                            ? [accessoryAttr?.data?.first]
                            : curAccessoryAttrBeans)
                        ?.map((item) => {'name': item.name, 'id': item.id})
                        ?.toList() ??
                    []
              };
  }

  Map<String, dynamic> getSaveMeasureParams() {
    Map<String, dynamic> data = {};
    Map<String, dynamic> params = {};
    params['dataId'] = '${windowPatternId ?? ''}';
    params['width'] = '${widthCMStr ?? ''}';
    params['height'] = '${heightCMStr ?? ''}';
    params['vertical_ground_height'] = '${dy ?? ''}';
    params['goods_id'] = '${goodsId ?? ''}';
    params['install_room'] = '${curRoomAttrBean?.id ?? ''}';
    data.clear();
    data['${windowPatternId ?? ''}'] = {
      'name': '${windowPatternStr ?? ''}',
      'selected': {
        '安装选项': ['${curInstallMode ?? ''}'],
        '打开方式': openModeParams
      }
    };
    params['data'] = jsonEncode(data);
    print(params);
    return params;
  }

  @override
  void dispose() {
    super.dispose();
  }

  release() {
    super.dispose();
  }

  Future saveMeasure(BuildContext context, {Function callback}) async {
    OTPService.saveMeasure(context, params: getSaveMeasureParams())
        .then((ZYResponse response) {
      if (response?.valid == true) {
        measureId = response?.data;
      }
    }).catchError((err) {
      return err;
    }).whenComplete(() {
      if (callback != null) callback();
    });
  }

  bool get hasModifyDy =>
      _measureData?.newVerticalGroundHeight !=
      _measureData?.verticalGroundHeight;

  bool get hasModifyOpenMode =>
      measureData?.openType != measureData?.newOpenType;

  bool get isValidateData {
    String w = widthCMStr ?? '0.00';
    String h = heightCMStr ?? '0.00';
    if (w?.trim()?.isEmpty == true) {
      ToastKit.showInfo('请填写宽度');
      return false;
    }
    if (double.parse(w) == 0) {
      ToastKit.showInfo('宽度不能为0哦');
      return false;
    }
    if (isFixedHeight == false && double.parse(w) > 10000) {
      ToastKit.showInfo('宽度不能超过100米');
      return false;
    }
    if (h?.trim()?.isEmpty == true) {
      ToastKit.showInfo('请填写高度');
      return false;
    }
    if (double.parse(h) == 0) {
      ToastKit.showInfo('高度不能为0哦');
      return false;
    }
    if (double.parse(h) > 350) {
      ToastKit.showInfo('暂不支持3.5m以上定制');
      h = '350';
      return false;
    }
    return true;
  }

  bool beforePurchase(BuildContext context) {
    // setParams(goodsProvider);

    if (TargetClient().hasSelectedClient == false) {
      ToastKit.showInfo('请选择客户');
      return false;
    }
    if (hasSetSize != true) {
      ToastKit.showInfo('请先填写尺寸');
      return false;
    }
    // if (isValidateData == false) {
    //   return false;
    // }
    return true;
  }

  void addCart(
    BuildContext context,
  ) {
    if (!beforePurchase(context)) return;

    canAddToCart = false;

    saveMeasure(context, callback: () {
      Map<String, dynamic> cartParams = {
        'client_uid': TargetClient().clientId,
        'wc_attr': jsonEncode(attrArgs),
        'cart_detail': jsonEncode(cartDetail),
        'measure_id': measureId,
        'estimated_price': totalPrice,
        'is_shade': isShade == true ? 1 : 0
      };
      OTPService.addCart(params: cartParams)
          .then((ZYResponse response) {
            if (response?.valid == true) {
              cartCount = response?.data;
            }
          })
          .catchError((err) => err)
          .whenComplete(() {
            canAddToCart = true;
          });
    });
  }

  Future createOrder(BuildContext context) async {
    if (!beforePurchase(context)) return;
    await saveMeasure(context, callback: () {
      purchase(context);
    });
  }

  String get openModeStr {
    if (curOpenOptionIndex == 2) {
      return '$curOpenMode:$checkedSubOptionStr';
    }
    return curOpenMode;
  }

  String get attrDesc {
    return '宽:${widthMStr ?? ''}米 高:${heightMStr ?? ''}米、${_curRoomAttrBean?.name ?? ''}、${windowPatternStr ?? ''}、${curInstallMode ?? ''}、${openModeStr ?? ''}、${_curCraftAttrBean?.name ?? ''}、离地距离:${dyCMStr?.isEmpty == true ? '未知' : dyCMStr ?? '' + 'cm'}';
  }

  Future purchase(BuildContext context) async {
    print({
      'tag': curRoomAttrBean?.name ?? '',
      'img': goods?.picCoverBig ?? '',
      'goods_name': goods?.goodsName,
      'price': goods?.price,
      'desc': attrDesc,
      'measure_id': measureId ?? '',
      'sku_id': goods?.skuId,
      'goods_id': goods?.goodsId ?? '',
      'total_price': totalPrice ?? 0.0,
      'goods_type': goodsType,
      'goods_attrs': jsonEncode([
        {
          'attr_category': '窗纱',
          'attr_name': _curwindowGauzeAttrBean?.name,
        },
        {
          'attr_category': '型材',
          'attr_name': _curPartAttrBean?.name,
        },
        {'attr_category': '里布', 'attr_name': _curWindowShadeAttrBean?.name},
        {'attr_category': '幔头', 'attr_name': _curCanopyAttrBean?.name},
        {
          'attr_category': '配饰',
          'attr_name':
              curAccessoryAttrBeans?.map((e) => e?.name)?.toList()?.join(',')
        }
      ])
    });

    RouteHandler.goCommitOrderPage(context,
        params: jsonEncode({
          'data': [
            {
              'tag': curRoomAttrBean?.name ?? '',
              'img': goods?.picCoverBig ?? '',
              'goods_name': goods?.goodsName,
              'price': goods?.price,
              'desc': attrDesc,
              'measure_id': measureId ?? '',
              'sku_id': goods?.skuId,
              'goods_id': goods?.goodsId ?? '',
              'total_price': totalPrice ?? 0.0,
              'goods_type': goodsType,
              'attr': jsonEncode(attrArgs),
              'goods_attrs': jsonEncode([
                {
                  'attr_category': '窗纱',
                  'attr_name': _curwindowGauzeAttrBean?.name ?? '',
                },
                {
                  'attr_category': '型材',
                  'attr_name': _curPartAttrBean?.name ?? '',
                },
                {
                  'attr_category': '里布',
                  'attr_name': _curWindowShadeAttrBean?.name ?? ''
                },
                {
                  'attr_category': '幔头',
                  'attr_name': _curCanopyAttrBean?.name ?? ''
                },
                {
                  'attr_category': '配饰',
                  'attr_name': curAccessoryAttrBeans
                          ?.map((e) => e?.name)
                          ?.toList()
                          ?.join(',') ??
                      ''
                }
              ])
            }
          ]
        }));
  }

  Map<String, dynamic> get cartAttrArg {
    return {
      '3': {
        'name': curWindowGauzeAttrBean?.name ?? '',
        'id': curWindowGauzeAttrBean?.id ?? ''
      },
      '5': {
        'name': curPartAttrBean?.name ?? '',
        'id': curPartAttrBean?.id ?? ''
      },
      '8': {
        'name': curCanopyAttrBean?.name ?? '',
        'id': curCanopyAttrBean?.id ?? '',
      },
      //遮光里布
      '12': {
        'name': curWindowShadeAttrBean?.name ?? '',
        'id': curWindowShadeAttrBean?.id ?? ''
      },
      // 配饰
      '13': (curAccessoryAttrBeans?.isEmpty == true
                  ? [accessoryAttr?.data?.first]
                  : curAccessoryAttrBeans)
              ?.map((item) => {'name': item.name, 'id': item.id})
              ?.toList() ??
          []
    };
  }

  void modifyCartAttr(BuildContext context,
      {Function callback, Map<String, dynamic> params}) {
    params.addAll({'wc_attr': jsonEncode(cartAttrArg)});
    OTPService.modifyCartAttr(context, params).then((ZYResponse response) {
      if (response?.valid == true) {
        GoodsAttrWrapper goodsAttrWrapper =
            GoodsAttrWrapper?.fromJson(response?.data);
        Navigator.of(context).pop(goodsAttrWrapper);
        // TargetOrderGoods.instance
        //     .setCartGoodsParams(response?.data)
        //   .then((GoodsAttrWrapper goodsAttrWrapper) {
        // print(goodsAttrWrapper?.goodsAttrList);
        // print(goodsAttrWrapper?.totalPrice);
        // Navigator.of(context).pop();
        // });

        if (callback != null) callback();
      } else {
        ToastKit.showInfo(response?.message ?? '');
      }
    }).catchError((err) => err);
  }

  void selectProduct(
    BuildContext context,
  ) {
    TargetOrderGoods targetOrderGoods = TargetOrderGoods.instance;
    if (targetOrderGoods?.hasConfirmMeasureData == false &&
        isWindowRoller == false) {
      return ToastKit.showInfo('请先确认测装数据');
    }
    Map<String, dynamic> data = {
      'num': 1,
      'goods_id': goodsId,
      '安装选项': ['${curInstallMode ?? ''}'],
      '打开方式': openModeParams
    };
    Map<String, dynamic> params = {
      'vertical_ground_height': dyCMStr,
      'data': jsonEncode(data),
      'wc_attr': jsonEncode(attrArgs),
      'order_goods_id': TargetOrderGoods.instance?.orderGoodsId,
    };

    OTPService.selectProduct(params: params).then((ZYResponse response) {
      if (response.valid) {
        clearGoodsInfo();
        TargetOrderGoods.instance.clear();
        Navigator.of(context)..pop()..pop();
        // TargetRoute.instance.setRoute(
        //     '${Routes.orderDetail}?id=${TargetOrderGoods.instance.orderId}');
        // Navigator.of(context)
        //     .popUntil(ModalRoute.withName(TargetRoute.instance.route));
      } else {
        ToastKit.showInfo(response?.message ?? '');
      }
    }).catchError((err) => err);
  }
}
