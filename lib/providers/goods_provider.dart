import 'package:flutter/material.dart';
import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/models/shop/product_bean.dart';
import 'package:taojuwu/models/shop/sku_attr/accessory_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/canopy_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/craft_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/part_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/room_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_gauze_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_pattern_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_shade_attr.dart';

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

  String partName;
  // List<AccessoryAttrBean> _allAccessoryAttrBeans;
  // List<AccessoryAttrBean> _curAccessoryAttrBeans;

  //因为需要对工艺和型材进行筛选
  List<CraftAttrBean> _initCraftAttrBeanList = [];
  List<PartAttrBean> _initPartAttrBeanList = [];
  RoomAttrBean _curRoomAttrBean;
  OrderGoodsMeasure _measureData;
  OrderGoodsMeasure _forWindowRollerMeasureData;

  Map<String, dynamic> attrParams;

  String _width = '0.0';
  String _height = '0.0';
  String _dy = '0.0';

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
    Map<String, dynamic> map =
        list?.firstWhere((item) => item['is_checked'] == true);

    return map['text'];
  }

  OrderGoodsMeasure get forWindowRollerMeasureData =>
      _forWindowRollerMeasureData;
  bool get isWindowGauze => goods?.goodsSpecialType == 3;
  bool get isWindowRoller => goods?.goodsSpecialType == 2;
  int _curWindowPattern = 0;
  int _curWindowStyle = 0;
  int _curWindowType = 0;
  OrderGoodsMeasure get measureData => _measureData;
  int tmpWindowPattern = 0;
  int tmpWindowStyle = 0;
  int tmpWindowType = 0;
  bool _hasInit = false;

  int _curInstallOptionIndex = 0;
  int _createType = 1;

  GoodsProvider();

  set forWindowRollerMeasureData(OrderGoodsMeasure data) {
    _forWindowRollerMeasureData = data;
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

  void initDataWithFilter({
    ProductBean bean,
    WindowGauzeAttr windowGauzeAttr,
    CraftAttr craftAttr,
    PartAttr partAttr,
    WindowShadeAttr windowShadeAttr,
    CanopyAttr canopyAttr,
    AccessoryAttr accessoryAttr,
    RoomAttr roomAttr,
  }) {
    initData(
      bean: bean,
      windowGauzeAttr: windowGauzeAttr,
      craftAttr: craftAttr,
      partAttr: partAttr,
      windowShadeAttr: windowShadeAttr,
      canopyAttr: canopyAttr,
      accessoryAttr: accessoryAttr,
      roomAttr: roomAttr,
    );
    filterCraft();
    filterParts();
  }

  void initData({
    ProductBean bean,
    WindowGauzeAttr windowGauzeAttr,
    CraftAttr craftAttr,
    PartAttr partAttr,
    WindowShadeAttr windowShadeAttr,
    CanopyAttr canopyAttr,
    AccessoryAttr accessoryAttr,
    RoomAttr roomAttr,
  }) {
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

  List<Map<String, dynamic>> get installOptions =>
      WindowPatternAttr.installOptionMap[windowPatternStr];

  List<Map<String, dynamic>> get openOptions =>
      WindowPatternAttr.openOptionMap[curWindowPatternName];
  List get openSubOptions =>
      WindowPatternAttr.openSubOptionMap['$curWindowPatternName/$curOpenMode'];
  int get curWindowPattern => _curWindowPattern;
  int get curWindowStyle => _curWindowStyle;
  int get curWindowType => _curWindowType;
  bool get hasInit => _hasInit;
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
  bool get hasInitOpenMode => _hasInitOpenMode;
  bool _hasInitOpenMode = false;
  bool get hasSetSizeForWindowRoller {
    if (_width == '0.0' ||
        _height == '0.0' ||
        _width == null ||
        _height == null ||
        _width?.isNotEmpty != true ||
        _height?.isNotEmpty != true) {
      return false;
    }
    return true;
  }

  bool get hasSetDy {
    if (_dy == '0.0' || _dy?.isNotEmpty != true || _dy == null) {
      return false;
    }
    return true;
  }

  String get sizeText => hasSetSizeForWindowRoller
      ? '宽 ${widthMStr ?? ''}米 高${heightMStr ?? ''}米'
      : '尺寸';
  String get dyText => hasSetDy ? '${_dy}cm' : '离地距离(cm)';
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
    _hasInitOpenMode = true;
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

  String get forWindowRollerWidthMstr {
    String w = forWindowRollerMeasureData?.width ?? '';
    if (w == null && w?.isNotEmpty != true) return '0.00';
    double width = double.parse(w ?? '0.00');
    width = width / 100;
    return width.toStringAsFixed(2);
  }

  String get forWindowRollerHeightMstr {
    String h = forWindowRollerMeasureData?.height ?? '';
    if (h == null && h?.isNotEmpty != true) return '0.00';
    double height = double.parse(h ?? '0.00 ');
    height = height / 100;
    return height.toStringAsFixed(2);
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

  Map get checkedSubOption {
    Map tmp = {};
    for (int i = 0; i < openSubOptions?.length; i++) {
      Map item = openSubOptions[i];
      for (int j = 0; j < item['options']?.length; j++) {
        Map dict = item['options'][j];
        if (dict['is_checked'] == true) {
          tmp[item['name']] = dict['text'];
        }
      }
    }
    return tmp;
  }

  setWindowPatternByName(String pattern) {
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

  set measureData(OrderGoodsMeasure data) {
    _measureData = data;
    notifyListeners();
  }

  set curCraftAttrBean(CraftAttrBean bean) {
    _curCraftAttrBean = bean;
    filterParts();
    notifyListeners();
  }

  void initInstallMode(String mode) {
    installOptions?.forEach((item) {
      String tmp = item['text'];

      item['is_checked'] =
          mode.contains(tmp) == true || tmp?.contains(mode) == true
              ? true
              : false;
    });
  }

  void initOpenMode(String mode) {
    openOptions?.forEach((item) {
      String tmp = item['text'];
      item['is_checked'] =
          mode.contains(tmp) == true || tmp?.contains(mode) == true
              ? true
              : false;
    });
  }

  void initWindowPattern(
      String windowPattern, String installMode, String openMode) {
    initInstallMode(installMode);
    const String WAIT_TO_CONFIRM = '待确认';
    if (openMode != null &&
        openMode?.isNotEmpty == true &&
        openMode?.contains(WAIT_TO_CONFIRM) == false) {
      initOpenMode(openMode);
    } else {
      _hasInitOpenMode = false;
    }
    setWindowPatternByName(windowPattern);
  }

  void initSize(OrderGoodsMeasure measureData) {
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

  set hasInitOpenMode(bool flag) {
    _hasInitOpenMode = flag;
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

  String get totalPrice {
    double tmp = unitPrice;

    if (isWindowRoller) {
      return (unitPrice * area).toStringAsFixed(2);
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

  Map<String, dynamic> getWindowGauzeAttrArgs() {
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
          ?.toList()
    };
  }

  Map<String, dynamic> getWindowRollerAttrArgs() {
    return {
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

  Map<String, dynamic> getAttrArgs() {
    return isWindowGauze == true
        ? getWindowGauzeAttrArgs()
        : isWindowRoller == true
            ? getWindowRollerAttrArgs()
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
                    ?.toList()
              };
  }

  void initMeasureDataForWindowRoller() {
    _width = forWindowRollerMeasureData?.width;
    _height = forWindowRollerMeasureData?.height;
    _dy = forWindowRollerMeasureData?.verticalGroundHeight;
  }
}
