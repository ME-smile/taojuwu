import 'package:taojuwu/models/shop/product_bean.dart';
import 'package:taojuwu/models/zy_response.dart';

class CollectListResp extends ZYResponse<CollectListWrapper> {
  CollectListResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.data = this.valid ? CollectListWrapper.fromJson(json['data']) : null;
  }
}

class CollectListWrapper {
  List<ProductBean> data;
  int totalCount;

  CollectListWrapper.fromJson(Map<String, dynamic> json) {
    data = (json['data'] as List ?? [])
            .map((o) => ProductBean.fromMap(o))
            ?.toList() ??
        [];
    totalCount = json['total_count'];
  }
}
