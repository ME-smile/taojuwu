import 'package:taojuwu/repository/shop/sku_attr/window_style_sku_option.dart';
import 'package:taojuwu/utils/common_kit.dart';

class CurtainStyleSelector {
  static const Map<String, dynamic> json = {
    "data": [
      {
        "name": "单窗/飘窗/无盒",
        "id": 13,
        "install_modes": [
          {
            "name": "顶装满墙",
            "img": "curtain/size_0100-1-1-SPW-H.png",
            "is_checked": true
          }
        ],
        "open_modes": [
          {"name": "整体对开", "is_checked": true, "sub_options": [], "index": 0},
          {"name": "整体单开", "is_checked": false, "sub_options": [], "index": 1}
        ]
      },
      {
        "name": "单窗/飘窗/有盒",
        "id": 22,
        "install_modes": [
          {
            "name": "盒内装",
            "img": "curtain/size_0110-1-1-SPY-H.png",
            "is_checked": true
          }
        ],
        "open_modes": [
          {"name": "整体对开", "is_checked": true, "sub_options": [], "index": 0},
          {"name": "整体单开", "is_checked": false, "sub_options": [], "index": 1}
        ]
      },
      {
        "name": "单窗/非飘窗/无盒",
        "id": 24,
        "install_modes": [
          {"name": "顶装", "img": "curtain/size_000011.png", "is_checked": true},
          {"name": "侧装", "img": "curtain/size_000001.png", "is_checked": false}
        ],
        "open_modes": [
          {"name": "整体对开", "is_checked": true, "sub_options": [], "index": 0},
          {"name": "整体单开", "is_checked": false, "sub_options": [], "index": 1}
        ]
      },
      {
        "name": "单窗/非飘窗/有盒",
        "id": 23,
        "install_modes": [
          {
            "name": "盒内装",
            "img": "curtain/size_0010-1-1.png",
            "is_checked": true
          }
        ],
        "open_modes": [
          {"name": "整体对开", "is_checked": true, "sub_options": [], "index": 0},
          {"name": "整体单开", "is_checked": false, "sub_options": [], "index": 1}
        ]
      },
      {
        "name": "L型窗/非飘窗/无盒",
        "id": 18,
        "install_modes": [
          {"name": "顶装", "img": "curtain/size_100000.png", "is_checked": true},
          {"name": "侧装", "img": "curtain/size_100010.png", "is_checked": false}
        ],
        "open_modes": [
          {"name": "整体对开", "is_checked": true, "sub_options": [], "index": 0},
          {"name": "整体单开", "is_checked": false, "sub_options": [], "index": 1},
          {
            "name": "分墙面打开",
            "is_checked": false,
            "index": 2,
            "sub_options": [
              {
                "title": "A面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              },
              {
                "title": "B面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              }
            ]
          }
        ]
      },
      {
        "name": "L型窗/非飘窗/有盒",
        "id": 15,
        "install_modes": [
          {
            "name": "盒内装",
            "img": "curtain/size_1010-1-1.png",
            "is_checked": true
          }
        ],
        "open_modes": [
          {"name": "整体对开", "is_checked": true, "sub_options": [], "index": 0},
          {"name": "整体单开", "is_checked": false, "sub_options": [], "index": 1},
          {
            "name": "分墙面打开",
            "is_checked": false,
            "index": 2,
            "sub_options": [
              {
                "title": "A面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              },
              {
                "title": "B面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              }
            ]
          }
        ]
      },
      {
        "name": "L型窗/飘窗/无盒",
        "id": 19,
        "install_modes": [
          {
            "name": "顶装满墙",
            "img": "curtain/size_1100-1-1.png",
            "is_checked": true
          }
        ],
        "open_modes": [
          {"name": "整体对开", "is_checked": true, "index": 0, "sub_options": []},
          {"name": "整体单开", "is_checked": false, "index": 1, "sub_options": []},
          {
            "name": "分墙面打开",
            "is_checked": false,
            "index": 2,
            "sub_options": [
              {
                "title": "A面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              },
              {
                "title": "B面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              }
            ]
          }
        ]
      },
      {
        "name": "L型窗/飘窗/有盒",
        "id": 19,
        "install_modes": [
          {
            "name": "盒内装",
            "img": "curtain/size_0110-1-1-LPY-H.png",
            "is_checked": true
          }
        ],
        "open_modes": [
          {"name": "整体对开", "is_checked": true, "sub_options": [], "index": 0},
          {"name": "整体单开", "is_checked": false, "sub_options": [], "index": 1},
          {
            "name": "分墙面打开",
            "is_checked": false,
            "index": 2,
            "sub_options": [
              {
                "title": "A面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              },
              {
                "title": "B面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              }
            ]
          }
        ]
      },
      {
        "name": "U型窗/非飘窗/无盒",
        "id": 21,
        "install_modes": [
          {"name": "顶装", "img": "curtain/size_200010.png", "is_checked": true},
          {"name": "侧装", "img": "curtain/size_200000.png", "is_checked": false}
        ],
        "open_modes": [
          {"name": "整体对开", "is_checked": true, "index": 0, "sub_options": []},
          {"name": "整体单开", "is_checked": false, "index": 1, "sub_options": []},
          {
            "name": "分墙面打开",
            "is_checked": false,
            "index": 2,
            "sub_options": [
              {
                "title": "A面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              },
              {
                "title": "B面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              },
              {
                "title": "C面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              }
            ]
          }
        ]
      },
      {
        "name": "U型窗/非飘窗/有盒",
        "id": 17,
        "install_modes": [
          {
            "name": "盒内装",
            "img": "curtain/size_2010-1-1.png",
            "is_checked": true
          }
        ],
        "open_modes": [
          {"name": "整体对开", "is_checked": true, "index": 0, "sub_options": []},
          {"name": "整体单开", "is_checked": false, "index": 1, "sub_options": []},
          {
            "name": "分墙面打开",
            "is_checked": false,
            "index": 2,
            "sub_options": [
              {
                "title": "A面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              },
              {
                "title": "B面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              }
            ]
          }
        ]
      },
      {
        "name": "U型窗/飘窗/无盒",
        "id": 17,
        "install_modes": [
          {
            "name": "顶装满墙",
            "img": "curtain/size_2100-1-1.png",
            "is_checked": true
          }
        ],
        "open_modes": [
          {"name": "整体对开", "is_checked": true, "index": 0, "sub_options": []},
          {"name": "整体单开", "is_checked": false, "index": 1, "sub_options": []},
          {
            "name": "分墙面打开",
            "is_checked": false,
            "index": 2,
            "sub_options": [
              {
                "title": "A面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              },
              {
                "title": "B面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              },
              {
                "title": "C面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              }
            ]
          }
        ]
      },
      {
        "name": "U型窗/飘窗/有盒",
        "id": 16,
        "install_modes": [
          {
            "name": "盒内装",
            "img": "curtain/size_2110-1-1.png",
            "is_checked": true
          }
        ],
        "open_modes": [
          {"name": "整体对开", "is_checked": true, "index": 0, "sub_options": []},
          {"name": "整体单开", "is_checked": false, "index": 1, "sub_options": []},
          {
            "name": "分墙面打开",
            "is_checked": false,
            "index": 2,
            "sub_options": [
              {
                "title": "A面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              },
              {
                "title": "B面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              },
              {
                "title": "C面打开方式",
                "options": [
                  {"name": "单开", "is_checked": true},
                  {"name": "对开", "is_checked": false}
                ]
              }
            ]
          }
        ]
      }
    ]
  };
  WindowStyleSkuOption styleSkuOption = WindowStyleSkuOption.fromJson(json);

  //窗型列表
  List<WindowAttrOptionBean> typeOptionList = [
    WindowAttrOptionBean('单窗', 'single_window_pattern.png', isChecked: true),
    WindowAttrOptionBean('L型窗', 'L_window_pattern.png'),
    WindowAttrOptionBean('U型窗', 'U_window_pattern.png')
  ];

  // 有无飘窗
  List<WindowAttrOptionBean> bayOptionList = [
    WindowAttrOptionBean('非飘窗', 'not_bay_window.png', isChecked: true),
    WindowAttrOptionBean('飘窗', 'bay_window.png'),
  ];

  // 是否有盒
  List<WindowAttrOptionBean> boxOptionList = [
    WindowAttrOptionBean('无盒', 'window_no_can.png', isChecked: true),
    WindowAttrOptionBean('有盒', 'not_bay_window.png')
  ];
  //当前的窗帘样式 单窗 L窗 U窗,默认单窗
  String get windowType =>
      getSelectedOption(typeOptions ?? typeOptionList)?.name ?? '单窗';

  //当前的窗帘样式 有无飘窗
  String get windowBay =>
      getSelectedOption(bayOptions ?? bayOptionList)?.name ?? '非飘窗';

  //有无窗帘盒
  String get windowBox =>
      getSelectedOption(boxOptions ?? boxOptionList)?.name ?? '无盒';

  //窗帘样式
  String get windowStyleStr => '$windowType/$windowBay/$windowBox';

  //顶部展示的主图
  String get mainImg {
    return curInstallMode == null
        ? 'curtain/size_0100-1-1-SPW-H.png'
        : curInstallMode.img;
  }

  //获取当前选中的样式选项--->WindowStyleProductSkuBean对象
  WindowStyleProductSkuBean get curStyleProductSkuBean {
    List<WindowStyleProductSkuBean> list = styleSkuOption?.options;
    if (!CommonKit.isNullOrEmpty(list)) {
      WindowStyleProductSkuBean bean = list.firstWhere(
          (element) => element.name == windowStyleStr,
          orElse: () => getFirst(list));
      return bean;
    }
    return null;
  }

  set curStyleProductSkuBean(WindowStyleProductSkuBean bean) {
    // curStyleProductSkuBean = bean;
    List<WindowStyleProductSkuBean> list = styleSkuOption?.options;
    if (!CommonKit.isNullOrEmpty(list)) {
      WindowStyleProductSkuBean item = list.firstWhere(
          (element) => element?.id == bean?.id,
          orElse: () => getFirst(list));
      item?.installModeOptionBeans = bean?.installModeOptionBeans;
      item?.openModeOptionBeans = bean?.openModeOptionBeans;
    }
  }

  // 当前的安装方式
  WindowInstallModeOptionBean get curInstallMode {
    List<WindowInstallModeOptionBean> array =
        curStyleProductSkuBean?.installModeOptionBeans;
    if (!CommonKit.isNullOrEmpty(array)) {
      WindowInstallModeOptionBean bean = array.firstWhere(
          (element) => element.isChecked,
          orElse: () => getFirst(array));
      return bean;
    }
    return null;
  }

  //获取选中的选项
  WindowAttrOptionBean getSelectedOption(List<WindowAttrOptionBean> options) {
    if (CommonKit.isNullOrEmpty(options)) return null;
    return options.firstWhere((element) => element.isChecked,
        orElse: () => null);
  }

  // 获取当前应该显示的安装方式
  List<WindowInstallModeOptionBean> get installOptions =>
      curStyleProductSkuBean?.installModeOptionBeans ?? [];
  // 获取当前应该显示的打开方式
  List<WindowOpenModeOptionBean> get openOptions =>
      curStyleProductSkuBean?.openModeOptionBeans ?? [];

  set installOptions(List<WindowInstallModeOptionBean> list) {
    curStyleProductSkuBean?.installModeOptionBeans = list;
  }

  set openOptions(List<WindowOpenModeOptionBean> list) {
    curStyleProductSkuBean?.openModeOptionBeans = list;
  }

  //选择安装方式
  void selectInstallMode(WindowInstallModeOptionBean bean) {
    installOptions.forEach((element) {
      element.isChecked = element == bean;
    });
  }

  //选择打开方式
  void selectOpenMode(WindowOpenModeOptionBean bean) {
    openOptions.forEach((element) {
      element.isChecked = element == bean;
    });
  }

  // 获取选中的安装选项
  WindowInstallModeOptionBean get selectedInstallModeOption {
    return installOptions?.firstWhere((element) => element.isChecked,
        orElse: () => getFirst(installOptions));
  }

  // 获取选中的打开方式
  WindowOpenModeOptionBean get curOpenMode {
    return openOptions?.firstWhere((element) => element.isChecked,
        orElse: () => getFirst(openOptions));
  }

  getFirst(List list) {
    return CommonKit.isNullOrEmpty(list) ? null : list?.first;
  }

  //获取当前选中的打开方式的子选项
  List<WindowOpenModeSubOption> get subOpenModeOptions =>
      curOpenMode?.subOptions ?? [];

  set subOpenModeOptions(List<WindowOpenModeSubOption> list) {
    curOpenMode?.subOptions = list;
  }

  //选中子选项
  void selectSubOpenMode(
      WindowOpenModeSubOption option, WindowOpenModeSubOptionBean optionBean) {
    option.options.forEach((element) {
      element.isChecked = element == optionBean;
    });
  }

  int get styleOptionId => curStyleProductSkuBean?.id;

  List<WindowInstallModeOptionBean> installModes;
  List<WindowOpenModeOptionBean> openModes;
  List<WindowOpenModeSubOption> subOpenModes;
  List<WindowAttrOptionBean> typeOptions;
  List<WindowAttrOptionBean> bayOptions;
  List<WindowAttrOptionBean> boxOptions;
  CurtainStyleSelector(
      {this.typeOptions,
      this.bayOptions,
      this.boxOptions,
      this.installModes,
      this.openModes,
      this.subOpenModes}) {
    typeOptions ??= typeOptionList;
    bayOptions ??= bayOptionList;
    boxOptions ??= boxOptionList;
    // installModes ??= curInstallMode;
    // openModes ??= curOpenMode;
    subOpenModes ??= subOpenModeOptions;
  }

  List<WindowAttrOptionBean> copyOptions(List<WindowAttrOptionBean> list) {
    return list
        ?.map((e) => WindowAttrOptionBean.fromJson(e.toJson()))
        ?.toList();
  }

  CurtainStyleSelector copy() {
    CurtainStyleSelector selector = CurtainStyleSelector();
    // Map<String, dynamic> subOpenModeOptionMap = {};

    selector.typeOptions = copyOptions(typeOptionList);
    selector.bayOptionList = copyOptions(bayOptionList);
    selector.boxOptions = copyOptions(boxOptionList);

    selector.installOptions = installOptions
        ?.map((e) => WindowInstallModeOptionBean.fromJson(e.toJson()))
        ?.toList();

    selector.openOptions = openOptions
        ?.map((e) => WindowOpenModeOptionBean.fromJson(e.toJson()))
        ?.toList();
    selector.subOpenModeOptions = subOpenModeOptions
        ?.map((e) => WindowOpenModeSubOption.fromJson(e.toJson()))
        ?.toList();
    return selector;
  }

  // 打开方式参数
  get openModeData {
    //当前打开方式的名称
    String name = curOpenMode?.name ?? '';
    // 如果是 分墙体打开
    if (curOpenMode?.index == 2) {
      return {name: subOpenModeData};
    }
    return [name];
  }

  // 打开方式子选项数据
  Map<String, dynamic> get subOpenModeData {
    Map<String, dynamic> data = {};
    for (WindowOpenModeSubOption option in subOpenModeOptions) {
      List<WindowOpenModeSubOptionBean> list = option?.options;
      WindowOpenModeSubOptionBean bean = list?.firstWhere(
          (element) => element.isChecked,
          orElse: () => list?.first);
      data['${option?.title}'] = bean?.name;
    }
    return data;
  }
}
