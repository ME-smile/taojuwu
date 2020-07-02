import '../zy_response.dart';

class SaleStatisticsDataModelResp
    extends ZYResponse<SaleStatisticsDataModelWrapper> {
  SaleStatisticsDataModelResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid
        ? SaleStatisticsDataModelWrapper.fromJson(json['data'])
        : null;
  }
}

class SaleStatisticsDataModelWrapper {
  List moneyData;
  List<SalesGoodsModel> goodsList = [];
  List<SaleStatisticsDataModel> models = [];
  String time;
  SaleStatisticsDataModelWrapper.fromJson(Map<String, dynamic> json) {
    moneyData = json['money'];

    json['goods'] = json['goods'] ?? {};
    if (json['goods'] is Map) {
      json['goods']?.forEach((key, value) {
        goodsList?.add(SalesGoodsModel(key, value));
      });
    }

    if (json['year'] != null) {
      models = new List<SaleStatisticsDataModel>();
      json['year'].forEach((v) {
        if (v['date'] != null && v['date']?.isNotEmpty == true) {
          models.add(new SaleStatisticsDataModel.fromJson(v));
        }
      });
    }
    time = json['time'];
  }
}

class SalesGoodsModel {
  final String name;
  final money;
  const SalesGoodsModel(this.name, this.money);
}

class SaleStatisticsDataModel {
  DateTime date;
  num value;

  bool showAsMonth = false;
  SaleStatisticsDataModel({this.date, this.value});
  SaleStatisticsDataModel.fromJson(Map<String, dynamic> json) {
    String str = json['date'];
    if (str != null || str?.isNotEmpty == true) {
      if (str?.contains('月') == true) {
        showAsMonth = true;
        List<String> tmp = str?.split('月') ?? [];
        int month = int.parse(tmp?.first);
        date = DateTime(DateTime.now().year, month);
      } else {
        showAsMonth = false;
        List<String> tmp = str?.split('.') ?? [];
        List<int> arr = tmp?.map((item) => int.parse(item))?.toList();
        date = DateTime(DateTime.now().year, arr?.first, arr?.last);
      }
    }

    value = json['value'];
  }
}
