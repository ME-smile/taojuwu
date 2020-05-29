class WindowPatternAttr {
  static const patternsText = ['单窗', 'L型窗', 'U型窗'];
  static const stylesText = ['非飘窗', '飘窗'];
  static const typesText = ['无盒', '有盒'];

  static const installModes = ['顶装', '侧装'];
  static const openModes = [''];
  static const installModeMap = {
    '顶装': 0,
    '顶装满墙': 0,
    '侧装': 1,
  };

  static const openModeMap = {'整体对开': 0, '整体单开': 1, '分墙体打开': 2};

  static const patterns = {
    'title': '样式',
    'options': [
      {
        'text': '单窗',
        'img': 'single_window_pattern.png',
      },
      {
        'text': 'L型窗',
        'img': 'L_window_pattern.png',
      },
      {
        'text': 'U型窗',
        'img': 'U_window_pattern.png',
      },
    ]
  };

  static const styles = {
    'title': '窗型选择',
    'options': [
      {
        'text': '非飘窗',
        'img': 'not_bay_window.png',
      },
      {
        'text': '飘窗',
        'img': 'bay_window.png',
      },
    ]
  };

  static const types = {
    'title': '窗帘盒',
    'options': [
      {
        'text': '无盒',
        'img': 'window_no_can.png',
      },
      {
        'text': '有盒',
        'img': 'window_with_can.png',
      },
    ]
  };

  static const pictureMap = {
    '单窗/非飘窗/无盒/顶装满墙': 'curtain/size_000011.png',
    '单窗/非飘窗/无盒/顶装': 'curtain/size_000011.png',
    '单窗/非飘窗/无盒/侧装': 'curtain/size_000001.png',
    '单窗/非飘窗/有盒/盒内装': 'curtain/size_0010-1-1.png',
    '单窗/飘窗/无盒/顶装满墙': 'curtain/size_0100-1-1-SPW-H.png',
    '单窗/飘窗/有盒/盒内装': 'curtain/size_0110-1-1-SPY-H.png',
    'L型窗/非飘窗/无盒/侧装': 'curtain/size_100000.png',
    'L型窗/非飘窗/无盒/顶装': 'curtain/size_100010.png',
    'L型窗/非飘窗/有盒/盒内装': 'curtain/size_1010-1-1.png',
    'L型窗/飘窗/无盒/顶装满墙': 'curtain/size_1100-1-1.png',
    'L型窗/飘窗/有盒/盒内装': 'curtain/size_0110-1-1-LPY-H.png',
    'U型窗/非飘窗/无盒/顶装': 'curtain/size_200010.png',
    'U型窗/非飘窗/无盒/侧装': 'curtain/size_200000.png',
    'U型窗/非飘窗/有盒/盒内装': 'curtain/size_2010-1-1.png',
    'U型窗/飘窗/无盒/顶装满墙': 'curtain/size_2100-1-1.png',
    'U型窗/飘窗/有盒/盒内装': 'curtain/size_2110-1-1.png',
  };

  static Map installOptionMap = {
    '单窗/非飘窗/无盒': [
      {
        'text': '顶装',
        'is_checked': true,
      },
      {
        'text': '侧装',
        'is_checked': false,
      }
    ],
    '单窗/非飘窗/有盒': [
      {
        'text': '盒内装',
        'is_checked': true,
      }
    ],
    '单窗/飘窗/无盒': [
      {
        'text': '顶装满墙',
        'is_checked': true,
      }
    ],
    '单窗/飘窗/有盒': [
      {
        'text': '盒内装',
        'is_checked': true,
      }
    ],
    'L型窗/非飘窗/无盒': [
      {
        'text': '顶装',
        'is_checked': true,
      },
      {
        'text': '侧装',
        'is_checked': false,
      }
    ],
    'L型窗/非飘窗/有盒': [
      {
        'text': '盒内装',
        'is_checked': true,
      }
    ],
    'L型窗/飘窗/无盒': [
      {
        'text': '顶装满墙',
        'is_checked': true,
      }
    ],
    'L型窗/飘窗/有盒': [
      {
        'text': '盒内装',
        'is_checked': true,
      }
    ],
    'U型窗/非飘窗/无盒': [
      {
        'text': '顶装',
        'is_checked': true,
      },
      {
        'text': '侧装',
        'is_checked': false,
      }
    ],
    'U型窗/非飘窗/有盒': [
      {
        'text': '盒内装',
        'is_checked': true,
      }
    ],
    'U型窗/飘窗/无盒': [
      {
        'text': '顶装满墙',
        'is_checked': true,
      }
    ],
    'U型窗/飘窗/有盒': [
      {
        'text': '盒内装',
        'is_checked': true,
      }
    ],
  };

  static Map openOptionMap = {
    '单窗': [
      {
        'text': '整体对开',
        'is_checked': true,
      },
      {
        'text': '整体单开',
        'is_checked': false,
      },
    ],
    'L型窗': [
      {
        'text': '整体对开',
        'is_checked': true,
      },
      {
        'text': '整体单开',
        'is_checked': false,
      },
      {
        'text': '分墙体打开',
        'is_checked': false,
      },
    ],
    'U型窗': [
      {
        'text': '整体对开',
        'is_checked': true,
      },
      {
        'text': '整体单开',
        'is_checked': false,
      },
      {
        'text': '分墙体打开',
        'is_checked': false,
      },
    ],
  };

  static Map openSubOptionMap = {
    '单窗/整体对开': [],
    '单窗/整体单开': [],
    'L型窗/整体对开': [],
    'L型窗/整体单开': [],
    'U型窗/整体对开': [],
    'U型窗/整体单开': [],
    'L型窗/分墙体打开': [
      {
        'name': 'A面打开方式',
        'options': [
          {'text': '单开', 'is_checked': true},
          {'text': '对开', 'is_checked': false}
        ]
      },
      {
        'name': 'B面打开方式',
        'options': [
          {'text': '单开', 'is_checked': true},
          {'text': '对开', 'is_checked': false}
        ]
      }
    ],
    'U型窗/分墙体打开': [
      {
        'name': 'A面打开方式',
        'options': [
          {'text': '单开', 'is_checked': true},
          {'text': '对开', 'is_checked': false}
        ]
      },
      {
        'name': 'B面打开方式',
        'options': [
          {'text': '单开', 'is_checked': true},
          {'text': '对开', 'is_checked': false}
        ]
      },
      {
        'name': 'C面打开方式',
        'options': [
          {'text': '单开', 'is_checked': true},
          {'text': '对开', 'is_checked': false}
        ]
      }
    ]
  };

  static reset() {
    installOptionMap.forEach((k, v) {
      List<Map> list = v;
      for (int i = 0; i < list?.length; i++) {
        Map item = list[i];
        item['is_checked'] = i == 0 ? true : false;
      }
    });

    openOptionMap.forEach((k, v) {
      List<Map> list = v;
      for (int i = 0; i < list?.length; i++) {
        Map item = list[i];
        item['is_checked'] = i == 0 ? true : false;
      }
    });
    openSubOptionMap.forEach((k, v) {
      List list = v;
      for (int i = 0; i < list?.length; i++) {
        Map item = list[i];
        List<Map> options = item['options'];
        for (int j = 0; j < options?.length; j++) {
          Map dict = options[j];
          dict['is_checked'] = j == 0 ? true : false;
        }
      }
    });
  }

  static Map<String, int> patternIdMap = {
    '单窗/飘窗/无盒': 13,
    'L型窗/飘窗/有盒': 14,
    'L型窗/非飘窗/有盒': 15,
    'U型窗/飘窗/有盒': 16,
    'U型窗/非飘窗/有盒': 17,
    'L型窗/非飘窗/无盒': 18,
    'L型窗/飘窗/无盒': 19,
    'U型窗/飘窗/无盒': 20,
    'U型窗/非飘窗/无盒': 21,
    '单窗/飘窗/有盒': 22,
    '单窗/非飘窗/有盒': 23,
    '单窗/非飘窗/无盒': 24,
  };
}
