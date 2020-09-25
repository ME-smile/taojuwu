import 'dart:convert';

import 'package:taojuwu/repository/zy_response.dart';

class TagModelListResp extends ZYResponse<TagFilterWrapper> {
  TagModelListResp.fromMap(Map<String, dynamic> json) : super.fromJson(json) {
    this.data = this.valid ? TagFilterWrapper.fromJson(json) : null;
  }
}

class TagFilterWrapper {
  List<TagFilter> filterList;

  TagFilterWrapper({this.filterList});

  TagFilterWrapper.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data'] is List) {
      filterList = new List<TagFilter>();
      json['data'].forEach((v) {
        filterList.add(new TagFilter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.filterList != null) {
      data['filter_value'] = this.filterList.map((v) => v.toJson()).toList();
    }
    return data;
  }

  void reset() {
    filterList?.forEach((item) {
      item?.filterValue?.forEach((bean) {
        bean?.isChecked = false;
      });
    });
  }

  Map<String, dynamic> get args {
    Map<String, List<String>> map = {};
    filterList?.forEach((item) {
      if (map[item?.filterName] == null) {
        map[item?.filterName] = item?.checkedOptions;
      } else {
        map[item?.filterName]?.addAll(item?.checkedOptions);
      }
    });
    return {'filter_condition': jsonEncode(map)};
  }
}

class TagFilter {
  String showName;
  String filterName;
  int isMultiPle;
  List<TagFilterOption> filterValue;

  bool get isMulti => isMultiPle == 1;
  TagFilter({this.showName, this.filterName, this.filterValue});

  TagFilter.fromJson(Map<String, dynamic> json) {
    showName = json['show_name'];
    filterName = json['filter_name'];
    isMultiPle = json['is_multiple'];

    if (json['filter_value'] != null) {
      filterValue = new List<TagFilterOption>();
      json['filter_value'].forEach((v) {
        v['key'] = filterName;
        v['is_refresh'] = json['is_refresh'];
        filterValue.add(new TagFilterOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['show_name'] = this.showName;
    data['filter_name'] = this.filterName;
    if (this.filterValue != null) {
      data['filter_value'] = this.filterValue.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<String> get checkedOptions =>
      filterValue
          ?.where((item) => item?.isChecked == true)
          ?.map((item) => item?.id)
          ?.toList() ??
      [];
}

class TagFilterOption {
  String key;
  String id;
  String name;
  bool isChecked = false;
  bool shouldRefresh = false;
  TagFilterOption({
    this.id,
    this.name,
  });

  TagFilterOption.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    id = '${json['id']}';
    name = json['name'];
    shouldRefresh = json['is_refresh'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;

    return data;
  }
}
