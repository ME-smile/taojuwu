import 'package:flutter/foundation.dart';

class CountModel {
  int count;
  double price;
  CountModel({@required this.count, this.price});

  double get totalPrice => count * price;
}
