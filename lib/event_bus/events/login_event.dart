/*
*
*@author iamsmiling
*@create_time 2020/9/24 4:35 PM
*@description 登录事件 --->在登录成功时需要保存token---> 为所有网络请求带上token
*/

class LoginEvent {
  final int code; // 0或1 0代表logout 1代表login

  LoginEvent(this.code);
}
