import 'dart:async';

import 'dart:math';

class CommonKit {
  static Function debounce(Function callback, [int delay = 300]) {
    Timer _debounce;
    Function fn = () {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(Duration(milliseconds: delay), () {
        callback();
      });
    };
    return fn();
  }

  static String getRandomStr({int length: 30}) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String str = '';
    for (int i = 0; i < length; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      str = str + alphabet[Random().nextInt(alphabet.length)];
    }
    return str;
  }
}
