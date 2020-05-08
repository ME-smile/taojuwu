class WindowPatternAttr {
  static const patternsText = ['单窗', 'L型窗', 'U型窗'];
  static const stylesText = ['非飘窗', '飘窗'];
  static const typesText = ['无盒', '有盒'];

  static const installModes = ['顶装', '侧装'];
  static const openModes = ['整体对开', '整体单开'];

  static const installModesPic = {
    '顶装': 'curtain/size_000011.png',
    '侧装': 'curtain/size_000001.png'
  };

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

  static Map<String, dynamic> patternMap={};
  
  
  
}
