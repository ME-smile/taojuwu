/*
 * @Description: eventbus
 * @Author: iamsmiling
 * @Date: 2020-11-20 09:31:39
 * @LastEditTime: 2020-11-22 13:34:13
 */
import 'package:rxdart/rxdart.dart';

class EventBus {
  BehaviorSubject _behaviorSubject;

  BehaviorSubject get behaviorSubject => _behaviorSubject;

  EventBus({bool sync = false})
      : _behaviorSubject = BehaviorSubject(sync: sync);
  on<T>() {
    if (T == dynamic) {
      return _behaviorSubject.stream;
    } else {
      return _behaviorSubject.stream.where((event) => event is T).cast<T>();
    }
  }

  void fire(event) {
    _behaviorSubject.add(event);
  }

  void destroy() {
    _behaviorSubject.close();
  }
}
