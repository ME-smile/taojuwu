/*
 * @Description: 城市选择
 * @Author: iamsmiling
 * @Date: 2020-11-28 23:11:50
 * @LastEditTime: 2020-12-22 10:49:04
 */

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './data/location_data.dart';

typedef ValueChanged = AddressEntity Function(Map map);

List<Map> quertProviceList() => proviceData["RECORDS"];

///[description]: 查找城市列表
///[params]: provinceId 选中的城市列表
///[return]: 当前省份下的所有城市
List<Map> queryCityList(int provinceId) {
  ///使用set集合可以过滤重复
  Set<Map> citySet = {};
  List<Map> data = cityData["RECORDS"];
  for (int i = 0; i < data.length; i++) {
    Map item = data[i];
    if (item["province_id"] == provinceId) {
      citySet.add(item);
    }
  }
  return citySet.toList();
}

List<Map> queryDistrictList(int cityId) {
  Set<Map> districtSet = {};
  List<Map> data = districtData["RECORDS"];
  for (int i = 0; i < data.length; i++) {
    Map item = data[i];
    if (item["city_id"] == cityId) {
      districtSet.add(item);
    }
  }
  return districtSet.toList();
}

int getProvinceIdByName(String name) {
  List<Map> list = quertProviceList();
  for (int i = 0; i < list.length; i++) {
    Map el = list[i];
    if (RegExp(name).hasMatch(el["provicne_name"])) {
      return el["province_id"];
    }
  }
  return null;
}

int getCityIdByName(int provinceId, String name) {
  List<Map> list = queryCityList(provinceId);
  for (int i = 0; i < list.length; i++) {
    Map el = list[i];
    if (RegExp(name).hasMatch(el["city_name"])) {
      return el["city_id"];
    }
  }
  return null;
}

int getDistrictIdByName(int cityId, String name) {
  List<Map> list = queryDistrictList(cityId);
  for (int i = 0; i < list.length; i++) {
    Map el = list[i];
    if (RegExp(name).hasMatch(el["district_name"])) {
      return el["district_id"];
    }
  }
  return null;
}

String getProvinceNameById(int id) {
  List<Map> list = quertProviceList();
  for (int i = 0; i < list.length; i++) {
    Map el = list[i];
    if (id == el["province_id"]) {
      return el["province_name"];
    }
  }
  return null;
}

String getCityNameById(int provinceId, int cityId) {
  List<Map> list = queryCityList(provinceId);
  for (int i = 0; i < list.length; i++) {
    Map el = list[i];
    if (cityId == el["city_id"]) {
      return el["city_name"];
    }
  }
  return null;
}

String getDistrictNameById(int provinceId, int cityId, int districtId) {
  List<Map> list = queryDistrictList(cityId);
  for (int i = 0; i < list.length; i++) {
    Map el = list[i];
    if (districtId == el["district_id"]) {
      return el["district_name"];
    }
  }
  return null;
}

AddressResult queryByName(
    String provinceName, String cityName, String districtName) {
  int provinceId = getProvinceIdByName(provinceName);
  int cityId = getCityIdByName(provinceId, cityName);
  int districtId = getDistrictIdByName(cityId, districtName);
  ProvicneEntity provicneEntity =
      ProvicneEntity(id: provinceId, name: provinceName);
  CityEntity cityEntity = CityEntity(id: cityId, name: cityName);
  DistrictEntity districtEntity =
      DistrictEntity(id: districtId, name: districtName);
  return AddressResult(
      provicne: provicneEntity, city: cityEntity, district: districtEntity);
}

AddressResult queryById(int provinceId, int cityId, int districtId) {
  String provinceName = getProvinceNameById(provinceId);
  String cityName = getProvinceNameById(provinceId);
  String districtName = getProvinceNameById(provinceId);
  ProvicneEntity provicneEntity =
      ProvicneEntity(id: provinceId, name: provinceName);
  CityEntity cityEntity = CityEntity(id: cityId, name: cityName);
  DistrictEntity districtEntity =
      DistrictEntity(id: districtId, name: districtName);
  return AddressResult(
      provicne: provicneEntity, city: cityEntity, district: districtEntity);
}

abstract class AddressEntity {}

class ProvicneEntity extends AddressEntity {
  int id;
  String name;
  ProvicneEntity({@required this.id, @required this.name});
}

class CityEntity extends AddressEntity {
  int id;
  String name;
  CityEntity({@required this.id, @required this.name});
}

class DistrictEntity extends AddressEntity {
  int id;
  String name;
  DistrictEntity({@required this.id, @required this.name});
}

class AddressResult {
  ProvicneEntity provicne;
  CityEntity city;
  DistrictEntity district;

  AddressResult(
      {@required this.provicne, @required this.city, @required this.district});

  AddressResult.fromId(int provinceId, int cityId, int districtId) {
    provicne =
        ProvicneEntity(id: provinceId, name: getProvinceNameById(provinceId));
    city = CityEntity(id: cityId, name: getCityNameById(provinceId, cityId));
    district = DistrictEntity(
        id: districtId,
        name: getDistrictNameById(provinceId, cityId, districtId));
  }

  AddressResult.fromName(
      String provinceName, String cityName, String districtName) {
    int provinceId = getProvinceIdByName(provinceName);
    int cityId = getCityIdByName(provinceId, cityName);
    int districtId = getDistrictIdByName(cityId, districtName);

    provicne = ProvicneEntity(id: provinceId, name: provinceName);
    city = CityEntity(id: cityId, name: getProvinceNameById(cityId));
    district = DistrictEntity(
        id: districtId,
        name: getDistrictNameById(provinceId, cityId, districtId));
  }
}

Future showXCityPicker(BuildContext context, {AddressResult addressResult}) {
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return XCityPicker(
          addressResult: addressResult,
        );
      });
}

class XCityPicker extends StatefulWidget {
  final AddressResult addressResult;
  XCityPicker({
    Key key,
    this.addressResult,
  }) : super(key: key);

  @override
  _XCityPickerState createState() => _XCityPickerState();
}

class _XCityPickerState extends State<XCityPicker> {
  FixedExtentScrollController provinceController;
  FixedExtentScrollController cityController;
  FixedExtentScrollController districtController;

  AddressResult get addressResult => widget.addressResult;

  ProvicneEntity get provinceEntity => addressResult?.provicne;
  CityEntity get cityEntity => addressResult?.city;
  DistrictEntity get districtEntity => addressResult?.district;

  int get defaultProvinceId => provinceEntity?.id;
  int get defaultCityId => cityEntity?.id;
  int get defaultDistrictId => districtEntity?.id;

  ///[targetProvinceId]当前选中的省份id
  int targetProvinceId;

  ///[targetCityId]当前选中的城市id
  int targetCityId;

  ///[targetDistrictId]当前选中的区id
  int targetDistrictId;

  /// [用于构件城市列表]-->StreamBuilder
  StreamController<List<Map>> cityStramController;

  StreamController<List<Map>> distrctStreamController;

  @override
  void initState() {
    super.initState();
    targetProvinceId = provinceEntity?.id ?? 1;
    targetCityId =
        cityEntity?.id ?? queryCityList(targetProvinceId)?.first["city_id"];
    targetDistrictId = districtEntity?.id ??
        queryDistrictList(targetCityId)?.first["district_id"];
    provinceController =
        FixedExtentScrollController(initialItem: _getInitialProviceIndex());
    cityController =
        FixedExtentScrollController(initialItem: _getInitialCityIndex());
    districtController =
        FixedExtentScrollController(initialItem: _getInitialDistrictIndex());

    cityStramController = StreamController<List<Map>>();
    distrctStreamController = StreamController<List<Map>>();
  }

  @override
  void dispose() {
    provinceController?.dispose();
    cityController?.dispose();
    districtController?.dispose();
    cityStramController?.close();
    distrctStreamController?.close();
    super.dispose();
  }

  int _getInitialProviceIndex() {
    if (defaultProvinceId == null) return 0;
    List list = quertProviceList();
    for (int i = 0; i < list.length; i++) {
      Map el = list[i];
      if (el["province_id"] == defaultProvinceId) return i;
    }
    return 0;
  }

  int _getInitialCityIndex() {
    if (defaultCityId == null) return 0;
    List list = queryCityList(defaultProvinceId);
    for (int i = 0; i < list.length; i++) {
      Map el = list[i];
      if (el["city_id"] == defaultCityId) return i;
    }
    return 0;
  }

  int _getInitialDistrictIndex() {
    if (defaultDistrictId == null) return 0;
    List list = queryDistrictList(defaultCityId);
    for (int i = 0; i < list.length; i++) {
      Map el = list[i];
      if (el["district_id"] == defaultDistrictId) return i;
    }
    return 0;
  }

  ProvicneEntity _onProvinceChange(Map map) {
    targetProvinceId = map["province_id"];
    // _updateCityAndDistrcitData(targetProvinceId);
    List<Map> cityList = queryCityList(targetProvinceId);
    targetCityId = cityList?.first["city_id"];
    _onCityChange(cityList?.first);

    List<Map> districtList = queryDistrictList(targetCityId);
    _onDistrictChange(districtList?.first);
    cityStramController.add(cityList);
    distrctStreamController.add(districtList);
    // Future.delayed(Duration(milliseconds: 800), () {
    //   _onDistrictChange(districtList?.first);
    // });
    return ProvicneEntity(id: map["province_id"], name: map["province_name"]);
  }

  // void _updateCityAndDistrcitData(int provinceId) {}

  // void _updateDistrictData(int cityId) {}

  CityEntity _onCityChange(Map map) {
    targetCityId = map["city_id"];
    // _updateDistrictData(targetCityId);
    List<Map> districtList = queryDistrictList(targetCityId);

    distrctStreamController.add(queryDistrictList(targetCityId));
    _onDistrictChange(districtList?.first);
    return CityEntity(id: map["city_id"], name: map["city_name"]);
  }

  DistrictEntity _onDistrictChange(Map map) {
    targetDistrictId = map["district_id"];
    return DistrictEntity(id: map["district_id"], name: map["district_name"]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * .48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text(
                  '取消',
                  style: new TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(
                      context,
                      AddressResult.fromId(
                          targetProvinceId, targetCityId, targetDistrictId));
                },
                child: new Text(
                  '确定',
                  style: new TextStyle(
                      color: const Color(0xFF2196f3), fontSize: 18),
                ),
              ),
            ],
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Expanded(
              child: Row(
            children: [
              Flexible(
                child: _PickerView(
                  key: Key('provice'),
                  itemList: proviceData["RECORDS"],
                  onChange: _onProvinceChange,
                  field: "province_name",
                  controller: provinceController,
                ),
              ),
              Flexible(
                child: StreamBuilder(
                    stream: cityStramController.stream,
                    initialData: queryCityList(targetProvinceId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return _PickerView(
                        key: ValueKey(snapshot.data.toString()),
                        itemList: snapshot.data,
                        onChange: _onCityChange,
                        field: "city_name",
                        controller: cityController,
                      );
                    }),
              ),
              Flexible(
                child: StreamBuilder(
                    stream: distrctStreamController.stream,
                    initialData: queryDistrictList(targetCityId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return _PickerView(
                        key: Key(snapshot.data.toString()),
                        itemList: snapshot.data,
                        onChange: _onDistrictChange,
                        field: "district_name",
                        controller: districtController,
                      );
                    }),
              ),
            ],
          ))
        ],
      ),
    );
  }
}

class _PickerView extends StatefulWidget {
  ///[itemList]选项列表
  final String field;
  final List<Map> itemList;
  final ValueChanged onChange;
  final FixedExtentScrollController controller;
  _PickerView(
      {Key key, this.itemList, this.onChange, this.controller, this.field})
      : super(key: key);

  @override
  __PickerViewState createState() => __PickerViewState();
}

class __PickerViewState extends State<_PickerView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SizedBox.expand(
        child: CupertinoPicker.builder(
            scrollController: widget.controller,
            childCount: widget.itemList.length,
            itemExtent: 40,
            onSelectedItemChanged: (int index) {
              Map map = widget.itemList[index];
              widget.onChange(map);
            },
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Text(widget.itemList[index][widget.field],
                    style: TextStyle(fontSize: 18)),
              );
            }),
      ),
    );
  }
}
