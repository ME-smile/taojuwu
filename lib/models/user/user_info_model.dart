import 'package:taojuwu/application.dart';

class UserInfo {
  String _token;
  int shopId;
  String shopName;
  String nickName;
  String userTel;
  String address;

  UserInfo._singleton();

  static final UserInfo _instance = UserInfo._singleton();
  static UserInfo get instance {
    return _instance;
  }

  String get token {
    return Application.sp.getString('token') ?? '';
  }

  set token(String token) {
    _token = token;
  }

  void saveUserInfo(Map<String, dynamic> json) {
    _token = json['token'];
    shopName = json['shop_name'];
    shopId = json['shop_id'];
    nickName = json['nick_name'];
    userTel = json['user_tel'];
    address = json['address'];
    Application.sp.setString('token', _token);
    Application.sp.setString('shopName', shopName);
    Application.sp.setInt('shopId', shopId);
    Application.sp.setString('userTel', userTel);
    Application.sp.setString('address', address);
    Application.sp.setString('nickName', nickName);
  }
}
