import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/export/export_pages.dart';
import 'package:taojuwu/pages/after_sale_service/after_sale_service_page.dart';

import 'package:taojuwu/pages/cart/cart_page.dart';
import 'package:taojuwu/pages/collect/collect_page.dart';
import 'package:taojuwu/pages/goods/curtain/subPages/edit_goods_attr_page.dart';
import 'package:taojuwu/pages/goods/curtain/curtain_detail_page.dart';
import 'package:taojuwu/pages/goods/curtain/curtain_mall_page.dart';
import 'package:taojuwu/pages/goods/curtain/subPages/edit_open_mode_page.dart';
import 'package:taojuwu/pages/goods/curtain/subPages/measure_data_preview_page.dart';
import 'package:taojuwu/pages/goods/curtain/subPages/pre_measure_data_page.dart';
import 'package:taojuwu/pages/customer/customer_detail_page.dart';
import 'package:taojuwu/pages/customer/customer_edit_page.dart';
import 'package:taojuwu/pages/customer/customer_manage_page.dart';
import 'package:taojuwu/pages/customer/customer_table_page.dart';
import 'package:taojuwu/pages/customer/subPages/customer_search_page.dart';

import 'package:taojuwu/pages/data_center/data_center_page.dart';
import 'package:taojuwu/pages/edit_address/edit_address_page.dart';
import 'package:taojuwu/pages/goods/end_product/end_product_detail.dart';
import 'package:taojuwu/pages/login/login_page.dart';
import 'package:taojuwu/pages/logistics/logistics_page.dart';
import 'package:taojuwu/pages/order/commit_order_page.dart';
import 'package:taojuwu/pages/order/measure_order_page.dart';
import 'package:taojuwu/pages/order/order_detail_page.dart';

import 'package:taojuwu/pages/order/order_page.dart';
import 'package:taojuwu/pages/order/subPages/order_commit_success_page.dart';
import 'package:taojuwu/pages/order/subPages/order_edit_log_page.dart';
import 'package:taojuwu/pages/order/subPages/order_mainfest_page.dart';
import 'package:taojuwu/pages/order/subPages/order_search_page.dart';
import 'package:taojuwu/pages/profile/profile_page.dart';
import 'package:taojuwu/pages/profile/subPages/forget_pwd_page.dart';
import 'package:taojuwu/pages/profile/subPages/reset_pwd_page.dart';
import 'package:taojuwu/pages/profile/subPages/submit_success_page.dart';
import 'package:taojuwu/pages/profile/subPages/switch_account_page.dart';
import 'package:taojuwu/pages/profile/subPages/feedback_page.dart';
import 'package:taojuwu/pages/profile/subPages/version_page.dart';
import 'package:taojuwu/pages/protocal/protocal.dart';
import 'package:taojuwu/pages/refund/refund_page.dart';
import 'package:taojuwu/pages/search/search_page.dart';
import 'package:taojuwu/pages/splash/splash_page.dart';

import 'package:taojuwu/singleton/target_route.dart';
import 'package:taojuwu/utils/common_kit.dart';
import 'routes.dart';

class RouteHandler {
  static Future _jumpTo(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      bool maintainState = false,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    return Application.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        maintainState: maintainState,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder,
        transition: TransitionType.cupertino);
  }

  static Handler splash = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return SplashPage();
  });

  static Handler home = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return HomePage();
  });
  static Future goHomePage(BuildContext context, {bool clearStack: true}) {
    return _jumpTo(context, Routes.home, clearStack: clearStack);
  }

  static Handler protocal = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return UserProtocalPage();
  });
  static Future goProtocalPage(
    BuildContext context,
  ) {
    return _jumpTo(
      context,
      Routes.protocal,
    );
  }

  static Handler login = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return LoginPage();
  });

  static Future goLoginPage(BuildContext context,
      {bool replace: false, bool clearStack: false}) {
    return _jumpTo(context, Routes.login,
        replace: replace, clearStack: clearStack);
  }

  static Handler curtain = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    // return CurtainPage();
    return;
  });

  static Handler curtainDetail = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int goodsId = int.parse(params['id']?.first);
    return CurtainDetailPage(
      goodsId,
    );
  });

  static Future goCurtainDetailPage(BuildContext context, int id,
      {bool replace: false}) {
    return _jumpTo(context, '${Routes.curtainDetail}?id=$id',
        maintainState: true, replace: replace);
  }

  static Handler order = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int clientId;
    String arg = params['clientId']?.first;
    if (arg != null && arg != 'null') {
      clientId = int.parse(arg);
    }
    return OrderPage(
      clientId: clientId,
    );
  });

  static Future goOrderPage(
    BuildContext context, {
    int clientId,
  }) {
    return _jumpTo(context, '${Routes.order}?clientId=$clientId',
        maintainState: true);
  }

  static Handler orderDetail = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int id = int.parse(params['id']?.first);
    // int tab = int.parse(params['tab']?.first);
    return OrderDetailPage(
      id: id,
    );
  });

  static Future goOrderDetailPage(BuildContext context, int id,
      {bool isReplaceMode: false}) {
    return _jumpTo(context, '${Routes.orderDetail}?id=$id',
        replace: isReplaceMode, maintainState: true);
  }

  static Handler measureOrder = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return MeasureOrderPage();
  });

  static Future goMeasureOrderPage(BuildContext context) {
    return _jumpTo(context, Routes.measureOrder, maintainState: true);
  }

  static Handler customer = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int flag = int.parse(params['flag']?.first);

    return CustomerManagePage(
      flag: flag,
    );
  });
  static Future goCustomerPage(BuildContext context,
      {int isForSelectedClient: 0 //1代表选择客户 0 //普通跳转
      }) {
    return _jumpTo(context, '${Routes.customer}?flag=$isForSelectedClient',
        maintainState: false);
  }

  static Handler customerDetail = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int id = int.parse(params['id']?.first);
    return CustomerDetailPage(id);
  });
  static Future goCustomerDetailPage(BuildContext context, int id) {
    return _jumpTo(context, '${Routes.customerDetail}?id=$id');
  }

  static Handler customerEdit = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    String title =
        FluroConvertUtils.fluroCnParamsDecode(params['title']?.first);
    int id =
        params['id']?.first != 'null' ? int.parse(params['id']?.first) : null;
    return CustomerEditPage(
      title: title,
      id: id,
    );
  });
  static Future goCustomerEditPage(
    BuildContext context, {
    String title,
    int id,
  }) {
    title =
        title != null ? FluroConvertUtils.fluroCnParamsEncode(title) : title;
    return _jumpTo(
      context,
      '${Routes.customerEdit}?title=$title&id=$id',
    );
  }

  static Handler customerTable = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int type = int.parse(params['type']?.first);
    int flag = int.parse(params['flag']?.first);
    return CustomerTablePage(
      type: type,
      flag: flag,
    );
  });
  static Future goCustomerTablePage(BuildContext context, int type,
      {int flag: 0, bool replace: true}) {
    return _jumpTo(context, '${Routes.customerTable}?type=$type&flag=$flag',
        replace: replace);
  }

  static Handler dataCenter = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return DataCenterPage();
  });

  static Future goDataCenterPage(BuildContext context) {
    return _jumpTo(context, Routes.dataCenter);
  }

  static Handler combo = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    // return ComboPage();
    return;
  });

  static Future goComboPage(BuildContext context) {
    return _jumpTo(context, Routes.combo);
  }

  static Handler setting = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    // return SettingPage();
    return;
  });

  static Future goSettingPage(BuildContext context) {
    return _jumpTo(context, Routes.setting);
  }

  static Handler profile = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return ProfilePage();
    // return;
  });

  static Future goProfilePage(BuildContext context) {
    return _jumpTo(context, Routes.profile);
  }

  static Handler curtainMall = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    String keyword =
        FluroConvertUtils.fluroCnParamsDecode(params['keyword']?.first);
    return CurtainMallPage(
      keyword: keyword,
    );
    // return;
  });

  static Future goCurtainMallPage(BuildContext context,
      {String keyword: '', bool replace: false}) {
    keyword = FluroConvertUtils.fluroCnParamsEncode(keyword);
    TargetRoute.instance.setRoute('${Routes.curtainMall}?keyword=$keyword');
    return _jumpTo(context, '${Routes.curtainMall}?keyword=$keyword',
        maintainState: true, replace: replace);
  }

  static Handler switchAccount = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return SwitchAccountPage();
    // return;
  });

  static Future goSwitchAccountPage(BuildContext context) {
    return _jumpTo(context, Routes.switchAccount);
  }

  static Handler feedback = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return FeedbackPage();
    // return;
  });

  static Future goFeedbackPage(BuildContext context) {
    return _jumpTo(context, Routes.feedback);
  }

  static Handler commitSuccess = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return CommitSuccessPage();
    // return;
  });

  static Future goCommitSuccessPage(BuildContext context) {
    return _jumpTo(context, Routes.commitSuccess);
  }

  static Handler editAddress = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int id = int.parse(params['id']?.first ?? '-1') ?? -1;
    return EditAddressPage(
      id: id,
    );
  });

  static Future goEditAddressPage(BuildContext context, {int id}) {
    return _jumpTo(
      context,
      '${Routes.editAddress}?id=$id',
    );
  }

  static Handler search = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int type = int.parse(params['type']?.first);
    return SearchPage(
      type: type,
    );
  });

  static Future goSearchPage(BuildContext context, int type) {
    return _jumpTo(context, '${Routes.search}?type=$type', maintainState: true);
  }

  static Handler preMeasureData = Handler(handlerFunc: (
    BuildContext context,
    Map<String, List<Object>> params,
  ) {
    return PreMeasureDataPage();
  });

  static Future goPreMeasureDataPage(BuildContext context) {
    return _jumpTo(context, Routes.preMeasureData);
  }

  static Handler cart = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int clientId = int.parse(params['clientId']?.first);
    return CartPage(
      clientId: clientId,
    );
  });

  static Future goCartPage(BuildContext context, {int clientId: -1}) {
    return _jumpTo(context, '${Routes.cart}?clientId=$clientId',
        maintainState: true);
  }

  static Handler commitOrder = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    String args = params['params']?.first;
    args = FluroConvertUtils.fluroCnParamsDecode(args);

    Map json = Map.castFrom(jsonDecode(args));
    return CommitOrderPage(params: json);
  });

  static Future goCommitOrderPage(BuildContext context, {String params}) {
    params =
        params != null ? FluroConvertUtils.fluroCnParamsEncode(params) : '';

    return _jumpTo(context, '${Routes.commitOrder}?params=$params',
        maintainState: true);
  }

  static Handler orderCommitSuccess = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int clientId = int.parse(params['clientId']?.first) ?? -1;
    int orderType = int.parse(params['orderType']?.first) ?? -1;
    return OrderCommitSuccessPage(
      clientId: clientId,
      orderType: orderType,
    );
  });

  static Future goOrderCommitSuccessPage(BuildContext context, String clientId,
      {int orderType: 1}) {
    return _jumpTo(context,
        '${Routes.orderCommitSuccess}?clientId=$clientId&orderType=$orderType');
  }

  static Handler orderSearch = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    String keyword =
        FluroConvertUtils.fluroCnParamsDecode(params['keyword']?.first);
    return OrderSearchPage(
      keyword: keyword,
    );
  });

  static Future goOrderSearchPage(BuildContext context, {String keyword: ''}) {
    keyword = FluroConvertUtils.fluroCnParamsEncode(keyword);
    return _jumpTo(context, '${Routes.orderSearch}?keyword=$keyword');
  }

  static Handler customerSearch = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    String keyword =
        FluroConvertUtils.fluroCnParamsDecode(params['keyword']?.first);
    return CustomerSearchPage(
      keyword: keyword,
    );
  });

  static Future goCustomerSearchPage(BuildContext context,
      {String keyword: ''}) {
    keyword = FluroConvertUtils.fluroCnParamsEncode(keyword);
    return _jumpTo(context, '${Routes.customerSearch}?keyword=$keyword');
  }

  static Handler afterSaleService = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return AfterSaleServicePage();
  });

  static Future goAfterSaleServicePage(BuildContext context) {
    return _jumpTo(context, Routes.afterSaleService);
  }

  static Handler measureDataPreview = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return MeasureDataPreviewPage();
  });

  static Future goMeasureDataPreviewPage(BuildContext context) {
    return _jumpTo(context, Routes.measureDataPreview, maintainState: true);
  }

  static Handler editOpenMode = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return EditOpenModePage();
  });

  static Future goEditOpenModePage(
    BuildContext context,
  ) {
    return _jumpTo(context, Routes.editOpenMode);
  }

  static Handler collectList = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int id = int.parse(params['id']?.first);
    String name = FluroConvertUtils.fluroCnParamsDecode(params['name']?.first);
    return CollectPage(
      id: id,
      name: name,
    );
  });

  static Future goCollectPage(BuildContext context,
      {int clientId: -1, String name: ''}) {
    name = FluroConvertUtils.fluroCnParamsEncode(name);
    return _jumpTo(context, '${Routes.collectList}?id=$clientId&name=$name');
  }

  static Handler resetPwd = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return ResetPwdPage();
  });

  static Future goResetPwdPage(
    BuildContext context,
  ) {
    return _jumpTo(context, Routes.resetPwd);
  }

  static Handler version = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return VersionPage();
  });

  static Future goVersionPage(
    BuildContext context,
  ) {
    return _jumpTo(context, Routes.version);
  }

  static Handler refund = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int id = int.parse(params['id']?.first);
    return RefundPage(id: id);
  });

  static Future goRefundPage(BuildContext context, int id) {
    return _jumpTo(context, '${Routes.refund}?id=$id');
  }

  static Handler forgetPwd = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    return ForgetPwdPage();
  });

  static Future goForgetPwdPage(
    BuildContext context,
  ) {
    return _jumpTo(context, Routes.forgetPwd);
  }

  static Future goOrderMainfestPage(BuildContext context, int id) {
    return _jumpTo(context, '${Routes.mainfest}?id=$id');
  }

  static Handler mainfest = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int id = int.parse(params['id']?.first);
    return OrderMainfestPage(id);
  });

  static Handler logistics = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int id = int.parse(params['id']?.first);
    return LogisticsPage(id);
  });
  static Future goLogisticsPage(BuildContext context, int id) {
    return _jumpTo(context, '${Routes.logistics}?id=$id');
  }

  static Handler orderEditLog = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int id = int.parse(params['id']?.first);
    int type = int.parse(params['type']?.first);
    return OrderEditLogPage(id: id, type: type);
  });
  static Future goOrderEditLogPage(BuildContext context, int id, int type) {
    return _jumpTo(context, '${Routes.orderEditLog}?id=$id&type=$type');
  }

  static Handler endProductDetail = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int id = int.parse(params['id']?.first);

    return EndProductDetailPage(id: id);
  });
  static Future goEndProductDetail(BuildContext context, int id) {
    return _jumpTo(context, '${Routes.endProductDetail}?id=$id',
        maintainState: true);
  }

  static Handler editGoodsAttr = Handler(
      handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    int goodId = int.parse(params['goodsId']?.first);
    int clientId = int.parse(params['clientId']?.first);
    int cartId = int.parse(params['cartId']?.first);
    String args = params['params']?.first;
    args = FluroConvertUtils.fluroCnParamsDecode(args);

    List json = jsonDecode(args);

    return EditGoodsAttrPage(
      goodsId: goodId,
      clientId: clientId,
      cartId: cartId,
      attrs: json,
    );
  });
  static Future goEditGoodsAttrPage(
    BuildContext context, {
    int goodsId,
    String params,
    int clientId,
    int cartId,
  }) {
    params =
        params != null ? FluroConvertUtils.fluroCnParamsEncode(params) : '';
    return _jumpTo(context,
        '${Routes.editGoodsAttr}?goodsId=$goodsId&params=$params&clientId=$clientId&cartId=$cartId');
  }
}
