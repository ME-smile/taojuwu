class TargetRoute {
  TargetRoute._internal();
  static TargetRoute _instance = TargetRoute._internal();
  factory TargetRoute() {
    return _instance;
  }

  static TargetRoute get instance => _instance;
  String route;

  void setRoute(String route) {
    _instance.route = route;
  }
}
