import 'package:taojuwu/models/zy_response.dart';

class SaleAnalysisDataModelResp
    extends ZYResponse<SaleAnalysisDataModelWrapper> {
  SaleAnalysisDataModelResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data =
        this.valid ? SaleAnalysisDataModelWrapper.fromJson(json['data']) : null;
  }
}

class SaleAnalysisDataModelWrapper {
  List<int> genderList;
  List<int> ageList;
  List<SaleGoodsCount> goodsList = [];
  String time;

  List<int> conver2IntList(List list) {
    if (list == null || list.isEmpty == true) return [];
    return list
        .map((item) => item is int ? item : int.parse(item ?? '0'))
        ?.toList();
  }

  SaleAnalysisDataModelWrapper.fromJson(Map<String, dynamic> json) {
    genderList = conver2IntList(json['sex']);
    ageList = conver2IntList(json['age']);
    time = json['time'];
    json['goods'] = json['goods'] ?? {};
    if (json['goods'] is Map) {
      json['goods']?.forEach((key, value) {
        goodsList?.add(SaleGoodsCount(key, value));
      });
    }
  }
}

class SaleGoodsCount {
  String name;
  int count;
  SaleGoodsCount(this.name, this.count);
}
