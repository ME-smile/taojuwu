import 'package:taojuwu/utils/extensions/map_kit.dart';

abstract class JsonKit {
  static dynamic getValueInComplexMap(Map json, List keys) {
    return json.getValueInComplexMap(keys);
  }

  static dynamic getValueByKey(Map json, var key) {
    return json.getValueByKey(key);
  }
}
