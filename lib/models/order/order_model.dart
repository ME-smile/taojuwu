import 'dart:convert';

import 'package:taojuwu/models/zy_response.dart';

class OrderModelListResp extends ZYResponse<OrderModelDataWrapper> {
  OrderModelListResp.fromMap(Map<String, dynamic> json) : super.fromJson(json) {
    this.data =
        this.valid ? OrderModelDataWrapper.fromJson(json['data']) : null;
  }
}

class OrderModelDataWrapper {
  List<OrderModelData> data;
  int totalCount;
  int pageCount;
  Map statusNum;

  OrderModelDataWrapper.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<OrderModelData>();
      json['data'].forEach((v) {
        data.add(new OrderModelData.fromJson(v));
      });
    }
    totalCount = json['total_count'];
    pageCount = json['page_count'];

    statusNum = json['statusNum'];
  }
}

class OrderModelData {
  int orderId;
  String orderNo;
  int orderType;
  int orderStatus;
  String receiverName;
  int createTime;
  double orderEarnestMoney;
  double tailMoney;
  double orderEstimatedPrice;
  String orderWindowNum;
  int clientId;
  String measureTime;
  String installTime;
  String orderTypeName;
  String statusName;
  String clientName;
  List<OrderModel> models;
  int get goodsCount =>
      models?.where((item) => item.isSelectedGoods == 1)?.length ?? 0;
  bool get isMeasureOrder => orderType == 2 ?? false;
  bool get hasNotsSelectedProduct => orderStatus == 14;
  bool get hasSelectedProduct => orderStatus != 14 && orderStatus > 2;
  bool get hasAudited => orderStatus > 1;
  bool get hasMeasured => orderStatus > 2;
  bool get hasInstalled => orderStatus >= 7;
  bool get hasProducted => orderStatus > 5;
  bool get hasFinished =>
      orderStatus >= 8 && [14, 15].contains(orderStatus) == false;
  String get orderEarnestMoneyStr {
    return orderEarnestMoney.toStringAsFixed(2);
  }

  bool get hasMoreThanTwoItems => models.length > 2 ?? false;

  OrderModelData.fromJson(Map<String, dynamic> json) {
    orderId = int.parse('${json['order_id']}');
    orderNo = json['order_no'];
    orderType = int.parse('${json['order_type']}');
    orderStatus = int.parse('${json['order_status']}');
    receiverName = json['receiver_name'];
    createTime = json['create_time'] ?? 0;
    orderEarnestMoney = double.parse('${json['order_earnest_money']}');
    tailMoney = double.parse('${json['tail_money']}');
    orderEstimatedPrice = double.parse('${json['order_estimated_price']}');
    orderWindowNum = '${json['order_window_num'] ?? '1'}';
    clientId = int.parse('${json['client_id']}');
    measureTime = json['measure_time'];
    installTime = json['install_time'];
    orderTypeName = json['order_type_name'];
    statusName = json['status_name'];
    clientName = json['client_name'];
    if (json['order_item_list'] != null) {
      models = new List<OrderModel>();
      json['order_item_list'].forEach((v) {
        models.add(new OrderModel.fromJson(v));
      });
    }
  }
}

class OrderModel {
  int orderGoodsId;
  int goodsId;
  String goodsName;
  double price;
  int isSelectedGoods;
  int goodsPicture;
  List<OrderProductAttr> attrs;
  int orderStatus;
  String statusName;
  OrderThumbnailPicture picture;
  String roomName = '';
  double width = 0.0;
  double height = 0.0;
  String style = '';
  String mode = '';
  int goodsType = 1;
  String get unit => goodsType == 2 ? '元/平方米' : '元/米';
  bool get hasSelectedGoods => isSelectedGoods == 1;
  bool get hasAudit => orderStatus > 2;
  String get sizeTextDesc => '宽: ${width / 100}米 高: ${height / 100}米';
  OrderModel.fromJson(Map<String, dynamic> json) {
    orderGoodsId = json['order_goods_id'].runtimeType == int
        ? json['order_goods_id']
        : int.parse(json['order_goods_id']);
    goodsId = json['goods_id'].runtimeType == int
        ? json['goods_id']
        : int.parse(json['goods_id']);
    goodsName = json['goods_name'];
    price = json['price'].runtimeType == double
        ? json['price']
        : double.parse(json['price']);
    isSelectedGoods = json['is_selected_goods'].runtimeType == int
        ? json['is_selected_goods']
        : int.parse(json['is_selected_goods']);
    goodsPicture = json['goods_picture'].runtimeType == int
        ? json['goods_picture']
        : int.parse(json['goods_picture']);

    List list = json['wc_attr'] == null
        ? []
        : json['wc_attr'].runtimeType == Map
            ? json['wc_attr'].values.toList()
            : [];
    attrs = list.map((item) => OrderProductAttr.fromJson(item)).toList();
    if (json['wc_attr'] != null) {
      roomName = json['wc_attr']['1'] == null
          ? ''
          : json['wc_attr']['1']['name'] ?? '';
      width = json['wc_attr']['9'] == null
          ? 0.0
          : json['wc_attr']['9'][0] != null
              ? double.parse(json['wc_attr']['9'][0]['value'] ?? '0.0')
              : 0.0;
      height = json['wc_attr']['9'] == null
          ? 0.0
          : json['wc_attr']['9'][1] != null
              ? double.parse(json['wc_attr']['9'][1]['value'] ?? '0.0')
              : 0.0;
      style = json['wc_attr']['2'] == null
          ? ''
          : json['wc_attr']['2']['name'] ?? '';
    }
    mode = json['measure_data'] ?? '';
    orderStatus = json['order_status'].runtimeType == int
        ? json['order_status']
        : int.parse(json['order_status']);
    statusName = json['status_name'] ?? '';
    goodsType = json['goods_special_type'];
    picture = json['picture'] != null
        ? OrderThumbnailPicture.fromJson(json['picture'])
        : null;
  }
}

class OrderProductAttrWrapper {
  String attrName;
  List attrs;
  OrderProductAttrWrapper.fromJson(Map<String, dynamic> json) {
    attrName = json['attr_name'];
    attrs = json['attr'] == null
        ? []
        : json['attr'].map((item) => OrderProductAttr.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {'attr_name': attrName, 'attr': attrs};

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class OrderProductAttr {
  String name;
  String id;
  String picture;
  String price;
  String amount;
  String subtotal;
  String value;
  String title = '';

  OrderProductAttr.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      name = json['name'];
      value = '${json['value']}';
      if (['宽', '高'].contains(name)) {
        name += ' ${double.parse(value) / 100}米 ';
      }
      if (name.contains('空间')) {
        title = '${json['value']}';
      }
      id = '${json['id']}';
      picture = json['picture'] ?? '';
      price = '${json['price'] ?? ''}';
      amount = '${json['amount']}';
      subtotal = '${json['subtotal']}';
    }
  }

  @override
  String toString() {
    return '${toJson()}';
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };
}

class OrderThumbnailPicture {
  String picCover;
  String picCoverBig;
  String picCoverMid;
  String picCoverSmall;
  String picCoverMicro;

  OrderThumbnailPicture.fromJson(Map<String, dynamic> json) {
    picCover = json['pic_cover'];
    picCoverBig = json['pic_cover_big'];
    picCoverMid = json['pic_cover_mid'];
    picCoverSmall = json['pic_cover_small'];
    picCoverMicro = json['pic_cover_micro'];
  }
}
