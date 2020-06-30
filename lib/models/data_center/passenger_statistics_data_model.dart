import '../zy_response.dart';

class PassengerStatisticsDataModelResp
    extends ZYResponse<PassengerStatisticsDataModelDataWrapper> {
  PassengerStatisticsDataModelResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data = this.valid
        ? PassengerStatisticsDataModelDataWrapper.fromJson(json['data'])
        : null;
  }
}

class PassengerStatisticsDataModelDataWrapper {
  PassengerFlowData passengerFlowData;
  List<PassengerStatisticsDataModel> statisticsDataModels;
  String time;

  PassengerStatisticsDataModelDataWrapper.fromJson(Map<String, dynamic> json) {
    passengerFlowData = PassengerFlowData.fromJson(json);

    if (json['week'] != null) {
      statisticsDataModels = new List<PassengerStatisticsDataModel>();
      json['week'].forEach((v) {
        if (v['date'] != null && v['date']?.isNotEmpty == true) {
          statisticsDataModels
              .add(new PassengerStatisticsDataModel.fromJson(v));
        }
      });
    }
    time = json['time'];
  }
}

class PassengerFlowData {
  List data;

  PassengerFlowData.fromJson(Map json) {
    data = json['current'] ?? [];
  }

  get status0Num => data[0] ?? 0;
  get status1Num => data[1] ?? 0;
  get status2Num => data[2] ?? 0;
  get status3Num => data[2] ?? 0;

  get sum {
    int total = 0;
    for (int i = 0; i < data.length; i++) {
      total += data[i] ?? 0;
    }
    return total;
  }

  double get convertionRate => sum == 0 ? 0.0 : status3Num / sum;
  double get unconvertionRate => 1 - convertionRate;
  String get convertionRateStr =>
      '${(convertionRate * 100).toStringAsFixed(2)}%';
  String get unconvertionRateStr =>
      '${(unconvertionRate * 100).toStringAsFixed(2)}%';
}

class PassengerStatisticsDataModel {
  DateTime date;
  int value;
  List<int> data;
  bool showAsMonth = false;
  PassengerStatisticsDataModel({this.date, this.value});
  PassengerStatisticsDataModel.fromJson(Map<String, dynamic> json) {
    String str = json['date'];

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

    value = json['value'];
    data = json['data'].cast<int>();
  }
}
