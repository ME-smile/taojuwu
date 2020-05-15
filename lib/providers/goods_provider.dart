import 'package:flutter/material.dart';
import 'package:taojuwu/models/shop/product_bean.dart';
import 'package:taojuwu/models/shop/sku_attr/accessory_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/canopy_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/craft_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/part_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/room_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_gauze_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_pattern_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_shade_attr.dart';
import 'package:taojuwu/models/user/customer_model.dart';

class GoodsProvider with ChangeNotifier {
  ProductBean _goods;
  WindowGauzeAttr _windowGauzeAttr;
  CraftAttr _craftAttr;
  RoomAttr _roomAttr;
  PartAttr _partAttr;
  WindowShadeAttr _windowShadeAttr;
  CanopyAttr _canopyAttr;
  AccessoryAttr _accessoryAttr;

  WindowGauzeAttrBean _curwindowGauzeAttrBean;
  CraftAttrBean _curCraftAttrBean;
  PartAttrBean _curPartAttrBean;
  WindowShadeAttrBean _curWindowShadeAttrBean;
  CanopyAttrBean _curCanopyAttrBean;
  // List<AccessoryAttrBean> _allAccessoryAttrBeans;
  // List<AccessoryAttrBean> _curAccessoryAttrBeans;
  RoomAttrBean _curRoomAttrBean;

  CustomerModelBean targetCustomer;
  Map<String, dynamic> attrParams;

  String _width = '0.0';
  String _height = '0.0';
  String _dy = '0.0';

  int _curInstallMode = 0;
  int _curOpenMode = 0;

  int _curWindowPattern = 0;
  int _curWindowStyle = 0;
  int _curWindowType = 0;

  int tmpWindowPattern = 0;
  int tmpWindowStyle = 0;
  int tmpWindowType = 0;
  bool _hasInit = false;

  int _createType = 1;

  GoodsProvider();

  void initData(
      {ProductBean bean,
      WindowGauzeAttr windowGauzeAttr,
      CraftAttr craftAttr,
      PartAttr partAttr,
      WindowShadeAttr windowShadeAttr,
      CanopyAttr canopyAttr,
      AccessoryAttr accessoryAttr,
      RoomAttr roomAttr}) {
    _goods = bean;
    _windowGauzeAttr = windowGauzeAttr;
    _craftAttr = craftAttr;
    _partAttr = partAttr;
    _canopyAttr = canopyAttr;
    _roomAttr = roomAttr;
    _accessoryAttr = accessoryAttr;
    _windowShadeAttr = windowShadeAttr;
    _curwindowGauzeAttrBean = windowGauzeAttr?.data?.isNotEmpty == true
        ? windowGauzeAttr?.data?.first
        : null;
    _curCraftAttrBean =
        craftAttr?.data?.isNotEmpty == true ? craftAttr?.data?.first : null;
    _curPartAttrBean =
        partAttr?.data?.isNotEmpty == true ? partAttr?.data?.first : null;
    _curWindowShadeAttrBean = windowShadeAttr?.data?.isNotEmpty == true
        ? windowShadeAttr?.data?.first
        : null;
    _curCanopyAttrBean =
        canopyAttr?.data?.isNotEmpty == true ? canopyAttr?.data?.first : null;
    _curRoomAttrBean =
        roomAttr?.data?.isNotEmpty == true ? roomAttr?.data?.first : null;
    _hasInit = true;
  }

  int get goodsId => _goods?.goodsId ?? -1;
  WindowGauzeAttrBean get curWindowGauzeAttrBean => _curwindowGauzeAttrBean;
  CraftAttrBean get curCraftAttrBean => _curCraftAttrBean;
  PartAttrBean get curPartAttrBean => _curPartAttrBean;
  WindowShadeAttrBean get curWindowShadeAttrBean => _curWindowShadeAttrBean;
  CanopyAttrBean get curCanopyAttrBean => _curCanopyAttrBean;
  int get createType => _createType;
  List<AccessoryAttrBean> get curAccessoryAttrBeans =>
      accessoryAttr?.data?.isNotEmpty == true
          ? accessoryAttr?.data
                  ?.where((item) => item.isChecked == true)
                  ?.toList() ??
              []
          : null;
  RoomAttrBean get curRoomAttrBean => _curRoomAttrBean;
  int get curInstallMode => _curInstallMode;
  int get curWindowPattern => _curWindowPattern;
  int get curWindowStyle => _curWindowStyle;
  int get curWindowType => _curWindowType;
  int get curOpenMode => _curOpenMode;
  bool get hasInit => _hasInit;
  bool get isShade => _curwindowGauzeAttrBean?.name?.contains('无');
  double get widthCM => double.parse(_width);
  double get heightCM => double.parse(_height);
  double get dyCM => double.parse(_dy);
  double get widthM =>
      double.parse(((double.parse(_width)) / 100).toStringAsFixed(3));
  double get heightM =>
      double.parse(((double.parse(_height)) / 100).toStringAsFixed(3));
  get measureId => _goods?.measureId;
  ProductBean get goods => _goods;
  WindowGauzeAttr get windowGauzeAttr => _windowGauzeAttr;
  CraftAttr get craftAttr => _craftAttr;
  RoomAttr get roomAttr => _roomAttr;
  PartAttr get partAttr => _partAttr;
  WindowShadeAttr get windowShadeAttr => _windowShadeAttr;
  CanopyAttr get canopyAttr => _canopyAttr;
  AccessoryAttr get accessoryAttr => _accessoryAttr;
  String get curOpenModeName => WindowPatternAttr.openModes[curOpenMode ?? 0];
  String get curInstallModeName =>
      WindowPatternAttr.installModes[curInstallMode ?? 0];
  String get windowPatternStr =>
      '${WindowPatternAttr.patternsText[curWindowPattern ?? 0]}/${WindowPatternAttr.stylesText[curWindowStyle ?? 0]}/${WindowPatternAttr.typesText[curWindowType ?? 0]}';
  int get windowPatternId => WindowPatternAttr.patternMap[windowPatternStr];
  String get measureDataStr =>
      '${curRoomAttrBean?.name ?? ''}\n宽 ${widthM ?? ''}米 高${heightM ?? ''}米';

  String get dy => _dy;

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

  bool get isMeasureOrder => createType == 2;
  bool get hasSetSize => measureId != null;
  bool get hasLike => goods?.isCollect == 1 ?? false;
  bool get hasWindowGauze =>
      curWindowGauzeAttrBean?.name?.contains('不要窗纱') == false;
  set curWindowGauzeAttrBean(WindowGauzeAttrBean bean) {
    _curwindowGauzeAttrBean = bean;
    notifyListeners();
  }

  set hasInit(bool flag) {
    _hasInit = flag;
    notifyListeners();
  }

  set curCraftAttrBean(CraftAttrBean bean) {
    _curCraftAttrBean = bean;
    notifyListeners();
  }

  void initSize(String width, String height, String dy,
      {String installMode: '顶装', String openMode: '整体对开'}) {
    _width = width;
    _height = height;
    _dy = dy;
    _curInstallMode = WindowPatternAttr.installModeMap[installMode];
    _curOpenMode = WindowPatternAttr.openModeMap[openMode];
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

  set curInstallMode(int mode) {
    _curInstallMode = mode;
    notifyListeners();
  }

  set curOpenMode(int mode) {
    _curOpenMode = mode;
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

  set curWindowType(int style) {
    _curWindowType = style;
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

  setTargetCustomer(BuildContext context, CustomerModelBean bean) {
    targetCustomer = bean;
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
    notifyListeners();
  }

  bool get isWindowGauze {
    return goods?.goodsSpecialType == 3 ?? false;
  }

  double get area {
    double area = widthM * heightM;
    return area > 1 ? area : 1;
  }

  double get unitPrice {
    return double.parse(goods?.price ?? '0.00');
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

  double get totalPrice {
    double tmp = unitPrice;
    if (goods?.goodsSpecialType == 2) {
      return unitPrice * area;
    } else if (goods?.goodsSpecialType == 4) {
      return widthM * unitPrice;
    } else {
      // 配饰价格计算 acc-->accesspry

      double heightFactor = 1.0;
      if (heightCM > 270) {
        heightFactor = 1.5;
      }

      if (hasWindowGauze) {
        tmp = (unitPrice + windowShadeClothPrice + windowGauzePrice) *
                2 *
                widthM *
                heightFactor +
            canopyPrice * widthM +
            partPrice * widthM * 2 +
            accPrice;
      } else {
        tmp = (unitPrice + windowShadeClothPrice + windowGauzePrice) *
                2 *
                widthM *
                heightFactor +
            canopyPrice * widthM +
            partPrice * widthM +
            accPrice;
      }
    }
    return double.parse(tmp.toStringAsFixed(3));
  }

  void clearGoodsInfo() {
    _width = '0.0';
    _height = '0.0';
    _dy = '0.0';
    _goods = null;
    notifyListeners();
  }
}
