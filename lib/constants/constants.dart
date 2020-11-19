class Constants {
  static const HOST = "http://106.14.219.213:8001";
  static const TRANSITION_DURATION = Duration(milliseconds: 300);
  //订单状态

  //order_status 订单状态 1待审核 2待测量 3待付款 4付款待审核 5生产中 6等待预约安装 7待安装 8已完成 9已取消 10售后维权 11售后维权已处理 12售后维权已关闭 -1退款中 13订单自动完成 14待选品' 15取消待审核
  static const String ORDER_STATUS_ALL = '全部';
  static const String ORDER_STATUS_ING = '进行中';
  static const String ORDER_STATUS_TO_AUDIT = '待审核';
  static const String ORDER_STATUS_TO_MEASURE = '待测量';
  static const String ORDER_STATUS_TO_SELECT = '待选品';
  static const String ORDER_STATUS_PAY_TAIL = '待付款';
  static const String ORDER_STATUS_PRODUCTING = '生产中';

  static const String ORDER_STATUS_TO_SHIP = '待发货';
  static const String ORDER_STATUS_TO_RECEIVE = '待收货';
  static const String ORDER_STATUS_TO_INSTALL = '待安装';
  static const String ORDER_STATUS_FINISHED = '已完成';
  static const String ORDER_STATUS_CANCELED = '已取消';
  static const String ORDER_STATUS_PRODUCTED = '生产完成';

  static const String ORDER_STATUS_PAIED_TO_AUDIT = '付尾款待审核';
  static const String ORDER_STATUS_TO_SCHEDULE_INSTALL = '等待预约安装';

  static const String ORDER_STATUS_TO_PAY = '待付款';

  static const String ORDER_STATUS_WAIT_TO_REFUND = '退款申请';

  static const ORDER_STATUS_TO_SELECT_CODE = 14;

  static const Map ORDER_STATUS_TAB_MAP = {
    '': ORDER_STATUS_ALL,
    '1': ORDER_STATUS_TO_AUDIT,
    '2': ORDER_STATUS_TO_MEASURE,
    '3': ORDER_STATUS_TO_SELECT,
    '4': ORDER_STATUS_PAY_TAIL,
    '5': ORDER_STATUS_PRODUCTING,
    '6': ORDER_STATUS_TO_INSTALL,
    '7': ORDER_STATUS_FINISHED,
  };

  static const List<String> ORDER_STATUS_TAB_LIST = [
    ORDER_STATUS_ING,
    ORDER_STATUS_TO_AUDIT,
    ORDER_STATUS_TO_MEASURE,
    ORDER_STATUS_TO_SELECT,
    ORDER_STATUS_PAY_TAIL,
    ORDER_STATUS_PRODUCTING,
    ORDER_STATUS_TO_SHIP,
    ORDER_STATUS_TO_RECEIVE,
    ORDER_STATUS_TO_INSTALL,
    ORDER_STATUS_FINISHED,
    ORDER_STATUS_CANCELED,
    ORDER_STATUS_ALL
  ];
  static const Map ORDER_STATUS_MAP = {
    '': ORDER_STATUS_ALL,
    '1': ORDER_STATUS_ALL,
    '2': ORDER_STATUS_TO_AUDIT,
    '3': ORDER_STATUS_TO_MEASURE,
    '4': ORDER_STATUS_TO_SELECT,
    '5': ORDER_STATUS_PAY_TAIL,
    '6': ORDER_STATUS_PRODUCTING,
    '7': ORDER_STATUS_TO_INSTALL,
    '8': ORDER_STATUS_FINISHED,
  };

  static const Map ORDER_STATUS_BUTTON_ACTION = {
    0: {
      'show_button': false,
    },
    1: {'show_button': true, 'button_text': '提醒审核'},
    2: {'show_button': true, 'button_text': '提醒测量'},
    3: {'show_button': false},
    4: {'show_button': false},
    5: {'show_button': false},
    6: {'show_button': true, 'button_text': '提醒安装'},
    7: {'show_button': true, 'button_text': '售后维权'},
    8: {'show_button': true, 'button_text': '售后维权'},
    9: {'show_button': true, 'button_text': '提醒审核'},
    14: {'show_button': true, 'button_text': '去选品'}
  };

  static const Map<int, Map<String, String>> ORDER_STATUS_TIP_MAP = {
    -1: {'title': '退款申请已提交', 'subtitle': '等待审核'},
    0: {'title': '', 'subtitle': ''},
    1: {
      'title': '订单已提交',
      'subtitle': '等待审核',
    },
    2: {
      'title': '订单已审核',
      'subtitle': '等待测量人员上门测量',
    },
    3: {
      'title': '测量完成',
      'subtitle': '等待客户支付尾款',
    },

    4: {
      'title': '订单已付尾款',
      'subtitle': '等待审核',
    },

    // ORDER_STATUS_TO_PAY: {
    //   'title': '测量完成',
    //   'subtitle': '等待客户支付尾款',
    // },
    // ORDER_STATUS_PAIED_TO_AUDIT: {
    //   'title': '订单已付尾款',
    //   'subtitle': '等待审核',
    // },
    5: {
      'title': '审核完成',
      'subtitle': '商品正在工厂生产中',
    },
    6: {
      'title': '商品已准备完毕',
      'subtitle': '待发货',
    },
    7: {
      'title': '已发货',
      'subtitle': '预约安装时间',
    },
    8: {'title': '交易成功', 'subtitle': ''},
    9: {'title': '已取消', 'subtitle': ''},
    10: {'title': '售后问题已提交', 'subtitle': '我们将尽快为您解决'},
    11: {'title': '交易完成', 'subtitle': '售后问题已处理'},
    14: {'title': '已完成测量', 'subtitle': '请根据房型选择商品'},
    15: {'title': '订单已发货', 'subtitle': ''},
    // ORDER_STATUS_PRODUCTED: {'title': '交易成功', 'subtitle': ''},
  };

  static const Map<dynamic, String> GENDER_MAP = {
    '0': '未知',
    '1': '男',
    '2': '女',
    0: '未知',
    1: '男',
    2: '女'
  };

  static const Map<int, String> CUSTOMER_TYPE_MAP = {
    0: '初谈客户',
    1: '意向客户',
    2: '跟进客户',
    3: '成交客户'
  };

  static const Map<int, String> ATTR_MAP = {
    1: '空间',
    2: '窗型',
    3: '窗纱',
    4: '工艺',
    5: '型材',
    6: '帘身款式',
    7: '帘身面料',
    8: '幔头',
    9: '尺寸',
    12: '里布',
    13: '配饰'
  };

  static const Map<String, int> ATTR2NUM_MAP = {
    '空间': 1,
    '窗型': 2,
    '窗纱面料': 3,
    '工艺': 4,
    '配件': 5,
    '帘身款式': 6,
    '帘身面料': 7,
    '馒头': 8,
    '尺寸': 9,
    '遮光里布': 12,
    '配饰': 13
  };

  static const SERVER_PROMISE = '''
  服务承诺:
  (1)未量尺前支持7天无理由退货换货；量尺后，取消订单则需承担套餐金额的违约金，具体已门店为准（若超服务范围需含远途路费，作为上门测量所产生的全部费用）；下单生产后，取消订单则需承担量尺、产品等费用。 
  (2)24小时售后响应制，2个工作日给予解决方案，最终以用户确认满意评价。 
  (3)客户满足测量条件（硬装结束，地板及门框安装完毕）预约测量；正式选品下单后，20天左右生产完成。
  ''';
  static const String ALERT_TIP_HADE = "为了更好的提供服务，我们依据相关法律制作了";
  static const String ALERT_TIP_BODY = "《用户协议与隐私政策》";
  static const String ALERT_TIP_TAIL =
      """帮助您了解、使用、存储和共享个人信息的情况，我们会根据您使用服务的具体功能需要，收集必要的用户信息（可能涉及账户、交易、设备等相关信息）。\n
未经您同意，我们不会从第三方获取、共享或对外提供您的信息。如您对指引内容有任何疑问、意向或者建议，欢迎随时联系我们。\n
[特别提示]当您点击「同意」即代表您已充分阅读、理解并接受淘居屋商家的《用户协议与隐私政策》的全部内容。
  
  """;
}
