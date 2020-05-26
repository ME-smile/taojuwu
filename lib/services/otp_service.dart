import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:taojuwu/models/order/measure_data_model.dart';

import 'package:taojuwu/models/order/order_detail_model.dart';
import 'package:taojuwu/models/order/order_model.dart';
import 'package:taojuwu/models/shop/cart_list_model.dart';
import 'package:taojuwu/models/shop/collect_list_model.dart';
import 'package:taojuwu/models/shop/curtain_product_list_model.dart';
import 'package:taojuwu/models/shop/product_bean.dart';
import 'package:taojuwu/models/shop/product_tag_model.dart';
import 'package:taojuwu/models/shop/sku_attr/accessory_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/canopy_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/craft_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/part_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/room_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_gauze_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_pattern_attr.dart';
import 'package:taojuwu/models/shop/sku_attr/window_shade_attr.dart';
import 'package:taojuwu/models/user/category_customer_model.dart';
import 'package:taojuwu/models/user/customer_detail_model.dart';
import 'package:taojuwu/models/user/customer_model.dart';
import 'package:taojuwu/models/zy_response.dart';
import 'package:taojuwu/services/api_path.dart';
import 'package:taojuwu/utils/common_kit.dart';

import 'base/xhr.dart';

class OTPService {
  static Xhr xhr = Xhr.instance;
  static Future<CurtainProductListResp> curtainGoodsList(BuildContext context,
      {Map<String, dynamic> params}) async {
    Response response =
        await xhr.get(context, ApiPath.curtainMall, params: params ?? {});
    return CurtainProductListResp.fromMap(response.data);
  }

  static Future<TagListResp> tagList(BuildContext context,
      {Map<String, dynamic> params}) async {
    Response response = await xhr.get(context, ApiPath.tag, params: params);
    return TagListResp.fromMap(response.data);
  }

  static Future mallData(BuildContext context,
      {Map<String, dynamic> params}) async {
    List<Future> list = [
      curtainGoodsList(context, params: params),
      tagList(context),
    ];

    list.forEach((v) {
      v.catchError((err) => err);
    });
    List result = await Future.wait(list);
    return result;
  }

  //goods_id
  static Future<WindowGauzeAttr> windowGauzeAttr(BuildContext context,
      {Map<String, dynamic> params}) async {
    params = params ?? {};
    params.addAll({
      'type': 3,
    });
    Response response = await xhr.get(context, ApiPath.skuAttr, params: params);

    return WindowGauzeAttr.fromJson(response.data);
  }

  //goods_id
  static Future<RoomAttr> roomAttr(BuildContext context,
      {Map<String, dynamic> params}) async {
    params = params ?? {};
    params.addAll({
      'type': 1,
    });
    Response response = await xhr.get(context, ApiPath.skuAttr, params: params);

    return RoomAttr.fromJson(response.data);
  }

  //goods_id
  static Future<CraftAttr> craftAttr(BuildContext context,
      {Map<String, dynamic> params}) async {
    params = params ?? {};
    params.addAll({
      'type': 4,
    });
    Response response = await xhr.get(context, ApiPath.skuAttr, params: params);

    return CraftAttr.fromJson(response.data);
  }

  //goods_id
  static Future windowPatternAttr(BuildContext context,
      {Map<String, dynamic> params}) async {
    params = params ?? {};
    params.addAll({
      'type': 2,
    });
    Response response = await xhr.get(context, ApiPath.skuAttr, params: params);
    if (response.data != null &&
        response.data['data'] != null &&
        response.data['data'].isNotEmpty) {
      response.data['data'].forEach((item) {
        WindowPatternAttr.patternIdMap[item['name']] = item['id'];
      });
    }
    return;
  }

  //goods_id
  static Future<PartAttr> partAttr(BuildContext context,
      {Map<String, dynamic> params}) async {
    params = params ?? {};
    params.addAll({
      'type': 5,
    });
    Response response = await xhr.get(context, ApiPath.skuAttr, params: params);

    return PartAttr.fromJson(response.data);
  }

  //goods_id
  static Future<WindowShadeAttr> windowShadeAttr(BuildContext context,
      {Map<String, dynamic> params}) async {
    params = params ?? {};
    params.addAll({
      'type': 12,
    });
    Response response = await xhr.get(context, ApiPath.skuAttr, params: params);

    return WindowShadeAttr.fromJson(response.data);
  }

  //goods_id
  static Future<CanopyAttr> canopyAttr(BuildContext context,
      {Map<String, dynamic> params}) async {
    params = params ?? {};
    params.addAll({
      'type': 8,
    });
    Response response = await xhr.get(context, ApiPath.skuAttr, params: params);
    return CanopyAttr.fromJson(response.data);
  }

  static Future<AccessoryAttr> accessoryAttr(BuildContext context,
      {Map<String, dynamic> params}) async {
    params = params ?? {};
    params.addAll({
      'type': 13,
    });
    Response response = await xhr.get(context, ApiPath.skuAttr, params: params);

    return AccessoryAttr.fromJson(response.data);
  }

  static Future<ProductBeanRes> curtainProductDetail(BuildContext context,
      {Map<String, dynamic> params}) async {
    Response response =
        await xhr.get(context, ApiPath.curtainDetail, params: params ?? {});
    return ProductBeanRes.fromJson(response.data);
  }

  static Future<ZYResponse> getSms(
      BuildContext context, Map<String, String> params) async {
    Response response =
        await xhr.get(context, ApiPath.sms, params: params ?? {});

    return ZYResponse.fromJson(response.data);
  }

  static Future<ZYResponse> loginBySms(
      BuildContext context, Map<String, String> params) async {
    Response response =
        await xhr.get(context, ApiPath.loginBySms, params: params ?? {});

    return ZYResponse.fromJson(response.data);
  }

  static Future<ZYResponse> loginByPwd(
      BuildContext context, Map<String, String> params) async {
    Response response = await xhr.post(
      ApiPath.loginByPwd,
      data: params ?? {},
    );
    ZYResponse resp = ZYResponse.fromJsonWithData(response.data);
    if (resp?.valid == true) {
      CommonKit.showSuccessDIYInfo('登录成功');
    } else {
      CommonKit.showErrorInfo('账号或密码错误');
    }
    return resp;
  }

  static Future fetchCurtainDetailData(BuildContext context,
      {Map<String, dynamic> params}) async {
    params = params ?? {};
    List<Future> list = [
      curtainProductDetail(context, params: params),
      windowGauzeAttr(context, params: params),
      craftAttr(context, params: params),
      partAttr(context, params: params),
      windowShadeAttr(context, params: params),
      canopyAttr(context, params: params),
      accessoryAttr(context, params: params),
      roomAttr(context, params: params),
    ];

    list.forEach((v) {
      v.catchError((err) => err);
    });
    List result = await Future.wait(list);
    return result;
  }

  static Future<ZYResponse> addUser(Map<String, dynamic> params) async {
    Response response = await xhr.post(ApiPath.userAdd, data: params ?? {});
    return ZYResponse.fromJsonWithData(response.data);
  }

  static Future<CustomerModelListResp> userList(BuildContext context,
      {Map<String, dynamic> params}) async {
    Response response =
        await xhr.get(context, ApiPath.userList, params: params);

    return CustomerModelListResp.fromMap(response.data);
  }

  static Future<CategoryCustomerModelListResp> categoryUserList(
      BuildContext context,
      {Map<String, dynamic> params}) async {
    Response response =
        await xhr.get(context, ApiPath.categoryUserList, params: params);

    return CategoryCustomerModelListResp.fromMap(response.data);
  }

  static Future<CustomerDetailModelResp> customerDetail(BuildContext context,
      {Map<String, dynamic> params}) async {
    Response response =
        await xhr.get(context, ApiPath.customerDetail, params: params);
    return CustomerDetailModelResp.fromMap(response.data);
  }

  static Future<OrderModelListResp> orderList(BuildContext context,
      {Map<String, dynamic> params}) async {
    Response response =
        await xhr.get(context, ApiPath.orderList, params: params);
    return OrderModelListResp.fromMap(response.data);
  }

  static Future<OrderDerailModelResp> orderDetail(BuildContext context,
      {Map<String, dynamic> params}) async {
    Response response =
        await xhr.get(context, ApiPath.orderDetail, params: params);
    return OrderDerailModelResp.fromMap(response.data);
  }

  static Future<ZYResponse> collect({Map<String, dynamic> params}) async {
    Response response = await xhr.post(ApiPath.collect, data: params);
    return ZYResponse.fromJson(response.data);
  }

  static Future<CollectListResp> collectList(BuildContext context,
      {Map<String, dynamic> params}) async {
    Response response =
        await xhr.get(context, ApiPath.collectList, params: params);
    return CollectListResp.fromJson(response.data);
  }

  static Future<ZYResponse> cancelCollect({Map<String, dynamic> params}) async {
    Response response = await xhr.post(ApiPath.cancelCollect, data: params);
    ZYResponse resp = ZYResponse.fromJson(response.data);
    return resp;
  }

  static Future<ZYResponse> addCart({Map<String, dynamic> params}) async {
    Response response = await xhr.post(
      ApiPath.addCart,
      data: params,
    );
    ZYResponse resp = ZYResponse.fromJson(response.data);
    if (resp?.valid == true) {
      CommonKit.showSuccessDIYInfo('加入购物车成功');
    } else {
      CommonKit.showErrorInfo(resp?.message);
    }
    return resp;
  }

  static Future<CartListResp> cartList(BuildContext context,
      {Map<String, dynamic> params}) async {
    Response response =
        await xhr.get(context, ApiPath.cartList, params: params);

    return CartListResp.fromJson(response.data);
  }

  static Future<ZYResponse> delCart({Map<String, dynamic> params}) async {
    Response response = await xhr.post(
      ApiPath.delCart,
      data: params,
    );

    return ZYResponse.fromJson(response.data);
  }

  static Future<ZYResponse> editAddress(BuildContext context,
      {Map<String, dynamic> params}) async {
    bool flag = params['id'].isNotEmpty;
    Response response = await xhr.get(
        context, flag ? ApiPath.editAddress : ApiPath.addAddress,
        params: params);

    return ZYResponse.fromJsonWithData(response.data);
  }

  static Future<ZYResponse<dynamic>> saveMeasure(BuildContext context,
      {Map<String, dynamic> params}) async {
    Response response =
        await xhr.get(context, ApiPath.saveMesure, params: params);
    ZYResponse<dynamic> resp =
        ZYResponse<dynamic>.fromJsonWithData(response.data);
    if (resp?.valid == false) {
      CommonKit.showErrorInfo(resp?.message ?? '');
    }
    return resp;
  }

  static Future<ZYResponse<dynamic>> createOrder(
      {Map<String, dynamic> params}) async {
    Response response = await xhr.post(ApiPath.createOrder, formdata: params);
    ZYResponse<dynamic> resp =
        ZYResponse<dynamic>.fromJsonWithData(response.data);
    if (resp?.valid != true) {
      CommonKit.showErrorInfo(resp?.message ?? '');
    }
    return resp;
  }

  static Future<ZYResponse<dynamic>> orderRemind(
      {Map<String, dynamic> params}) async {
    Response response = await xhr.post(
      ApiPath.orderRemind,
      formdata: params,
    );
    ZYResponse resp = ZYResponse<dynamic>.fromJsonWithData(response.data);
    if (resp?.valid == true) {
      CommonKit.showSuccessDIYInfo('提交成功');
    } else {
      CommonKit.showErrorInfo(resp?.message);
    }
    return ZYResponse<dynamic>.fromJsonWithData(response.data);
  }

  static Future<ZYResponse<dynamic>> orderCancel(
      {Map<String, dynamic> params}) async {
    Response response = await xhr.post(
      ApiPath.orderCancel,
      formdata: params,
    );

    return ZYResponse<dynamic>.fromJsonWithData(response.data);
  }

  static Future<ZYResponse<dynamic>> orderGoodsCancel(
      {Map<String, dynamic> params}) async {
    Response response = await xhr.post(
      ApiPath.orderGoodsCancel,
      data: params,
    );
    ZYResponse<dynamic> resp =
        ZYResponse<dynamic>.fromJsonWithData(response.data);
    if (resp?.valid == true) {
      CommonKit.showSuccessDIYInfo('取消成功');
    } else {
      CommonKit.showErrorInfo(resp?.message);
    }
    return resp;
  }

  static Future<ZYResponse<dynamic>> createMeasureOrder(
      {Map<String, dynamic> params}) async {
    Response response =
        await xhr.post(ApiPath.createMeasureOrder, formdata: params);
    return ZYResponse<dynamic>.fromJsonWithData(response.data);
  }

  static Future<MeasureDataModelResp> getMeasureData(
      {Map<String, dynamic> params}) async {
    Response response =
        await xhr.post(ApiPath.getMeasureData, formdata: params);
    return MeasureDataModelResp.fromJson(response.data);
  }

  static Future<ZYResponse<dynamic>> selectProduct(
      {Map<String, dynamic> params}) async {
    Response response = await xhr.post(ApiPath.selectProduct, formdata: params);
    return ZYResponse<dynamic>.fromJsonWithData(response.data);
  }

  static Future<ZYResponse<dynamic>> confirmToSelect(
      {Map<String, dynamic> params}) async {
    Response response = await xhr.post(ApiPath.confirmToSelect, data: params);
    return ZYResponse<dynamic>.fromJsonWithData(response.data);
  }

  static Future<ZYResponse<dynamic>> editPrice(
      {Map<String, dynamic> params}) async {
    Response response = await xhr.post(ApiPath.editPrice, data: params);
    return ZYResponse<dynamic>.fromJsonWithData(response.data);
  }

  static Future<ZYResponse<dynamic>> scanQR(
      {Map<String, dynamic> params}) async {
    Response response = await xhr.post(ApiPath.scanQR, data: params);
    return ZYResponse<dynamic>.fromJsonWithData(response.data);
  }

  static Future<ZYResponse<dynamic>> uploadImg(
      {Map<String, dynamic> params}) async {
    Response response = await xhr.post(ApiPath.uploadImg,
        data: params,
        options: Options(
            headers: {'Content-Type': 'application/x-www-form-urlencoded'}));
    return ZYResponse<dynamic>.fromJsonWithData(response.data);
  }

  static Future<ZYResponse<dynamic>> afterSale(
      {Map<String, dynamic> params}) async {
    Response response = await xhr.post(
      ApiPath.afterSale,
      data: params,
    );
    return ZYResponse<dynamic>.fromJsonWithData(response.data);
  }

  static Future commitAfterSaleDesc(BuildContext context,
      {Map<String, dynamic> params}) async {
    List<Future> list = [uploadImg(params: params), afterSale(params: params)];

    list.forEach((v) {
      v.catchError((err) => err);
    });
    List result = await Future.wait(list);
    return result;
  }

  static Future<ZYResponse<dynamic>> feedback(
      {Map<String, dynamic> params}) async {
    Response response = await xhr.post(ApiPath.feedback, data: params);
    return ZYResponse<dynamic>.fromJsonWithData(response.data);
  }

  static Future<ZYResponse<dynamic>> resetPwd(
      {Map<String, dynamic> params}) async {
    Response response = await xhr.post(ApiPath.resetPwd, data: params);
    return ZYResponse<dynamic>.fromJsonWithData(response.data);
  }

  static Future<OrderGoodsMeasure> measureData(context,
      {Map<String, dynamic> params}) async {
    Response response =
        await xhr.get(context, ApiPath.measureData, params: params);
    return OrderGoodsMeasure.fromJson(response.data);
  }

  // static
}
