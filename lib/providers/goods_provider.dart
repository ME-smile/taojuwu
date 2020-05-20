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

  //因为需要对工艺和型材进行筛选
  List<CraftAttrBean> _initCraftAttrBeanList = [];
  List<PartAttrBean> _initPartAttrBeanList = [];
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

  int _curInstallOptionIndex = 0;
  int _createType = 1;

  GoodsProvider();

  void filterCraft() {
    List<CraftAttrBean> list = _initCraftAttrBeanList;
    if (list?.isNotEmpty != true) return;

    //有盒去掉打孔工艺

    String screenWord1 = '打孔';
    List<CraftAttrBean> tmp1 = [];
    if (_curWindowType == 1) {
      for (int i = 0; i < list?.length; i++) {
        CraftAttrBean bean = list[i];
        if (bean?.name?.contains(screenWord1) == false) {
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

    //不要窗纱的情况；
    List<CraftAttrBean> tmp2 = [];
    if (_curwindowGauzeAttrBean?.name?.contains(screenWord2) == true) {
      for (int i = 0; i < tmp1?.length; i++) {
        CraftAttrBean bean = tmp1[i];

        if (bean?.name?.contains(screenWord3) == true) {
          //留下单配件工艺
          tmp2.add(bean);
        }
      }
    } else {
      //要窗纱的情况；
      for (int i = 0; i < tmp1?.length; i++) {
        CraftAttrBean bean = tmp1[i];
        if (bean?.name?.contains(screenWord4) == true) {
          //留下单配件工艺

          tmp2.add(bean);
        }
      }
    }

    _craftAttr?.data = tmp2;
    _curCraftAttrBean =
        _craftAttr?.data?.isNotEmpty == true ? _craftAttr?.data?.first : null;
  }

  List<String> getInstallOptions() {
    String keyword1 = '非飘窗';
    String keyword2 = '有盒';
    if (windowPatternStr?.contains(keyword1) == true &&
        windowPatternStr?.contains(keyword2) == false) {
      return ['顶装', '测装'];
    } else if (windowPatternStr?.contains(keyword2) == true) {
      return ['盒内装'];
    }
    return ['顶墙满装'];
  }

  void filterParts() {
    List<PartAttrBean> list = _initPartAttrBeanList;
    if (list?.isNotEmpty != true) return;
    String screenWord1 = 'GD';
    List<PartAttrBean> tmp1 = [];

    if (_curWindowType == 1) {
      for (int i = 0; i < list?.length; i++) {
        PartAttrBean bean = list[i];
        if (bean?.name?.contains(screenWord1) == true) {
          tmp1.add(bean);
        }
      }
    } else {
      tmp1 = list;
    }

    _partAttr?.data = tmp1;
    _curPartAttrBean =
        _partAttr?.data?.isNotEmpty == true ? _partAttr?.data?.first : null;
  }

  void initDataWithFilter(
      {ProductBean bean,
      WindowGauzeAttr windowGauzeAttr,
      CraftAttr craftAttr,
      PartAttr partAttr,
      WindowShadeAttr windowShadeAttr,
      CanopyAttr canopyAttr,
      AccessoryAttr accessoryAttr,
      RoomAttr roomAttr}) {
    initData(
        bean: bean,
        windowGauzeAttr: windowGauzeAttr,
        craftAttr: craftAttr,
        partAttr: partAttr,
        windowShadeAttr: windowShadeAttr,
        canopyAttr: canopyAttr,
        accessoryAttr: accessoryAttr,
        roomAttr: roomAttr);
    filterCraft();
  }

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
  double get widthM => (widthCM / 100);
  String get widthCMStr => _width == '0.0' ? null : _width;
  String get heightCMStr => _height == '0.0' ? null : _height;
  String get dyCMStr => _dy == '0.0' ? null : _dy;
  String get widthMStr => widthM.toStringAsFixed(2);
  double get heightM =>
      double.parse(((double.parse(_height)) / 100).toStringAsFixed(3));
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
  String get curOpenModeName => WindowPatternAttr.openModes[curOpenMode ?? 0];
  String get curInstallModeName =>
      WindowPatternAttr.installModes[curInstallMode ?? 0];
  String get windowPatternStr =>
      '${WindowPatternAttr.patternsText[curWindowPattern ?? 0]}/${WindowPatternAttr.stylesText[curWindowStyle ?? 0]}/${WindowPatternAttr.typesText[curWindowType ?? 0]}';
  int get windowPatternId => WindowPatternAttr.patternMap[windowPatternStr];
  String get measureDataStr =>
      '${curRoomAttrBean?.name ?? ''}\n宽 ${widthMStr ?? ''}米 高${heightMStr ?? ''}米';

  int get curInstallOptionIndex => _curInstallOptionIndex;
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
  bool get hasLike => goods?.isCollect == 1;
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
    _width = width; //厘米为单位
    _height = height; //厘米为单位
    _dy = dy; //厘米为单位
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
    filterCraft();
    filterParts();
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
