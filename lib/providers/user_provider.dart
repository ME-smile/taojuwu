import 'package:flutter/cupertino.dart';
import 'package:taojuwu/application.dart';

import 'package:taojuwu/models/user/user_info_model.dart';

class UserProvider with ChangeNotifier {
  final UserInfo userInfo = UserInfo.instance;

  List<String> _productHistory = [];
  List<String> _clientHistory = [];
  List<String> _orderHistory = [];

  String _token;

  String get token => _token;
  bool get isLogin => Application.sp.getString('token')?.isNotEmpty == true;
  List<String> get productHistory => _productHistory;
  List<String> get orderHistory => _orderHistory;
  List<String> get clientHistory => _clientHistory;
  void saveToken(String token) async {
    _token = token;
    await Application.sp.setString('token', token);
    notifyListeners();
  }

  set token(String token) {
    _token = token;
    notifyListeners();
  }

  void logOut() {
    clearUserInfo();
    clearClientInfo();
    notifyListeners();
  }

  initUserInfo() {
    userInfo.token = Application.sp.getString('token');
    userInfo.shopId = Application.sp.getInt('shopId');
    userInfo.shopName = Application.sp.getString('shopName');
    userInfo.userTel = Application.sp.getString('userTel');
    userInfo.address = Application.sp.getString('address');
    userInfo.nickName = Application.sp.getString('nickName');
  }

  clearUserInfo() {
    Application.sp.remove('token');
    Application.sp.remove('shopId');
    Application.sp.remove('shopName');
    Application.sp.remove('userTel');
    Application.sp.remove('address');
    Application.sp.remove('nickName');
  }

  clearClientInfo() {
    Application.sp.remove('clientName');
    Application.sp.remove('clientTel');
    Application.sp.remove('clientAddress');
    Application.sp.remove('clientId');
    // Application.sp.remove('productHistory');
  }

  String get productHistoryText => _productHistory?.join(',');
  String get clientHistoryText => _clientHistory?.join(',');
  String get orderHistoryText => _orderHistory?.join(',');
  void saveProductHistory() {
    Application.sp.setString('productHistory', productHistoryText);
  }

  void addProductHistory(String text) {
    if (_productHistory.contains(text)) return;
    _productHistory.add(text);
    saveProductHistory();
    notifyListeners();
  }

  void loadProductHistory() {
    _productHistory =
        Application.sp.getString('productHistory')?.split(',') ?? [];
  }

  void clearProductHistory() {
    Application.sp.remove('productHistory');
    _productHistory.clear();
    notifyListeners();
  }

  void addOrderHistory(String text) {
    if (_orderHistory.contains(text)) return;
    _orderHistory.add(text);
    saveOrderHistory();
    notifyListeners();
  }

  void saveOrderHistory() {
    Application.sp.setString('orderHistory', orderHistoryText);
  }

  void loadOrderHistory() {
    _orderHistory = Application.sp.getString('orderHistory')?.split(',') ?? [];
  }

  void clearOrderHistory() {
    Application.sp.remove('orderHistory');
    _orderHistory.clear();
    notifyListeners();
  }

  void addClientHistory(String text) {
    if (_clientHistory.contains(text)) return;
    _clientHistory.add(text);
    saveClientHistory();
    notifyListeners();
  }

  void saveClientHistory() {
    Application.sp.setString('clientHistory', clientHistoryText);
  }

  void loadClientHistory() {
    _clientHistory =
        Application.sp.getString('clientHistory')?.split(',') ?? [];
  }

  void clearClientHistory() {
    Application.sp.remove('clientHistory');
    _clientHistory.clear();
    notifyListeners();
  }
}
