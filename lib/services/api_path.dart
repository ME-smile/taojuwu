class ApiPath {
  static const HOST = 'http://106.14.219.213:8001';

  static const String appInfo = '/api/Config/getAppUpgradeInfo';

  static const String productMall = '/api/goods/goodsListByConditions';

  static const String productDetail = '/api/goods/goodsDetail';

  static const String sms = '/api/login/sendRegisterMobileCode';

  static const String loginBySms = '/api/login/mobileLogin';

  static const String loginByPwd = '/api/login/login';

  static const String skuAttr = '/api/order/wcAttr';

  static const String userAdd = '/api/client/add';

  static const String userList = '/api/client/lists';

  static const String categoryUserList = '/api/client/lists_with_type';

  static const String customerDetail = '/api/client/info';

  static const String orderList = '/api/order/order';

  static const String orderDetail = '/api/order/orderDetail';

  static const String tag = '/api/order/tag';

  static const String tagList = '/api/goods/filtrateTag';

  static const String collect = '/api/member/addCollection';

  static const String cancelCollect = '/api/member/cancelCollection';

  static const String addCart = '/api/goods/addCart';

  static const String cartCategoryList = '/api/goods/cartCategoryList';

  static const String cartList = '/api/goods/cartList';

  static const String delCart = '/api/goods/deleteCart';

  static const String addAddress = '/api/member/addAddress';

  static const String editAddress = '/api/member/addAddress';

  static const String saveMesure = '/api/order/saveMeasure';

  static const String createOrder = '/api/order/orderCreate';

  static const String orderRemind = '/api/order/notice';

  static const String orderCancel = '/api/order/orderClose';

  static const String orderGoodsCancel = '/api/order/orderRefund';

  static const String createMeasureOrder = '/api/order/orderMeasureCreate';

  static const String getMeasureData = '/api/order/orderGoodsMeasureData';

  static const String selectProduct = '/api/order/addMeasureOrderGoods';

  static const String confirmToSelect = '/api/order/orderSelectedGoods';

  static const String editPrice = '/api/order/orderAdjustMoney';

  static const String scanQR = '/api/goods/scanqrcode';

  static const String uploadImg = '/api/upload/uploadImage';

  static const String afterSale = '/api/order/addOrderQuestion';

  static const String collectList = '/api/member/collection';

  static const String feedback = '/api/goods/addGoodsConsult';

  static const String resetPwd = '/api/member/modifyPassword';

  static const String windowStyle = '/api/order/wcCategory';

  static const String measureData = '/api/order/orderGoodsMeasureData';

  static const String mainfest = '/api/order/productList';

  static const String logistics = '/api/order/orderExpressList';

  static const String orderEditLog = '/api/order/getMeasureInstallRecords';

  static const String cartCount = '/api/goods/cartCount';

  static const String modifyCartAttr = '/api/goods/modifyCartAccessory';

  static const String associativeWords = '/api/goods/searchContent';

  static const String protocal = '/api/login/registerAgreement';

  static const String editCartCount = '/api/goods/modifyCartNum';
}
