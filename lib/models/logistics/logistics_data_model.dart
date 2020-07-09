import 'package:taojuwu/models/zy_response.dart';

class LogisticsDataModelResp extends ZYResponse<LogisticsDataModelWrapper> {
  LogisticsDataModelResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid ? LogisticsDataModelWrapper.fromJson(json) : null;
  }
}

class LogisticsDataModelWrapper {
  List<GoodsPacketModel> goodsPacketList;

  int get hasDeliveredPacketCount {
    int count = 0;
    goodsPacketList?.forEach((item) {
      if (item?.hasDelivery == true) {
        count++;
      }
    });
    return count;
  }

  LogisticsDataModelWrapper({this.goodsPacketList});
  LogisticsDataModelWrapper.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      goodsPacketList = new List<GoodsPacketModel>();

      json['data'].forEach((v) {
        goodsPacketList.add(new GoodsPacketModel.fromJson(v));
      });
    }
  }
}

class GoodsPacketModel {
  String packetName;
  String expressStatusName;
  String expressName;
  String expressCode;
  int orderGoodsNum;
  List<String> orderGoodsPictures;
  List<ExpressOrderModel> expressOrderModels;

  bool get hasDelivery {
    return ['无需物流', '未发货'].contains(packetName) == false;
  }

  bool get needDelivery {
    return ['无需物流'].contains(packetName) == false;
  }

  bool get hasNotDelivered {
    return ['未发货'].contains(packetName) == true;
  }

  GoodsPacketModel(
      {this.packetName,
      this.expressStatusName,
      this.expressName,
      this.expressCode,
      this.orderGoodsNum,
      this.orderGoodsPictures,
      this.expressOrderModels});

  GoodsPacketModel.fromJson(Map<String, dynamic> json) {
    packetName = json['packet_name'];
    expressStatusName = json['express_status_name'];
    expressName = json['express_name'];
    expressCode = json['express_code'];
    orderGoodsNum = json['order_goods_num'];
    orderGoodsPictures = json['order_goods_picture'].cast<String>();
    if (json['express_message'] != null &&
        json['express_message']?.isNotEmpty == true) {
      expressOrderModels = new List<ExpressOrderModel>();
      json['express_message'].forEach((v) {
        expressOrderModels.add(new ExpressOrderModel.fromJson(v));
      });
    }
  }
}

class ExpressOrderModel {
  String acceptTime;
  String acceptStation;
  String title;

  ExpressOrderModel({this.acceptTime, this.acceptStation, this.title});

  ExpressOrderModel.fromJson(Map<String, dynamic> json) {
    acceptTime = json['AcceptTime'];
    acceptStation = json['AcceptStation'];
    title = json['title'];
  }
}
