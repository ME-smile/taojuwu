import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/models/user/customer_detail_model.dart';
import 'package:taojuwu/models/zy_response.dart';

import 'order_model.dart';

class OrderDerailModelResp extends ZYResponse {
  OrderDerailModelResp.fromMap(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data =
        this.valid ? OrderDetailModelWrppaer.fromJson(json['data']) : null;
  }
}

class OrderDetailModelWrppaer {
  int expressCount;
  int isShowExpressCode;
  OrderDetailModel orderDetailModel;

  OrderDetailModelWrppaer.fromJson(Map<String, dynamic> json) {
    expressCount = json['express_count'];
    isShowExpressCode = json['is_show_express_code'];
    orderDetailModel =
        json['order'] != null ? OrderDetailModel.fromJson(json['order']) : null;
  }
}

class OrderDetailModel {
  int orderId;
  String orderNo;
  String outTradeNo;
  int orderType;
  int paymentType;
  int shippingType;
  String orderFrom;
  int clientId;
  String userName;
  int buyerId;
  String buyerIp;
  String buyerMessage;
  String buyerInvoice;
  String receiverMobile;
  int receiverProvince;
  int receiverCity;
  int receiverDistrict;
  String receiverAddress;
  String receiverZip;
  String receiverName;
  int shopId;
  String shopName;
  int sellerStar;
  String sellerMemo;
  int consignTimeAdjust;
  String goodsMoney;
  String orderMoney;
  int point;
  String pointMoney;
  String couponMoney;
  int couponId;
  String userMoney;
  String userPlatformMoney;
  String promotionMoney;
  String shippingMoney;
  String payMoney;
  String refundMoney;
  String coinMoney;
  int givePoint;
  String giveCoin;
  int orderStatus;
  int payStatus;
  int shippingStatus;
  int reviewStatus;
  int feedbackStatus;
  int isEvaluate;
  String taxMoney;
  int shippingCompanyId;
  int givePointType;
  int payTime;
  int shippingTime;
  int signTime;
  int consignTime;
  int createTime;
  int updateTime;
  int finishTime;
  int isDeleted;
  int operatorType;
  int operatorId;
  String refundBalanceMoney;
  String fixedTelephone;
  int tuangouGroupId;
  String distributionTimeOut;
  int isVirtual;
  int promotionType;
  int promotionId;
  String orderCloseReason;
  String orderRemark;
  int measureInstallStatus;
  String measureTime;
  int realityMeasureTime;
  String installTime;
  int realityInstallTime;
  List measureManuscriptsPicture;
  String orderWindowNum;
  String orderEarnestMoney;
  String tailMoney;
  String orderEstimatedPrice;
  String adjustMoney;
  String adjustMoneyRemark;
  String realityPayMoney;
  int noticeStatus;
  String installRemark;
  String installPicture;
  int isApartment;
  String apartmentName;
  String tag;
  String clientName;
  CustomerDetailModel clientInfo;
  MemberInfo memberInfo;
  List<String> buyerInvoiceInfo;
  String paymentTypeName;
  String shippingTypeName;
  String shippingCompanyName;
  List<OrderGoods> orderGoods;
  String orderPickup;
  List<Operation> operation;
  List<String> memberOperation;
  String statusName;
  List<OrderAction> orderAction;
  String address;
  String payStatusName;
  String shippingStatusName;
  List<OrderGoods> orderGoodsNoDelive;
  List<String> goodsPacketList;
  List<String> promotionTypeInfo;
  String promotionTypeName;
  String orderTypeName;
  int measureAdjustment;
  int installAdjustment;
  Distribution distribution;
  List<Reason> reason;
  String autoSignTime;
  String acceptStation;
  String acceptTime;
  bool get isSameYear {
    if (measureTime?.isNotEmpty == true && installTime?.isNotEmpty == true) {
      if (measureTime.length > 4 && installTime.length > 4) {
        return measureTime?.substring(0, 4) == installTime?.substring(0, 4);
      }
      return false;
    }
    return false;
  }

  bool get hasAdjustMeasureTime => measureAdjustment == 1;
  bool get hasAdjustInstallime => installAdjustment == 1;
  int get goodsNum =>
      orderGoods
          ?.where((item) => item.isSelectedGoods == 1)
          ?.toList()
          ?.length ??
      0;

  int get unselectedGoodsNum =>
      orderGoods
          ?.where((item) => item?.isSelectedGoods == 0)
          ?.toList()
          ?.length ??
      0;

  int get selectedGoodsNum => orderGoods.length - unselectedGoodsNum;

  String get goodsNumDescText => isMeasureOrder
      ? isWaitingToSelectProduct
          ? '共${orderWindowNum ?? '0'}窗已选${selectedGoodsNum ?? 0}件商品'
          : '共${goodsNum ?? 0}件'
      : '共${goodsNum ?? 0}件';

  bool get showExpressInfo => orderStatus == 7 ?? false;
  String get windowNum => '${orderWindowNum ?? '1'}';
  bool get canCancel => orderStatus != 15 ?? true;
  bool get isMeasureOrder => orderType == 2 ?? false;
  bool get isShowAllInfo => [1, 2].contains(orderStatus) ?? false;
  bool get isShowManuscript => (hasMeasured && isMeasureOrder) ?? false;
  bool get haNotsSelectedProduct => orderStatus == 14;
  bool get hasAudited => orderStatus > 1;
  bool get hasMeasured => orderStatus > 2;
  bool get hasInstalled =>
      orderStatus >= 7 && orderStatus != 14 && orderStatus != 15;
  bool get hasProducted => orderStatus > 5;
  bool get canEditPrice => orderStatus == 3;
  bool get hasScheduled => orderStatus > 3;
  bool get hasAlreadyCancel => orderStatus == 9;
  // bool get hasCancel
  bool get hasCanceled => orderStatus == 9;

  bool get isProducting => orderStatus == 5;
  bool get isWaitingToship => orderStatus == 6;
  bool get isWaitingToShipOrReceive => orderStatus == 6 || orderStatus == 15;
  bool get isWaitingToInstall => orderStatus == 7;
  bool get isWaitingToSelectProduct => orderStatus == 14;
  bool get isWaitingToPay => orderStatus == 3 || orderStatus == 4;
  bool get hasFinished =>
      orderStatus >= 8 && [14, 9, 15].contains(orderStatus) == false;
  bool get hasPaid => orderStatus > 4;
  bool get hasShipped => [15, 7, 8].contains(orderStatus);
  bool get isAdjustPriceRemarkEmpty =>
      adjustMoneyRemark == null || adjustMoneyRemark?.isNotEmpty == false;

  bool get hasModifyPrice => adjustMoney?.isNotEmpty == true;

  bool get displayDeliveryInfo => orderStatus == 15 || orderStatus == 7;
  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderNo = json['order_no'];
    outTradeNo = json['out_trade_no'];
    orderType = json['order_type'];
    paymentType = json['payment_type'];
    shippingType = json['shipping_type'];
    orderFrom = json['order_from'];
    clientId = json['client_id'];
    userName = json['user_name'];
    buyerId = json['buyer_id'];
    buyerIp = json['buyer_ip'];
    buyerMessage = json['buyer_message'];
    buyerInvoice = json['buyer_invoice'];
    receiverMobile = json['receiver_mobile'];
    receiverProvince = json['receiver_province'];
    receiverCity = json['receiver_city'];
    receiverDistrict = json['receiver_district'];
    receiverAddress = json['receiver_address'];
    receiverZip = json['receiver_zip'];
    receiverName = json['receiver_name'];
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    sellerStar = json['seller_star'];
    sellerMemo = json['seller_memo'];
    consignTimeAdjust = json['consign_time_adjust'];
    goodsMoney = json['goods_money'];
    orderMoney = json['order_money'];
    point = json['point'];
    pointMoney = json['point_money'];
    couponMoney = json['coupon_money'];
    couponId = json['coupon_id'];
    userMoney = json['user_money'];
    userPlatformMoney = json['user_platform_money'];
    promotionMoney = json['promotion_money'];
    shippingMoney = json['shipping_money'];
    payMoney = json['pay_money'];
    refundMoney = json['refund_money'];
    coinMoney = json['coin_money'];
    givePoint = json['give_point'];
    giveCoin = json['give_coin'];
    orderStatus = json['order_status'];
    payStatus = json['pay_status'];
    shippingStatus = json['shipping_status'];
    reviewStatus = json['review_status'];
    feedbackStatus = json['feedback_status'];
    isEvaluate = json['is_evaluate'];
    taxMoney = json['tax_money'];
    shippingCompanyId = json['shipping_company_id'];
    givePointType = json['give_point_type'];
    payTime = json['pay_time'];
    shippingTime = json['shipping_time'];
    signTime = json['sign_time'];
    consignTime = json['consign_time'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    finishTime = json['finish_time'];
    isDeleted = json['is_deleted'];
    operatorType = json['operator_type'];
    operatorId = json['operator_id'];
    refundBalanceMoney = json['refund_balance_money'];
    fixedTelephone = json['fixed_telephone'];
    tuangouGroupId = json['tuangou_group_id'];
    distributionTimeOut = json['distribution_time_out'];
    isVirtual = json['is_virtual'];
    promotionType = json['promotion_type'];
    promotionId = json['promotion_id'];
    orderCloseReason = json['order_close_reason'];
    orderRemark = json['order_remark'];
    measureInstallStatus = json['measure_install_status'];
    measureTime = json['measure_time'];
    realityMeasureTime = json['reality_measure_time'];
    installTime = json['install_time'];
    realityInstallTime = json['reality_install_time'];
    measureManuscriptsPicture = json['measure_manuscripts_picture'];
    orderWindowNum = '${json['order_window_num'] ?? ''}';
    orderEarnestMoney = json['order_earnest_money'];
    tailMoney = json['tail_money'];
    orderEstimatedPrice = json['order_estimated_price'];
    adjustMoney = json['adjust_money'];
    adjustMoneyRemark = '${json['adjust_money_remark'] ?? ''}';
    realityPayMoney = json['reality_pay_money'];
    noticeStatus = json['notice_status'];
    installRemark = json['install_remark'];
    installPicture = json['install_picture'];
    isApartment = json['is_apartment'];
    apartmentName = json['apartment_name'];
    tag = json['tag'];
    clientName = json['client_name'];
    clientInfo = json['client_info'] != null
        ? new CustomerDetailModel.fromJson(json['client_info'])
        : null;
    memberInfo = json['member_info'] != null
        ? new MemberInfo.fromJson(json['member_info'])
        : null;
    // if (json['buyer_invoice_info'] != null) {
    // 	buyerInvoiceInfo = new List<Null>();
    // 	json['buyer_invoice_info'].forEach((v) { buyerInvoiceInfo.add(new Null.fromJson(v)); });
    // }
    paymentTypeName = json['payment_type_name'];
    shippingTypeName = json['shipping_type_name'];
    shippingCompanyName = json['shipping_company_name'];
    if (json['order_goods'] != null) {
      orderGoods = new List<OrderGoods>();
      json['order_goods'].forEach((v) {
        v['parent_order_status'] = orderStatus ?? -1;
        orderGoods.add(new OrderGoods.fromJson(v));
      });
    }
    orderPickup = json['order_pickup'];
    if (json['operation'] != null) {
      operation = new List<Operation>();
      json['operation'].forEach((v) {
        operation.add(new Operation.fromJson(v));
      });
    }
    // if (json['member_operation'] != null) {
    // 	memberOperation = new List<Null>();
    // 	json['member_operation'].forEach((v) { memberOperation.add(new Null.fromJson(v)); });
    // }
    statusName = json['status_name'];
    if (json['order_action'] != null) {
      orderAction = new List<OrderAction>();
      json['order_action'].forEach((v) {
        orderAction.add(new OrderAction.fromJson(v));
      });
    }
    address = json['address'];
    payStatusName = json['pay_status_name'];
    shippingStatusName = json['shipping_status_name'];
    // if (json['order_goods_no_delive'] != null) {
    // 	orderGoodsNoDelive = new List<OrderGoodsNoDelive>();
    // 	json['order_goods_no_delive'].forEach((v) { orderGoodsNoDelive.add(new OrderGoodsNoDelive.fromJson(v)); });
    // }
    // if (json['goods_packet_list'] != null) {
    // 	goodsPacketList = new List<Null>();
    // 	json['goods_packet_list'].forEach((v) { goodsPacketList.add(new Null.fromJson(v)); });
    // }
    // if (json['promotion_type_info'] != null) {
    // 	promotionTypeInfo = new List<Null>();
    // 	json['promotion_type_info'].forEach((v) { promotionTypeInfo.add(new Null.fromJson(v)); });
    // }
    promotionTypeName = json['promotion_type_name'];
    orderTypeName = json['order_type_name'];
    distribution = json['distribution'] != null
        ? new Distribution.fromJson(json['distribution'])
        : null;
    if (json['reason'] != null) {
      reason = new List<Reason>();
      json['reason'].forEach((v) {
        reason.add(new Reason.fromJson(v));
      });
    }
    measureAdjustment = json['measure_adjustment'] ?? 0;
    installAdjustment = json['install_adjustment'] ?? 0;
    autoSignTime = json['auto_sign_time'] ?? '';
    acceptStation = json['AcceptStation'] ?? '';
    acceptTime = json['AcceptTime'] ?? '';
  }
}

class MemberInfo {
  String nickName;
  String userTel;
  String shopAddress;

  MemberInfo({this.nickName, this.userTel, this.shopAddress});

  MemberInfo.fromJson(Map<String, dynamic> json) {
    nickName = json['nick_name'];
    userTel = json['user_tel'];
    shopAddress = json['shop_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nick_name'] = this.nickName;
    data['user_tel'] = this.userTel;
    data['shop_address'] = this.shopAddress;
    return data;
  }
}

class Reason {
  String title;
  int reasonId;
  int select;

  Reason({this.title, this.reasonId, this.select});

  Reason.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    reasonId = json['reasonId'];
    select = json['select'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['reasonId'] = this.reasonId;
    data['select'] = this.select;
    return data;
  }
}

class Operation {
  String no;
  String name;
  String color;

  Operation({this.no, this.name, this.color});

  Operation.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    name = json['name'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['no'] = this.no;
    data['name'] = this.name;
    data['color'] = this.color;
    return data;
  }
}

class OrderGoods {
  int orderGoodsId;
  int orderId;
  int goodsId;
  int goodsSpecialType;
  String goodsName;
  int skuId;
  String skuName;
  String price;
  String costPrice;
  String count;
  int isAccept;
  String adjustMoney;
  String goodsMoney;
  int goodsPicture;
  int shopId;
  int buyerId;
  int pointExchangeType;
  String goodsType;
  int promotionId;
  int promotionTypeId;
  int orderType;
  int orderStatus;
  int givePoint;
  int shippingStatus;
  int refundType;
  String refundRequireMoney;
  String refundReason;
  String refundShippingCode;
  String refundShippingCompany;
  String refundRealMoney;
  int refundStatus;
  String memo;
  int isEvaluate;
  int refundTime;
  String refundBalanceMoney;
  String tmpExpressCompany;
  int tmpExpressCompanyId;
  String tmpExpressNo;
  int giftFlag;
  int isVirtual;
  String refundDesc;
  String refundPic;
  int refundGoodsStatus;
  int isSelectedGoods;
  int isShade;
  List<OrderProductAttrWrapper> wcAttr;
  String estimatedPrice;
  ExpressInfo expressInfo;
  String shippingStatusName;
  PictureInfo pictureInfo;
  List<String> refundOperation;
  String statusName;
  OrderGoodsMeasure orderGoodsMeasure;
  String goodsAttrStr;
  int parentOrderStatus;
  String earnestMoney;
  bool get hasSelectedProduct => isSelectedGoods == 1;
  bool get canCancel =>
      (orderStatus != 15 && refundStatus == 0) || refundStatus == -4;
  bool get hasAlreadyCancel => orderStatus == 9;
  bool get subOrderHasSameStatusWithParent =>
      (orderStatus == parentOrderStatus) ?? false;
  bool get showExpressInfo => orderStatus == 7;
  bool get isWindowRoller => goodsSpecialType == 2;
  String get unit => goodsSpecialType == 2 ? '元/平方米' : '元/米';
  OrderGoods(
      {this.orderGoodsId,
      this.orderId,
      this.goodsId,
      this.goodsName,
      this.skuId,
      this.skuName,
      this.price,
      this.costPrice,
      this.count,
      this.isAccept,
      this.adjustMoney,
      this.goodsMoney,
      this.goodsPicture,
      this.shopId,
      this.buyerId,
      this.pointExchangeType,
      this.goodsType,
      this.promotionId,
      this.promotionTypeId,
      this.orderType,
      this.orderStatus,
      this.givePoint,
      this.shippingStatus,
      this.refundType,
      this.refundRequireMoney,
      this.refundReason,
      this.refundShippingCode,
      this.refundShippingCompany,
      this.refundRealMoney,
      this.refundStatus,
      this.memo,
      this.isEvaluate,
      this.refundTime,
      this.refundBalanceMoney,
      this.tmpExpressCompany,
      this.tmpExpressCompanyId,
      this.tmpExpressNo,
      this.giftFlag,
      this.isVirtual,
      this.refundDesc,
      this.refundPic,
      this.refundGoodsStatus,
      this.isSelectedGoods,
      this.isShade,
      this.wcAttr,
      this.estimatedPrice,
      this.expressInfo,
      this.shippingStatusName,
      this.pictureInfo,
      this.refundOperation,
      this.statusName,
      this.orderGoodsMeasure,
      this.earnestMoney,
      this.parentOrderStatus});

  OrderGoods.fromJson(Map<String, dynamic> json) {
    orderGoodsId = json['order_goods_id'];
    orderId = json['order_id'];
    goodsId = json['goods_id'];
    goodsSpecialType = json['goods_special_type'];
    goodsName = json['goods_name'];
    skuId = json['sku_id'];
    skuName = json['sku_name'];
    price = json['price'];
    costPrice = json['cost_price'];
    count = json['num'];
    isAccept = json['is_accept'];
    adjustMoney = json['adjust_money'];
    goodsMoney = json['goods_money'];
    goodsPicture = json['goods_picture'];
    shopId = json['shop_id'];
    buyerId = json['buyer_id'];
    pointExchangeType = json['point_exchange_type'];
    goodsType = json['goods_type'];
    promotionId = json['promotion_id'];
    promotionTypeId = json['promotion_type_id'];
    orderType = json['order_type'];
    orderStatus = json['order_status'];
    givePoint = json['give_point'];
    shippingStatus = json['shipping_status'];
    refundType = json['refund_type'];
    refundRequireMoney = json['refund_require_money'];
    refundReason = json['refund_reason'];
    refundShippingCode = json['refund_shipping_code'];
    refundShippingCompany = json['refund_shipping_company'];
    refundRealMoney = json['refund_real_money'];
    refundStatus = json['refund_status'];
    memo = json['memo'];
    isEvaluate = json['is_evaluate'];
    refundTime = json['refund_time'];
    refundBalanceMoney = json['refund_balance_money'];
    tmpExpressCompany = json['tmp_express_company'];
    tmpExpressCompanyId = json['tmp_express_company_id'];
    tmpExpressNo = json['tmp_express_no'];
    giftFlag = json['gift_flag'];
    isVirtual = json['is_virtual'];
    refundDesc = '${json['refund_desc'] ?? ''}';
    refundPic = json['refund_pic'];
    refundGoodsStatus = json['refund_goods_status'];
    isSelectedGoods = json['is_selected_goods'];
    isShade = json['is_shade'];
    parentOrderStatus = json['parent_order_status'];
    goodsAttrStr = json['goods_attr_str'] ?? '';
    Map map = json['wc_attr'];

    List<Map<String, dynamic>> wrapper = [];
    map?.forEach((key, val) {
      Map<String, dynamic> tmp = {};
      tmp['attr_name'] = Constants.ATTR_MAP[int.parse('$key')];
      tmp['attr'] = val is List ? val : [val];
      wrapper.add(tmp);
    });

    wcAttr =
        wrapper.map((item) => OrderProductAttrWrapper.fromJson(item)).toList();
    estimatedPrice = json['estimated_price'];
    expressInfo = json['express_info'] != null && json['express_info'] is Map
        ? new ExpressInfo.fromJson(json['express_info'])
        : null;
    shippingStatusName = json['shipping_status_name'];

    pictureInfo = json['picture_info'] != null && json['picture_info'] is Map
        ? new PictureInfo.fromJson(json['picture_info'])
        : null;
    if (json['refund_operation'] != null) {
      // refundOperation = new List<Null>();
      // json['refund_operation'].forEach((v) { refundOperation.add(new Null.fromJson(v)); });
    }
    statusName = json['status_name'];
    orderGoodsMeasure = json['order_goods_measure'] != null
        ? new OrderGoodsMeasure.fromJson(json['order_goods_measure'])
        : null;
    earnestMoney = json['earnest_money'];
  }
}

class PictureInfo {
  int picId;
  int shopId;
  int albumId;
  int isWide;
  String picName;
  String picTag;
  String picCover;
  String picSize;
  String picSpec;
  String picCoverBig;
  String picSizeBig;
  String picSpecBig;
  String picCoverMid;
  String picSizeMid;
  String picSpecMid;
  String picCoverSmall;
  String picSizeSmall;
  String picSpecSmall;
  String picCoverMicro;
  String picSizeMicro;
  String picSpecMicro;
  int uploadTime;
  int uploadType;
  String domain;
  String bucket;

  PictureInfo(
      {this.picId,
      this.shopId,
      this.albumId,
      this.isWide,
      this.picName,
      this.picTag,
      this.picCover,
      this.picSize,
      this.picSpec,
      this.picCoverBig,
      this.picSizeBig,
      this.picSpecBig,
      this.picCoverMid,
      this.picSizeMid,
      this.picSpecMid,
      this.picCoverSmall,
      this.picSizeSmall,
      this.picSpecSmall,
      this.picCoverMicro,
      this.picSizeMicro,
      this.picSpecMicro,
      this.uploadTime,
      this.uploadType,
      this.domain,
      this.bucket});

  PictureInfo.fromJson(Map<String, dynamic> json) {
    picId = json['pic_id'];
    shopId = json['shop_id'];
    albumId = json['album_id'];
    isWide = json['is_wide'];
    picName = json['pic_name'];
    picTag = json['pic_tag'];
    picCover = json['pic_cover'];
    picSize = json['pic_size'];
    picSpec = json['pic_spec'];
    picCoverBig = json['pic_cover_big'];
    picSizeBig = json['pic_size_big'];
    picSpecBig = json['pic_spec_big'];
    picCoverMid = json['pic_cover_mid'];
    picSizeMid = json['pic_size_mid'];
    picSpecMid = json['pic_spec_mid'];
    picCoverSmall = json['pic_cover_small'];
    picSizeSmall = json['pic_size_small'];
    picSpecSmall = json['pic_spec_small'];
    picCoverMicro = json['pic_cover_micro'];
    picSizeMicro = json['pic_size_micro'];
    picSpecMicro = json['pic_spec_micro'];
    uploadTime = json['upload_time'];
    uploadType = json['upload_type'];
    domain = json['domain'];
    bucket = json['bucket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pic_id'] = this.picId;
    data['shop_id'] = this.shopId;
    data['album_id'] = this.albumId;
    data['is_wide'] = this.isWide;
    data['pic_name'] = this.picName;
    data['pic_tag'] = this.picTag;
    data['pic_cover'] = this.picCover;
    data['pic_size'] = this.picSize;
    data['pic_spec'] = this.picSpec;
    data['pic_cover_big'] = this.picCoverBig;
    data['pic_size_big'] = this.picSizeBig;
    data['pic_spec_big'] = this.picSpecBig;
    data['pic_cover_mid'] = this.picCoverMid;
    data['pic_size_mid'] = this.picSizeMid;
    data['pic_spec_mid'] = this.picSpecMid;
    data['pic_cover_small'] = this.picCoverSmall;
    data['pic_size_small'] = this.picSizeSmall;
    data['pic_spec_small'] = this.picSpecSmall;
    data['pic_cover_micro'] = this.picCoverMicro;
    data['pic_size_micro'] = this.picSizeMicro;
    data['pic_spec_micro'] = this.picSpecMicro;
    data['upload_time'] = this.uploadTime;
    data['upload_type'] = this.uploadType;
    data['domain'] = this.domain;
    data['bucket'] = this.bucket;
    return data;
  }
}

class OrderGoodsMeasure {
  int id;
  int orderGoodsId;
  int orderId;
  int goodsId;
  String data;
  String remark;
  String picture;
  int status;
  String installRoom;
  String windowType;
  String windowMeasureType;
  String width;
  String widthExplain;
  String height;
  String heightExplain;
  String extent;
  String borderA;
  String borderB;
  String borderC;
  String borderD;
  String partsType;
  String installType;
  String openType;
  String verticalGroundHeight;
  String newVerticalGroundHeight;
  int plies;
  int curtainHead;
  int plasterLine;
  String frameWidth;
  String curtainBoxSize;
  String topHeight;
  String installFaceMaterials;
  String installPicture;
  String installRemark;
  int createTime;
  int updateTime;
  String partsName;
  String newOpenType;
  OrderGoodsMeasure(
      {this.id,
      this.orderGoodsId,
      this.orderId,
      this.goodsId,
      this.data,
      this.remark,
      this.picture,
      this.status,
      this.installRoom,
      this.windowType,
      this.windowMeasureType,
      this.width,
      this.widthExplain,
      this.height,
      this.heightExplain,
      this.extent,
      this.borderA,
      this.borderB,
      this.borderC,
      this.borderD,
      this.partsType,
      this.installType,
      this.openType,
      this.verticalGroundHeight,
      this.plies,
      this.curtainHead,
      this.plasterLine,
      this.frameWidth,
      this.curtainBoxSize,
      this.topHeight,
      this.installFaceMaterials,
      this.installPicture,
      this.installRemark,
      this.createTime,
      this.partsName,
      this.updateTime});

  OrderGoodsMeasure.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderGoodsId = json['order_goods_id'];
    orderId = json['order_id'];
    goodsId = json['goods_id'];
    data = json['data'];
    remark = json['remark'];
    picture = json['picture'];
    status = json['status'];
    installRoom = json['install_room'];
    windowType = json['window_type'];
    windowMeasureType = json['window_measure_type'];
    width = json['width'];
    widthExplain = json['width_explain'];
    height = json['height'];
    heightExplain = json['height_explain'];
    extent = json['extent'];
    borderA = json['border_a'];
    borderB = json['border_b'];
    borderC = json['border_c'];
    borderD = json['border_d'];
    partsType = json['parts_type'];
    installType = json['install_type'];
    openType = json['open_type'];
    verticalGroundHeight = json['vertical_ground_height'];
    plies = json['plies'];
    curtainHead = json['curtain_head'];
    plasterLine = json['plaster_line'];
    frameWidth = json['frame_width'];
    curtainBoxSize = json['curtain_box_size'];
    topHeight = json['top_height'];
    installFaceMaterials = json['install_face_materials'];
    installPicture = json['install_picture'];
    installRemark = json['install_remark'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    partsName = json['parts_name'];
    newOpenType = json['open_type'];
    newVerticalGroundHeight = json['vertical_ground_height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_goods_id'] = this.orderGoodsId;
    data['order_id'] = this.orderId;
    data['goods_id'] = this.goodsId;
    data['data'] = this.data;
    data['remark'] = this.remark;
    data['picture'] = this.picture;
    data['status'] = this.status;
    data['install_room'] = this.installRoom;
    data['window_type'] = this.windowType;
    data['window_measure_type'] = this.windowMeasureType;
    data['width'] = this.width;
    data['width_explain'] = this.widthExplain;
    data['height'] = this.height;
    data['height_explain'] = this.heightExplain;
    data['extent'] = this.extent;
    data['border_a'] = this.borderA;
    data['border_b'] = this.borderB;
    data['border_c'] = this.borderC;
    data['border_d'] = this.borderD;
    data['parts_type'] = this.partsType;
    data['install_type'] = this.installType;
    data['open_type'] = this.openType;
    data['vertical_ground_height'] = this.verticalGroundHeight;
    data['plies'] = this.plies;
    data['curtain_head'] = this.curtainHead;
    data['plaster_line'] = this.plasterLine;
    data['frame_width'] = this.frameWidth;
    data['curtain_box_size'] = this.curtainBoxSize;
    data['top_height'] = this.topHeight;
    data['install_face_materials'] = this.installFaceMaterials;
    data['install_picture'] = this.installPicture;
    data['install_remark'] = this.installRemark;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    data['parts_name'] = this.partsName;
    return data;
  }
}

class OrderAction {
  int actionId;
  int orderId;
  String action;
  int uid;
  String userName;
  int orderStatus;
  String orderStatusText;
  int actionTime;

  OrderAction(
      {this.actionId,
      this.orderId,
      this.action,
      this.uid,
      this.userName,
      this.orderStatus,
      this.orderStatusText,
      this.actionTime});

  OrderAction.fromJson(Map<String, dynamic> json) {
    actionId = json['action_id'];
    orderId = json['order_id'];
    action = json['action'];
    uid = json['uid'];
    userName = json['user_name'];
    orderStatus = json['order_status'];
    orderStatusText = json['order_status_text'];
    actionTime = json['action_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action_id'] = this.actionId;
    data['order_id'] = this.orderId;
    data['action'] = this.action;
    data['uid'] = this.uid;
    data['user_name'] = this.userName;
    data['order_status'] = this.orderStatus;
    data['order_status_text'] = this.orderStatusText;
    data['action_time'] = this.actionTime;
    return data;
  }
}

class ExpressInfo {
  int id;
  int orderId;
  String orderGoodsIdArray;
  String expressName;
  int shippingType;
  int expressCompanyId;
  String expressCompany;
  String expressNo;
  int uid;
  String userName;
  String memo;
  int shippingTime;

  ExpressInfo(
      {this.id,
      this.orderId,
      this.orderGoodsIdArray,
      this.expressName,
      this.shippingType,
      this.expressCompanyId,
      this.expressCompany,
      this.expressNo,
      this.uid,
      this.userName,
      this.memo,
      this.shippingTime});

  ExpressInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    orderGoodsIdArray = json['order_goods_id_array'];
    expressName = json['express_name'];
    shippingType = json['shipping_type'];
    expressCompanyId = json['express_company_id'];
    expressCompany = json['express_company'];
    expressNo = json['express_no'];
    uid = json['uid'];
    userName = json['user_name'];
    memo = json['memo'];
    shippingTime = json['shipping_time'];
  }
}

class Distribution {
  int commissionDistributionMoney;
  int commissionPartnerMoney;
  int commissionRegionAgentMoney;
  // List<Null> commissionDistributionList;
  // List<Null> commissionPartnerList;
  // List<Null> commissionRegionAgentList;
  Distribution(
      {this.commissionDistributionMoney,
      this.commissionPartnerMoney,
      this.commissionRegionAgentMoney});
  // Distribution({this.commissionDistributionMoney, this.commissionPartnerMoney, this.commissionRegionAgentMoney, this.commissionDistributionList, this.commissionPartnerList, this.commissionRegionAgentList});

  Distribution.fromJson(Map<String, dynamic> json) {
    commissionDistributionMoney = json['commission_distribution_money'];
    commissionPartnerMoney = json['commission_partner_money'];
    commissionRegionAgentMoney = json['commission_region_agent_money'];
    // if (json['commission_distribution_list'] != null) {
    // 	commissionDistributionList = new List<Null>();
    // 	json['commission_distribution_list'].forEach((v) { commissionDistributionList.add(new Null.fromJson(v)); });
    // }
    // if (json['commission_partner_list'] != null) {
    // 	commissionPartnerList = new List<Null>();
    // 	json['commission_partner_list'].forEach((v) { commissionPartnerList.add(new Null.fromJson(v)); });
    // }
    // if (json['commission_region_agent_list'] != null) {
    // 	commissionRegionAgentList = new List<Null>();
    // 	json['commission_region_agent_list'].forEach((v) { commissionRegionAgentList.add(new Null.fromJson(v)); });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commission_distribution_money'] = this.commissionDistributionMoney;
    data['commission_partner_money'] = this.commissionPartnerMoney;
    data['commission_region_agent_money'] = this.commissionRegionAgentMoney;
    // if (this.commissionDistributionList != null) {
    //   data['commission_distribution_list'] = this.commissionDistributionList.map((v) => v.toJson()).toList();
    // }
    // if (this.commissionPartnerList != null) {
    //   data['commission_partner_list'] = this.commissionPartnerList.map((v) => v.toJson()).toList();
    // }
    // if (this.commissionRegionAgentList != null) {
    //   data['commission_region_agent_list'] = this.commissionRegionAgentList.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
