import 'package:taojuwu/models/zy_response.dart';

import 'sku_bean.dart';

class ProductBeanResList extends ZYResponse<ListDataWrapperProductBean> {
  ProductBeanResList.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.data =
        !this.valid ? null : ListDataWrapperProductBean.fromJson(json['data']);
  }
}

class LikedProductList extends ZYResponse<List<ProductBean>> {
  LikedProductList.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.data = this.valid && json['data'] != null
        ? List.of(json['data']).map((v) => ProductBean.fromMap(v)).toList()
        : null;
  }
}

class ListDataWrapperProductBean {
  List<ProductBean> data = List();
  int totalCount;
  int pageCount;

  ListDataWrapperProductBean(this.data, this.totalCount, this.pageCount);

  ListDataWrapperProductBean.fromJson(Map<String, dynamic> json) {
    this.data =
        List.of(json['data']).map((v) => ProductBean.fromMap(v)).toList();
    this.totalCount = json['total_count'];
    this.pageCount = json['page_count'];
  }
}

class ProductBeanRes extends ZYResponse<ProductBeanDataWrapper> {
  ProductBeanRes.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.data =
        !this.valid ? null : ProductBeanDataWrapper.fromMap(json['data']);
  }
}

class ProductBeanDataWrapper {
  String goodsId;
  int skuId;
  ProductBean goodsDetail;

  static ProductBeanDataWrapper fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanDataWrapper dataBean = ProductBeanDataWrapper();
    dataBean.goodsId = map['goods_id'];
    dataBean.skuId = map['sku_id'];
    dataBean.goodsDetail = ProductBean.fromMap(map['goods_detail']);
    return dataBean;
  }

  Map toJson() => {
        "goods_id": goodsId,
        "sku_id": skuId,
        "goods_detail": goodsDetail,
      };
}

/// combo_package : {"promotion_type":"NsCombopackage","promotion_name":"组合套餐","data":[{"id":2,"combo_package_name":"套餐1","combo_package_price":"250.00","goods_id_array":"3,1","is_shelves":1,"shop_id":0,"create_time":1573477595,"update_time":0,"original_price":300,"save_the_price":50,"main_goods":{"goods_id":1,"goods_name":"抱枕","shop_id":0,"category_id":1,"brand_id":0,"group_id_array":"0","promotion_type":0,"goods_type":1,"market_price":"20.00","price":"100.00","promotion_price":"100.00","cost_price":"5.00","point_exchange_type":0,"point_exchange":0,"give_point":0,"is_member_discount":0,"shipping_fee":"0.00","shipping_fee_id":0,"stock":235,"max_buy":0,"min_stock_alarm":2,"clicks":11,"sales":88,"collects":1,"star":5,"evaluates":0,"shares":0,"province_id":11,"city_id":87,"picture":1,"keywords":"","introduction":"","description":"<p><img src=\"/upload/ueditor/image/20191014/2019101405192439894.jpg\" style=\"\" title=\"摩登-详情-_01\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192444451.jpg\" style=\"\" title=\"摩登-详情-_03\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192450311.jpg\" style=\"\" title=\"摩登-详情-_02\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192454931.jpg\" style=\"\" title=\"摩登-详情-_04\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192460995.jpg\" style=\"\" title=\"摩登-详情-_06\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192465529.jpg\" style=\"\" title=\"摩登-详情-_08\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192471111.jpg\" style=\"\" title=\"摩登-详情-_07\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192476384.jpg\" style=\"\" title=\"摩登-详情-_09\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192481589.jpg\" style=\"\" title=\"摩登-详情-_10\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192486659.jpg\" style=\"\" title=\"摩登-详情-_11\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192491764.jpg\" style=\"\" title=\"摩登-详情-_12\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192496790.jpg\" style=\"\" title=\"摩登-详情-_13\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192502026.jpg\" style=\"\" title=\"摩登-详情-_14\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192506173.jpg\" style=\"\" title=\"摩登-详情-_15\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192510261.jpg\" style=\"\" title=\"摩登-详情-_16\"/></p><p><br/></p>","QRcode":"upload/goods_qrcode/goods_qrcode_1.png","code":"","is_stock_visible":1,"is_hot":0,"is_recommend":0,"is_new":0,"is_pre_sale":0,"is_bill":0,"state":1,"sale_date":1571044799,"create_time":1571044799,"update_time":0,"sort":0,"real_sales":65,"brand_name":null,"brand_pic":null,"category_name":"抱枕","pic_cover_micro":"upload/goods/2019101405204986765_THUMB.png","pic_cover_mid":"upload/goods/2019101405204986765_MID.png","pic_cover_small":"upload/goods/2019101405204986765_SMALL.png","shop_name":null,"shop_type":null,"pic_id":1,"upload_type":1,"domain":"","bucket":"","is_open_presell":0,"group_query":[],"sku_list":[{"sku_id":62,"goods_id":1,"sku_name":"BMS1001 169 罗马杆加打孔 ","attr_value_items":"7:30;8:35","attr_value_items_format":"7:30;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":45,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":63,"goods_id":1,"sku_name":"BMS1001 169 罗马杆加双摺 ","attr_value_items":"7:30;8:36","attr_value_items_format":"7:30;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":64,"goods_id":1,"sku_name":"BMS1001 169 轨道加波浪褶 ","attr_value_items":"7:30;8:37","attr_value_items_format":"7:30;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":65,"goods_id":1,"sku_name":"BMS1001 169 轨道加双摺 ","attr_value_items":"7:30;8:38","attr_value_items_format":"7:30;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":66,"goods_id":1,"sku_name":"BMS1002 169 罗马杆加打孔 ","attr_value_items":"7:31;8:35","attr_value_items_format":"7:31;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":67,"goods_id":1,"sku_name":"BMS1002 169 罗马杆加双摺 ","attr_value_items":"7:31;8:36","attr_value_items_format":"7:31;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":68,"goods_id":1,"sku_name":"BMS1002 169 轨道加波浪褶 ","attr_value_items":"7:31;8:37","attr_value_items_format":"7:31;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":69,"goods_id":1,"sku_name":"BMS1002 169 轨道加双摺 ","attr_value_items":"7:31;8:38","attr_value_items_format":"7:31;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":70,"goods_id":1,"sku_name":"BMS1003 169 罗马杆加打孔 ","attr_value_items":"7:32;8:35","attr_value_items_format":"7:32;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":71,"goods_id":1,"sku_name":"BMS1003 169 罗马杆加双摺 ","attr_value_items":"7:32;8:36","attr_value_items_format":"7:32;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":72,"goods_id":1,"sku_name":"BMS1003 169 轨道加波浪褶 ","attr_value_items":"7:32;8:37","attr_value_items_format":"7:32;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405455,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":73,"goods_id":1,"sku_name":"BMS1003 169 轨道加双摺 ","attr_value_items":"7:32;8:38","attr_value_items_format":"7:32;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405455,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":74,"goods_id":1,"sku_name":"BMS2002 229 罗马杆加打孔 ","attr_value_items":"7:33;8:35","attr_value_items_format":"7:33;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405455,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":75,"goods_id":1,"sku_name":"BMS2002 229 罗马杆加双摺 ","attr_value_items":"7:33;8:36","attr_value_items_format":"7:33;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405455,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":76,"goods_id":1,"sku_name":"BMS2002 229 轨道加波浪褶 ","attr_value_items":"7:33;8:37","attr_value_items_format":"7:33;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405459,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":77,"goods_id":1,"sku_name":"BMS2002 229 轨道加双摺 ","attr_value_items":"7:33;8:38","attr_value_items_format":"7:33;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405459,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":78,"goods_id":1,"sku_name":"不要窗纱 罗马杆加打孔 ","attr_value_items":"7:34;8:35","attr_value_items_format":"7:34;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405459,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":79,"goods_id":1,"sku_name":"不要窗纱 罗马杆加双摺 ","attr_value_items":"7:34;8:36","attr_value_items_format":"7:34;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405459,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":80,"goods_id":1,"sku_name":"不要窗纱 轨道加波浪褶 ","attr_value_items":"7:34;8:37","attr_value_items_format":"7:34;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405460,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":81,"goods_id":1,"sku_name":"不要窗纱 轨道加双摺 ","attr_value_items":"7:34;8:38","attr_value_items_format":"7:34;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405460,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"}]},"goods_array":[{"goods_id":3,"goods_name":"褶皱抱枕","shop_id":0,"category_id":1,"brand_id":0,"group_id_array":"0","promotion_type":0,"goods_type":1,"market_price":"50.00","price":"200.00","promotion_price":"200.00","cost_price":"40.00","point_exchange_type":0,"point_exchange":0,"give_point":0,"is_member_discount":0,"shipping_fee":"0.00","shipping_fee_id":0,"stock":3592,"max_buy":0,"min_stock_alarm":10,"clicks":34,"sales":12,"collects":7,"star":5,"evaluates":0,"shares":0,"province_id":11,"city_id":87,"picture":24,"keywords":"","introduction":"","description":"<p><img src=\"/upload/common/2019101405492826535.jpg\"/><img src=\"/upload/common/2019101405492800994.jpg\"/><img src=\"/upload/common/2019101405492785264.jpg\"/><img src=\"/upload/common/2019101405492859871.jpg\"/><img src=\"/upload/common/2019101405492915644.jpg\"/><img src=\"/upload/common/2019101405492889630.jpg\"/><img src=\"/upload/common/2019101405493127114.jpg\"/><img src=\"/upload/common/2019101405492975040.jpg\"/><img src=\"/upload/common/2019101405492943254.jpg\"/><img src=\"/upload/common/2019101405493082999.jpg\"/><img src=\"/upload/common/2019101405493006113.jpg\"/><img src=\"/upload/common/2019101405493034325.jpg\"/><img src=\"/upload/common/2019101405493062136.jpg\"/><img src=\"/upload/common/2019101405493113936.jpg\"/><img src=\"/upload/common/2019101405493203397.jpg\"/><img src=\"/upload/common/2019101405493148939.jpg\"/><img src=\"/upload/common/2019101405493176852.jpg\"/></p>","QRcode":"upload/goods_qrcode/goods_qrcode_3.png","code":"","is_stock_visible":1,"is_hot":0,"is_recommend":0,"is_new":0,"is_pre_sale":0,"is_bill":0,"state":1,"sale_date":1571047026,"create_time":1571047026,"update_time":0,"sort":0,"real_sales":8,"brand_name":null,"brand_pic":null,"category_name":"抱枕","pic_cover_micro":"upload/goods/2019101405490747831_THUMB.jpg","pic_cover_mid":"upload/goods/2019101405490747831_MID.jpg","pic_cover_small":"upload/goods/2019101405490747831_SMALL.jpg","shop_name":null,"shop_type":null,"pic_id":24,"upload_type":1,"domain":"","bucket":"","is_open_presell":0,"group_query":[],"sku_list":[{"sku_id":16,"goods_id":3,"sku_name":"客厅 普通窗型 ","attr_value_items":"3:8;4:20","attr_value_items_format":"3:8;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":92,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":17,"goods_id":3,"sku_name":"客厅 非飘窗 ","attr_value_items":"3:8;4:21","attr_value_items_format":"3:8;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":18,"goods_id":3,"sku_name":"客厅 无窗帘盒 ","attr_value_items":"3:8;4:22","attr_value_items_format":"3:8;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":19,"goods_id":3,"sku_name":"主卧 普通窗型 ","attr_value_items":"3:9;4:20","attr_value_items_format":"3:9;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":20,"goods_id":3,"sku_name":"主卧 非飘窗 ","attr_value_items":"3:9;4:21","attr_value_items_format":"3:9;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":21,"goods_id":3,"sku_name":"主卧 无窗帘盒 ","attr_value_items":"3:9;4:22","attr_value_items_format":"3:9;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":22,"goods_id":3,"sku_name":"次卧 普通窗型 ","attr_value_items":"3:10;4:20","attr_value_items_format":"3:10;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":23,"goods_id":3,"sku_name":"次卧 非飘窗 ","attr_value_items":"3:10;4:21","attr_value_items_format":"3:10;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":24,"goods_id":3,"sku_name":"次卧 无窗帘盒 ","attr_value_items":"3:10;4:22","attr_value_items_format":"3:10;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":25,"goods_id":3,"sku_name":"阳台 普通窗型 ","attr_value_items":"3:11;4:20","attr_value_items_format":"3:11;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":26,"goods_id":3,"sku_name":"阳台 非飘窗 ","attr_value_items":"3:11;4:21","attr_value_items_format":"3:11;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":27,"goods_id":3,"sku_name":"阳台 无窗帘盒 ","attr_value_items":"3:11;4:22","attr_value_items_format":"3:11;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":28,"goods_id":3,"sku_name":"餐厅 普通窗型 ","attr_value_items":"3:12;4:20","attr_value_items_format":"3:12;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":29,"goods_id":3,"sku_name":"餐厅 非飘窗 ","attr_value_items":"3:12;4:21","attr_value_items_format":"3:12;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":30,"goods_id":3,"sku_name":"餐厅 无窗帘盒 ","attr_value_items":"3:12;4:22","attr_value_items_format":"3:12;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":31,"goods_id":3,"sku_name":"书房 普通窗型 ","attr_value_items":"3:13;4:20","attr_value_items_format":"3:13;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":32,"goods_id":3,"sku_name":"书房 非飘窗 ","attr_value_items":"3:13;4:21","attr_value_items_format":"3:13;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":33,"goods_id":3,"sku_name":"书房 无窗帘盒 ","attr_value_items":"3:13;4:22","attr_value_items_format":"3:13;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":34,"goods_id":3,"sku_name":"女儿房 普通窗型 ","attr_value_items":"3:14;4:20","attr_value_items_format":"3:14;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":35,"goods_id":3,"sku_name":"女儿房 非飘窗 ","attr_value_items":"3:14;4:21","attr_value_items_format":"3:14;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":36,"goods_id":3,"sku_name":"女儿房 无窗帘盒 ","attr_value_items":"3:14;4:22","attr_value_items_format":"3:14;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":37,"goods_id":3,"sku_name":"男儿房 普通窗型 ","attr_value_items":"3:15;4:20","attr_value_items_format":"3:15;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":38,"goods_id":3,"sku_name":"男儿房 非飘窗 ","attr_value_items":"3:15;4:21","attr_value_items_format":"3:15;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":39,"goods_id":3,"sku_name":"男儿房 无窗帘盒 ","attr_value_items":"3:15;4:22","attr_value_items_format":"3:15;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":40,"goods_id":3,"sku_name":"卫生间 普通窗型 ","attr_value_items":"3:16;4:20","attr_value_items_format":"3:16;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":41,"goods_id":3,"sku_name":"卫生间 非飘窗 ","attr_value_items":"3:16;4:21","attr_value_items_format":"3:16;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":42,"goods_id":3,"sku_name":"卫生间 无窗帘盒 ","attr_value_items":"3:16;4:22","attr_value_items_format":"3:16;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":43,"goods_id":3,"sku_name":"榻榻米房 普通窗型 ","attr_value_items":"3:17;4:20","attr_value_items_format":"3:17;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":44,"goods_id":3,"sku_name":"榻榻米房 非飘窗 ","attr_value_items":"3:17;4:21","attr_value_items_format":"3:17;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":45,"goods_id":3,"sku_name":"榻榻米房 无窗帘盒 ","attr_value_items":"3:17;4:22","attr_value_items_format":"3:17;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":46,"goods_id":3,"sku_name":"老人房 普通窗型 ","attr_value_items":"3:18;4:20","attr_value_items_format":"3:18;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":47,"goods_id":3,"sku_name":"老人房 非飘窗 ","attr_value_items":"3:18;4:21","attr_value_items_format":"3:18;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":48,"goods_id":3,"sku_name":"老人房 无窗帘盒 ","attr_value_items":"3:18;4:22","attr_value_items_format":"3:18;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419208,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":49,"goods_id":3,"sku_name":"其他 普通窗型 ","attr_value_items":"3:19;4:20","attr_value_items_format":"3:19;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419208,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":50,"goods_id":3,"sku_name":"其他 非飘窗 ","attr_value_items":"3:19;4:21","attr_value_items_format":"3:19;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419208,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":51,"goods_id":3,"sku_name":"其他 无窗帘盒 ","attr_value_items":"3:19;4:22","attr_value_items_format":"3:19;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813875,"update_date":1572419208,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"}]}]}]}

class PromotionDetailPDBean {
  PromotionDetailComboPackageBean comboPackage;

  static PromotionDetailPDBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PromotionDetailPDBean tmpBean = PromotionDetailPDBean();
    tmpBean.comboPackage =
        PromotionDetailComboPackageBean.fromMap(map['combo_package']);
    return tmpBean;
  }

  Map toJson() => {
        "combo_package": comboPackage,
      };
}

/// promotion_type : "NsCombopackage"
/// promotion_name : "组合套餐"
/// data : [{"id":2,"combo_package_name":"套餐1","combo_package_price":"250.00","goods_id_array":"3,1","is_shelves":1,"shop_id":0,"create_time":1573477595,"update_time":0,"original_price":300,"save_the_price":50,"main_goods":{"goods_id":1,"goods_name":"抱枕","shop_id":0,"category_id":1,"brand_id":0,"group_id_array":"0","promotion_type":0,"goods_type":1,"market_price":"20.00","price":"100.00","promotion_price":"100.00","cost_price":"5.00","point_exchange_type":0,"point_exchange":0,"give_point":0,"is_member_discount":0,"shipping_fee":"0.00","shipping_fee_id":0,"stock":235,"max_buy":0,"min_stock_alarm":2,"clicks":11,"sales":88,"collects":1,"star":5,"evaluates":0,"shares":0,"province_id":11,"city_id":87,"picture":1,"keywords":"","introduction":"","description":"<p><img src=\"/upload/ueditor/image/20191014/2019101405192439894.jpg\" style=\"\" title=\"摩登-详情-_01\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192444451.jpg\" style=\"\" title=\"摩登-详情-_03\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192450311.jpg\" style=\"\" title=\"摩登-详情-_02\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192454931.jpg\" style=\"\" title=\"摩登-详情-_04\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192460995.jpg\" style=\"\" title=\"摩登-详情-_06\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192465529.jpg\" style=\"\" title=\"摩登-详情-_08\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192471111.jpg\" style=\"\" title=\"摩登-详情-_07\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192476384.jpg\" style=\"\" title=\"摩登-详情-_09\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192481589.jpg\" style=\"\" title=\"摩登-详情-_10\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192486659.jpg\" style=\"\" title=\"摩登-详情-_11\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192491764.jpg\" style=\"\" title=\"摩登-详情-_12\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192496790.jpg\" style=\"\" title=\"摩登-详情-_13\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192502026.jpg\" style=\"\" title=\"摩登-详情-_14\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192506173.jpg\" style=\"\" title=\"摩登-详情-_15\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192510261.jpg\" style=\"\" title=\"摩登-详情-_16\"/></p><p><br/></p>","QRcode":"upload/goods_qrcode/goods_qrcode_1.png","code":"","is_stock_visible":1,"is_hot":0,"is_recommend":0,"is_new":0,"is_pre_sale":0,"is_bill":0,"state":1,"sale_date":1571044799,"create_time":1571044799,"update_time":0,"sort":0,"real_sales":65,"brand_name":null,"brand_pic":null,"category_name":"抱枕","pic_cover_micro":"upload/goods/2019101405204986765_THUMB.png","pic_cover_mid":"upload/goods/2019101405204986765_MID.png","pic_cover_small":"upload/goods/2019101405204986765_SMALL.png","shop_name":null,"shop_type":null,"pic_id":1,"upload_type":1,"domain":"","bucket":"","is_open_presell":0,"group_query":[],"sku_list":[{"sku_id":62,"goods_id":1,"sku_name":"BMS1001 169 罗马杆加打孔 ","attr_value_items":"7:30;8:35","attr_value_items_format":"7:30;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":45,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":63,"goods_id":1,"sku_name":"BMS1001 169 罗马杆加双摺 ","attr_value_items":"7:30;8:36","attr_value_items_format":"7:30;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":64,"goods_id":1,"sku_name":"BMS1001 169 轨道加波浪褶 ","attr_value_items":"7:30;8:37","attr_value_items_format":"7:30;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":65,"goods_id":1,"sku_name":"BMS1001 169 轨道加双摺 ","attr_value_items":"7:30;8:38","attr_value_items_format":"7:30;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":66,"goods_id":1,"sku_name":"BMS1002 169 罗马杆加打孔 ","attr_value_items":"7:31;8:35","attr_value_items_format":"7:31;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":67,"goods_id":1,"sku_name":"BMS1002 169 罗马杆加双摺 ","attr_value_items":"7:31;8:36","attr_value_items_format":"7:31;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":68,"goods_id":1,"sku_name":"BMS1002 169 轨道加波浪褶 ","attr_value_items":"7:31;8:37","attr_value_items_format":"7:31;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":69,"goods_id":1,"sku_name":"BMS1002 169 轨道加双摺 ","attr_value_items":"7:31;8:38","attr_value_items_format":"7:31;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":70,"goods_id":1,"sku_name":"BMS1003 169 罗马杆加打孔 ","attr_value_items":"7:32;8:35","attr_value_items_format":"7:32;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":71,"goods_id":1,"sku_name":"BMS1003 169 罗马杆加双摺 ","attr_value_items":"7:32;8:36","attr_value_items_format":"7:32;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":72,"goods_id":1,"sku_name":"BMS1003 169 轨道加波浪褶 ","attr_value_items":"7:32;8:37","attr_value_items_format":"7:32;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405455,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":73,"goods_id":1,"sku_name":"BMS1003 169 轨道加双摺 ","attr_value_items":"7:32;8:38","attr_value_items_format":"7:32;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405455,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":74,"goods_id":1,"sku_name":"BMS2002 229 罗马杆加打孔 ","attr_value_items":"7:33;8:35","attr_value_items_format":"7:33;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405455,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":75,"goods_id":1,"sku_name":"BMS2002 229 罗马杆加双摺 ","attr_value_items":"7:33;8:36","attr_value_items_format":"7:33;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405455,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":76,"goods_id":1,"sku_name":"BMS2002 229 轨道加波浪褶 ","attr_value_items":"7:33;8:37","attr_value_items_format":"7:33;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405459,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":77,"goods_id":1,"sku_name":"BMS2002 229 轨道加双摺 ","attr_value_items":"7:33;8:38","attr_value_items_format":"7:33;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405459,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":78,"goods_id":1,"sku_name":"不要窗纱 罗马杆加打孔 ","attr_value_items":"7:34;8:35","attr_value_items_format":"7:34;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405459,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":79,"goods_id":1,"sku_name":"不要窗纱 罗马杆加双摺 ","attr_value_items":"7:34;8:36","attr_value_items_format":"7:34;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405459,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":80,"goods_id":1,"sku_name":"不要窗纱 轨道加波浪褶 ","attr_value_items":"7:34;8:37","attr_value_items_format":"7:34;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405460,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":81,"goods_id":1,"sku_name":"不要窗纱 轨道加双摺 ","attr_value_items":"7:34;8:38","attr_value_items_format":"7:34;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405460,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"}]},"goods_array":[{"goods_id":3,"goods_name":"褶皱抱枕","shop_id":0,"category_id":1,"brand_id":0,"group_id_array":"0","promotion_type":0,"goods_type":1,"market_price":"50.00","price":"200.00","promotion_price":"200.00","cost_price":"40.00","point_exchange_type":0,"point_exchange":0,"give_point":0,"is_member_discount":0,"shipping_fee":"0.00","shipping_fee_id":0,"stock":3592,"max_buy":0,"min_stock_alarm":10,"clicks":34,"sales":12,"collects":7,"star":5,"evaluates":0,"shares":0,"province_id":11,"city_id":87,"picture":24,"keywords":"","introduction":"","description":"<p><img src=\"/upload/common/2019101405492826535.jpg\"/><img src=\"/upload/common/2019101405492800994.jpg\"/><img src=\"/upload/common/2019101405492785264.jpg\"/><img src=\"/upload/common/2019101405492859871.jpg\"/><img src=\"/upload/common/2019101405492915644.jpg\"/><img src=\"/upload/common/2019101405492889630.jpg\"/><img src=\"/upload/common/2019101405493127114.jpg\"/><img src=\"/upload/common/2019101405492975040.jpg\"/><img src=\"/upload/common/2019101405492943254.jpg\"/><img src=\"/upload/common/2019101405493082999.jpg\"/><img src=\"/upload/common/2019101405493006113.jpg\"/><img src=\"/upload/common/2019101405493034325.jpg\"/><img src=\"/upload/common/2019101405493062136.jpg\"/><img src=\"/upload/common/2019101405493113936.jpg\"/><img src=\"/upload/common/2019101405493203397.jpg\"/><img src=\"/upload/common/2019101405493148939.jpg\"/><img src=\"/upload/common/2019101405493176852.jpg\"/></p>","QRcode":"upload/goods_qrcode/goods_qrcode_3.png","code":"","is_stock_visible":1,"is_hot":0,"is_recommend":0,"is_new":0,"is_pre_sale":0,"is_bill":0,"state":1,"sale_date":1571047026,"create_time":1571047026,"update_time":0,"sort":0,"real_sales":8,"brand_name":null,"brand_pic":null,"category_name":"抱枕","pic_cover_micro":"upload/goods/2019101405490747831_THUMB.jpg","pic_cover_mid":"upload/goods/2019101405490747831_MID.jpg","pic_cover_small":"upload/goods/2019101405490747831_SMALL.jpg","shop_name":null,"shop_type":null,"pic_id":24,"upload_type":1,"domain":"","bucket":"","is_open_presell":0,"group_query":[],"sku_list":[{"sku_id":16,"goods_id":3,"sku_name":"客厅 普通窗型 ","attr_value_items":"3:8;4:20","attr_value_items_format":"3:8;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":92,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":17,"goods_id":3,"sku_name":"客厅 非飘窗 ","attr_value_items":"3:8;4:21","attr_value_items_format":"3:8;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":18,"goods_id":3,"sku_name":"客厅 无窗帘盒 ","attr_value_items":"3:8;4:22","attr_value_items_format":"3:8;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":19,"goods_id":3,"sku_name":"主卧 普通窗型 ","attr_value_items":"3:9;4:20","attr_value_items_format":"3:9;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":20,"goods_id":3,"sku_name":"主卧 非飘窗 ","attr_value_items":"3:9;4:21","attr_value_items_format":"3:9;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":21,"goods_id":3,"sku_name":"主卧 无窗帘盒 ","attr_value_items":"3:9;4:22","attr_value_items_format":"3:9;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":22,"goods_id":3,"sku_name":"次卧 普通窗型 ","attr_value_items":"3:10;4:20","attr_value_items_format":"3:10;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":23,"goods_id":3,"sku_name":"次卧 非飘窗 ","attr_value_items":"3:10;4:21","attr_value_items_format":"3:10;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":24,"goods_id":3,"sku_name":"次卧 无窗帘盒 ","attr_value_items":"3:10;4:22","attr_value_items_format":"3:10;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":25,"goods_id":3,"sku_name":"阳台 普通窗型 ","attr_value_items":"3:11;4:20","attr_value_items_format":"3:11;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":26,"goods_id":3,"sku_name":"阳台 非飘窗 ","attr_value_items":"3:11;4:21","attr_value_items_format":"3:11;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":27,"goods_id":3,"sku_name":"阳台 无窗帘盒 ","attr_value_items":"3:11;4:22","attr_value_items_format":"3:11;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":28,"goods_id":3,"sku_name":"餐厅 普通窗型 ","attr_value_items":"3:12;4:20","attr_value_items_format":"3:12;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":29,"goods_id":3,"sku_name":"餐厅 非飘窗 ","attr_value_items":"3:12;4:21","attr_value_items_format":"3:12;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":30,"goods_id":3,"sku_name":"餐厅 无窗帘盒 ","attr_value_items":"3:12;4:22","attr_value_items_format":"3:12;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":31,"goods_id":3,"sku_name":"书房 普通窗型 ","attr_value_items":"3:13;4:20","attr_value_items_format":"3:13;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":32,"goods_id":3,"sku_name":"书房 非飘窗 ","attr_value_items":"3:13;4:21","attr_value_items_format":"3:13;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":33,"goods_id":3,"sku_name":"书房 无窗帘盒 ","attr_value_items":"3:13;4:22","attr_value_items_format":"3:13;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":34,"goods_id":3,"sku_name":"女儿房 普通窗型 ","attr_value_items":"3:14;4:20","attr_value_items_format":"3:14;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":35,"goods_id":3,"sku_name":"女儿房 非飘窗 ","attr_value_items":"3:14;4:21","attr_value_items_format":"3:14;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":36,"goods_id":3,"sku_name":"女儿房 无窗帘盒 ","attr_value_items":"3:14;4:22","attr_value_items_format":"3:14;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":37,"goods_id":3,"sku_name":"男儿房 普通窗型 ","attr_value_items":"3:15;4:20","attr_value_items_format":"3:15;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":38,"goods_id":3,"sku_name":"男儿房 非飘窗 ","attr_value_items":"3:15;4:21","attr_value_items_format":"3:15;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":39,"goods_id":3,"sku_name":"男儿房 无窗帘盒 ","attr_value_items":"3:15;4:22","attr_value_items_format":"3:15;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":40,"goods_id":3,"sku_name":"卫生间 普通窗型 ","attr_value_items":"3:16;4:20","attr_value_items_format":"3:16;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":41,"goods_id":3,"sku_name":"卫生间 非飘窗 ","attr_value_items":"3:16;4:21","attr_value_items_format":"3:16;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":42,"goods_id":3,"sku_name":"卫生间 无窗帘盒 ","attr_value_items":"3:16;4:22","attr_value_items_format":"3:16;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":43,"goods_id":3,"sku_name":"榻榻米房 普通窗型 ","attr_value_items":"3:17;4:20","attr_value_items_format":"3:17;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":44,"goods_id":3,"sku_name":"榻榻米房 非飘窗 ","attr_value_items":"3:17;4:21","attr_value_items_format":"3:17;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":45,"goods_id":3,"sku_name":"榻榻米房 无窗帘盒 ","attr_value_items":"3:17;4:22","attr_value_items_format":"3:17;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":46,"goods_id":3,"sku_name":"老人房 普通窗型 ","attr_value_items":"3:18;4:20","attr_value_items_format":"3:18;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":47,"goods_id":3,"sku_name":"老人房 非飘窗 ","attr_value_items":"3:18;4:21","attr_value_items_format":"3:18;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":48,"goods_id":3,"sku_name":"老人房 无窗帘盒 ","attr_value_items":"3:18;4:22","attr_value_items_format":"3:18;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419208,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":49,"goods_id":3,"sku_name":"其他 普通窗型 ","attr_value_items":"3:19;4:20","attr_value_items_format":"3:19;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419208,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":50,"goods_id":3,"sku_name":"其他 非飘窗 ","attr_value_items":"3:19;4:21","attr_value_items_format":"3:19;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419208,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":51,"goods_id":3,"sku_name":"其他 无窗帘盒 ","attr_value_items":"3:19;4:22","attr_value_items_format":"3:19;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813875,"update_date":1572419208,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"}]}]}]

class PromotionDetailComboPackageBean {
  String promotionType;
  String promotionName;
  List<PromotionDetailComboDataBean> data;

  static PromotionDetailComboPackageBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PromotionDetailComboPackageBean bean = PromotionDetailComboPackageBean();
    bean.promotionType = map['promotion_type'];
    bean.promotionName = map['promotion_name'];
    bean.data = List()
      ..addAll((map['data'] as List ?? [])
          .map((o) => PromotionDetailComboDataBean.fromMap(o)));
    return bean;
  }

  Map toJson() => {
        "promotion_type": promotionType,
        "promotion_name": promotionName,
        "data": data,
      };
}

/// id : 2
/// combo_package_name : "套餐1"
/// combo_package_price : "250.00"
/// goods_id_array : "3,1"
/// is_shelves : 1
/// shop_id : 0
/// create_time : 1573477595
/// update_time : 0
/// original_price : 300
/// save_the_price : 50
/// main_goods : {"goods_id":1,"goods_name":"抱枕","shop_id":0,"category_id":1,"brand_id":0,"group_id_array":"0","promotion_type":0,"goods_type":1,"market_price":"20.00","price":"100.00","promotion_price":"100.00","cost_price":"5.00","point_exchange_type":0,"point_exchange":0,"give_point":0,"is_member_discount":0,"shipping_fee":"0.00","shipping_fee_id":0,"stock":235,"max_buy":0,"min_stock_alarm":2,"clicks":11,"sales":88,"collects":1,"star":5,"evaluates":0,"shares":0,"province_id":11,"city_id":87,"picture":1,"keywords":"","introduction":"","description":"<p><img src=\"/upload/ueditor/image/20191014/2019101405192439894.jpg\" style=\"\" title=\"摩登-详情-_01\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192444451.jpg\" style=\"\" title=\"摩登-详情-_03\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192450311.jpg\" style=\"\" title=\"摩登-详情-_02\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192454931.jpg\" style=\"\" title=\"摩登-详情-_04\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192460995.jpg\" style=\"\" title=\"摩登-详情-_06\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192465529.jpg\" style=\"\" title=\"摩登-详情-_08\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192471111.jpg\" style=\"\" title=\"摩登-详情-_07\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192476384.jpg\" style=\"\" title=\"摩登-详情-_09\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192481589.jpg\" style=\"\" title=\"摩登-详情-_10\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192486659.jpg\" style=\"\" title=\"摩登-详情-_11\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192491764.jpg\" style=\"\" title=\"摩登-详情-_12\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192496790.jpg\" style=\"\" title=\"摩登-详情-_13\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192502026.jpg\" style=\"\" title=\"摩登-详情-_14\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192506173.jpg\" style=\"\" title=\"摩登-详情-_15\"/></p><p><img src=\"/upload/ueditor/image/20191014/2019101405192510261.jpg\" style=\"\" title=\"摩登-详情-_16\"/></p><p><br/></p>","QRcode":"upload/goods_qrcode/goods_qrcode_1.png","code":"","is_stock_visible":1,"is_hot":0,"is_recommend":0,"is_new":0,"is_pre_sale":0,"is_bill":0,"state":1,"sale_date":1571044799,"create_time":1571044799,"update_time":0,"sort":0,"real_sales":65,"brand_name":null,"brand_pic":null,"category_name":"抱枕","pic_cover_micro":"upload/goods/2019101405204986765_THUMB.png","pic_cover_mid":"upload/goods/2019101405204986765_MID.png","pic_cover_small":"upload/goods/2019101405204986765_SMALL.png","shop_name":null,"shop_type":null,"pic_id":1,"upload_type":1,"domain":"","bucket":"","is_open_presell":0,"group_query":[],"sku_list":[{"sku_id":62,"goods_id":1,"sku_name":"BMS1001 169 罗马杆加打孔 ","attr_value_items":"7:30;8:35","attr_value_items_format":"7:30;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":45,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":63,"goods_id":1,"sku_name":"BMS1001 169 罗马杆加双摺 ","attr_value_items":"7:30;8:36","attr_value_items_format":"7:30;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":64,"goods_id":1,"sku_name":"BMS1001 169 轨道加波浪褶 ","attr_value_items":"7:30;8:37","attr_value_items_format":"7:30;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":65,"goods_id":1,"sku_name":"BMS1001 169 轨道加双摺 ","attr_value_items":"7:30;8:38","attr_value_items_format":"7:30;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":66,"goods_id":1,"sku_name":"BMS1002 169 罗马杆加打孔 ","attr_value_items":"7:31;8:35","attr_value_items_format":"7:31;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":67,"goods_id":1,"sku_name":"BMS1002 169 罗马杆加双摺 ","attr_value_items":"7:31;8:36","attr_value_items_format":"7:31;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":68,"goods_id":1,"sku_name":"BMS1002 169 轨道加波浪褶 ","attr_value_items":"7:31;8:37","attr_value_items_format":"7:31;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":69,"goods_id":1,"sku_name":"BMS1002 169 轨道加双摺 ","attr_value_items":"7:31;8:38","attr_value_items_format":"7:31;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816479,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":70,"goods_id":1,"sku_name":"BMS1003 169 罗马杆加打孔 ","attr_value_items":"7:32;8:35","attr_value_items_format":"7:32;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":71,"goods_id":1,"sku_name":"BMS1003 169 罗马杆加双摺 ","attr_value_items":"7:32;8:36","attr_value_items_format":"7:32;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405454,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":72,"goods_id":1,"sku_name":"BMS1003 169 轨道加波浪褶 ","attr_value_items":"7:32;8:37","attr_value_items_format":"7:32;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405455,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":73,"goods_id":1,"sku_name":"BMS1003 169 轨道加双摺 ","attr_value_items":"7:32;8:38","attr_value_items_format":"7:32;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405455,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":74,"goods_id":1,"sku_name":"BMS2002 229 罗马杆加打孔 ","attr_value_items":"7:33;8:35","attr_value_items_format":"7:33;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405455,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":75,"goods_id":1,"sku_name":"BMS2002 229 罗马杆加双摺 ","attr_value_items":"7:33;8:36","attr_value_items_format":"7:33;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405455,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":76,"goods_id":1,"sku_name":"BMS2002 229 轨道加波浪褶 ","attr_value_items":"7:33;8:37","attr_value_items_format":"7:33;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405459,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":77,"goods_id":1,"sku_name":"BMS2002 229 轨道加双摺 ","attr_value_items":"7:33;8:38","attr_value_items_format":"7:33;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405459,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":78,"goods_id":1,"sku_name":"不要窗纱 罗马杆加打孔 ","attr_value_items":"7:34;8:35","attr_value_items_format":"7:34;8:35","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405459,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":79,"goods_id":1,"sku_name":"不要窗纱 罗马杆加双摺 ","attr_value_items":"7:34;8:36","attr_value_items_format":"7:34;8:36","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405459,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":80,"goods_id":1,"sku_name":"不要窗纱 轨道加波浪褶 ","attr_value_items":"7:34;8:37","attr_value_items_format":"7:34;8:37","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405460,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":81,"goods_id":1,"sku_name":"不要窗纱 轨道加双摺 ","attr_value_items":"7:34;8:38","attr_value_items_format":"7:34;8:38","market_price":"0.00","price":"100.00","promote_price":"100.00","cost_price":"0.00","stock":10,"picture":0,"code":"","QRcode":"","create_date":1571816480,"update_date":1572405460,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"}]}
/// goods_array : [{"goods_id":3,"goods_name":"褶皱抱枕","shop_id":0,"category_id":1,"brand_id":0,"group_id_array":"0","promotion_type":0,"goods_type":1,"market_price":"50.00","price":"200.00","promotion_price":"200.00","cost_price":"40.00","point_exchange_type":0,"point_exchange":0,"give_point":0,"is_member_discount":0,"shipping_fee":"0.00","shipping_fee_id":0,"stock":3592,"max_buy":0,"min_stock_alarm":10,"clicks":34,"sales":12,"collects":7,"star":5,"evaluates":0,"shares":0,"province_id":11,"city_id":87,"picture":24,"keywords":"","introduction":"","description":"<p><img src=\"/upload/common/2019101405492826535.jpg\"/><img src=\"/upload/common/2019101405492800994.jpg\"/><img src=\"/upload/common/2019101405492785264.jpg\"/><img src=\"/upload/common/2019101405492859871.jpg\"/><img src=\"/upload/common/2019101405492915644.jpg\"/><img src=\"/upload/common/2019101405492889630.jpg\"/><img src=\"/upload/common/2019101405493127114.jpg\"/><img src=\"/upload/common/2019101405492975040.jpg\"/><img src=\"/upload/common/2019101405492943254.jpg\"/><img src=\"/upload/common/2019101405493082999.jpg\"/><img src=\"/upload/common/2019101405493006113.jpg\"/><img src=\"/upload/common/2019101405493034325.jpg\"/><img src=\"/upload/common/2019101405493062136.jpg\"/><img src=\"/upload/common/2019101405493113936.jpg\"/><img src=\"/upload/common/2019101405493203397.jpg\"/><img src=\"/upload/common/2019101405493148939.jpg\"/><img src=\"/upload/common/2019101405493176852.jpg\"/></p>","QRcode":"upload/goods_qrcode/goods_qrcode_3.png","code":"","is_stock_visible":1,"is_hot":0,"is_recommend":0,"is_new":0,"is_pre_sale":0,"is_bill":0,"state":1,"sale_date":1571047026,"create_time":1571047026,"update_time":0,"sort":0,"real_sales":8,"brand_name":null,"brand_pic":null,"category_name":"抱枕","pic_cover_micro":"upload/goods/2019101405490747831_THUMB.jpg","pic_cover_mid":"upload/goods/2019101405490747831_MID.jpg","pic_cover_small":"upload/goods/2019101405490747831_SMALL.jpg","shop_name":null,"shop_type":null,"pic_id":24,"upload_type":1,"domain":"","bucket":"","is_open_presell":0,"group_query":[],"sku_list":[{"sku_id":16,"goods_id":3,"sku_name":"客厅 普通窗型 ","attr_value_items":"3:8;4:20","attr_value_items_format":"3:8;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":92,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":17,"goods_id":3,"sku_name":"客厅 非飘窗 ","attr_value_items":"3:8;4:21","attr_value_items_format":"3:8;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":18,"goods_id":3,"sku_name":"客厅 无窗帘盒 ","attr_value_items":"3:8;4:22","attr_value_items_format":"3:8;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":19,"goods_id":3,"sku_name":"主卧 普通窗型 ","attr_value_items":"3:9;4:20","attr_value_items_format":"3:9;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":20,"goods_id":3,"sku_name":"主卧 非飘窗 ","attr_value_items":"3:9;4:21","attr_value_items_format":"3:9;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":21,"goods_id":3,"sku_name":"主卧 无窗帘盒 ","attr_value_items":"3:9;4:22","attr_value_items_format":"3:9;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":22,"goods_id":3,"sku_name":"次卧 普通窗型 ","attr_value_items":"3:10;4:20","attr_value_items_format":"3:10;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":23,"goods_id":3,"sku_name":"次卧 非飘窗 ","attr_value_items":"3:10;4:21","attr_value_items_format":"3:10;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813873,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":24,"goods_id":3,"sku_name":"次卧 无窗帘盒 ","attr_value_items":"3:10;4:22","attr_value_items_format":"3:10;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419206,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":25,"goods_id":3,"sku_name":"阳台 普通窗型 ","attr_value_items":"3:11;4:20","attr_value_items_format":"3:11;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":26,"goods_id":3,"sku_name":"阳台 非飘窗 ","attr_value_items":"3:11;4:21","attr_value_items_format":"3:11;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":27,"goods_id":3,"sku_name":"阳台 无窗帘盒 ","attr_value_items":"3:11;4:22","attr_value_items_format":"3:11;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":28,"goods_id":3,"sku_name":"餐厅 普通窗型 ","attr_value_items":"3:12;4:20","attr_value_items_format":"3:12;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":29,"goods_id":3,"sku_name":"餐厅 非飘窗 ","attr_value_items":"3:12;4:21","attr_value_items_format":"3:12;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":30,"goods_id":3,"sku_name":"餐厅 无窗帘盒 ","attr_value_items":"3:12;4:22","attr_value_items_format":"3:12;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":31,"goods_id":3,"sku_name":"书房 普通窗型 ","attr_value_items":"3:13;4:20","attr_value_items_format":"3:13;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":32,"goods_id":3,"sku_name":"书房 非飘窗 ","attr_value_items":"3:13;4:21","attr_value_items_format":"3:13;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":33,"goods_id":3,"sku_name":"书房 无窗帘盒 ","attr_value_items":"3:13;4:22","attr_value_items_format":"3:13;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":34,"goods_id":3,"sku_name":"女儿房 普通窗型 ","attr_value_items":"3:14;4:20","attr_value_items_format":"3:14;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":35,"goods_id":3,"sku_name":"女儿房 非飘窗 ","attr_value_items":"3:14;4:21","attr_value_items_format":"3:14;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":36,"goods_id":3,"sku_name":"女儿房 无窗帘盒 ","attr_value_items":"3:14;4:22","attr_value_items_format":"3:14;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":37,"goods_id":3,"sku_name":"男儿房 普通窗型 ","attr_value_items":"3:15;4:20","attr_value_items_format":"3:15;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":38,"goods_id":3,"sku_name":"男儿房 非飘窗 ","attr_value_items":"3:15;4:21","attr_value_items_format":"3:15;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":39,"goods_id":3,"sku_name":"男儿房 无窗帘盒 ","attr_value_items":"3:15;4:22","attr_value_items_format":"3:15;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":40,"goods_id":3,"sku_name":"卫生间 普通窗型 ","attr_value_items":"3:16;4:20","attr_value_items_format":"3:16;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":41,"goods_id":3,"sku_name":"卫生间 非飘窗 ","attr_value_items":"3:16;4:21","attr_value_items_format":"3:16;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":42,"goods_id":3,"sku_name":"卫生间 无窗帘盒 ","attr_value_items":"3:16;4:22","attr_value_items_format":"3:16;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":43,"goods_id":3,"sku_name":"榻榻米房 普通窗型 ","attr_value_items":"3:17;4:20","attr_value_items_format":"3:17;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":44,"goods_id":3,"sku_name":"榻榻米房 非飘窗 ","attr_value_items":"3:17;4:21","attr_value_items_format":"3:17;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":45,"goods_id":3,"sku_name":"榻榻米房 无窗帘盒 ","attr_value_items":"3:17;4:22","attr_value_items_format":"3:17;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":46,"goods_id":3,"sku_name":"老人房 普通窗型 ","attr_value_items":"3:18;4:20","attr_value_items_format":"3:18;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":47,"goods_id":3,"sku_name":"老人房 非飘窗 ","attr_value_items":"3:18;4:21","attr_value_items_format":"3:18;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419207,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":48,"goods_id":3,"sku_name":"老人房 无窗帘盒 ","attr_value_items":"3:18;4:22","attr_value_items_format":"3:18;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419208,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":49,"goods_id":3,"sku_name":"其他 普通窗型 ","attr_value_items":"3:19;4:20","attr_value_items_format":"3:19;4:20","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419208,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":50,"goods_id":3,"sku_name":"其他 非飘窗 ","attr_value_items":"3:19;4:21","attr_value_items_format":"3:19;4:21","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813874,"update_date":1572419208,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"},{"sku_id":51,"goods_id":3,"sku_name":"其他 无窗帘盒 ","attr_value_items":"3:19;4:22","attr_value_items_format":"3:19;4:22","market_price":"0.00","price":"200.00","promote_price":"200.00","cost_price":"0.00","stock":100,"picture":0,"code":"","QRcode":"","create_date":1571813875,"update_date":1572419208,"weight":"0.00","volume":"0.00","sku_img_array":"","extend_json":"[]"}]}]

class PromotionDetailComboDataBean {
  int id;
  String comboPackageName;
  String comboPackagePrice;
  String goodsIdArray;
  int isShelves;
  int shopId;
  int createTime;
  int updateTime;
  int originalPrice;
  int saveThePrice;
  ProductBean mainGoods;
  List<ProductBean> goodsArray;

  static PromotionDetailComboDataBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PromotionDetailComboDataBean dataBean = PromotionDetailComboDataBean();
    dataBean.id = map['id'];
    dataBean.comboPackageName = map['combo_package_name'];
    dataBean.comboPackagePrice = map['combo_package_price'];
    dataBean.goodsIdArray = map['goods_id_array'];
    dataBean.isShelves = map['is_shelves'];
    dataBean.shopId = map['shop_id'];
    dataBean.createTime = map['create_time'];
    dataBean.updateTime = map['update_time'];
    dataBean.originalPrice = map['original_price'];
    dataBean.saveThePrice = map['save_the_price'];
    dataBean.mainGoods = ProductBean.fromMap(map['main_goods']);
    dataBean.goodsArray = List()
      ..addAll((map['goods_array'] as List ?? [])
          .map((o) => ProductBean.fromMap(o)));
    return dataBean;
  }

  Map toJson() => {
        "id": id,
        "combo_package_name": comboPackageName,
        "combo_package_price": comboPackagePrice,
        "goods_id_array": goodsIdArray,
        "is_shelves": isShelves,
        "shop_id": shopId,
        "create_time": createTime,
        "update_time": updateTime,
        "original_price": originalPrice,
        "save_the_price": saveThePrice,
        "main_goods": mainGoods,
        "goods_array": goodsArray,
      };
}

class ProductBean {
  int goodsId;
  String goodsName;
  var measureId;
  int shopId;
  int categoryId;
  int categoryId1;
  int categoryId2;
  int categoryId3;
  int brandId;
  String groupIdArray;
  int promotionType;
  int promoteId;
  int goodsType;
  double marketPrice;
  double price;
  String earnestMoney;
  String promotionPrice;
  String costPrice;
  int pointExchangeType;
  int pointExchange;
  int givePoint;
  int isMemberDiscount;
  String shippingFee;
  int shippingFeeId;
  int stock;
  int maxBuy;
  int clicks;
  int minStockAlarm;
  int sales;
  int collects;
  int star;
  int evaluates;
  int shares;
  int provinceId;
  int cityId;
  int picture;
  String keywords;
  String introduction;
  String description;
  String qRcode;
  String code;
  int isStockVisible;
  int isHot;
  int goodsSpecialType;
  int isCollect;
  int isRecommend;
  int isNew;
  int isPreSale;
  int isBill;
  int state;
  int sort;
  String imgIdArray;
  String skuImgArray;
  int matchPoint;
  int matchRatio;
  int realSales;
  int goodsAttributeId;
  String goodsSpecFormat;
  String goodsWeight;
  String goodsVolume;
  int shippingFeeType;
  dynamic extendCategoryId;
  dynamic extendCategoryId1;
  dynamic extendCategoryId2;
  dynamic extendCategoryId3;
  int supplierId;
  int saleDate;
  int createTime;
  int updateTime;
  int minBuy;
  int isVirtual;
  int productionDate;
  String shelfLife;
  String goodsVideoAddress;
  String pcCustomTemplate;
  String wapCustomTemplate;
  int maxUsePoint;
  int isOpenPresell;
  int presellTime;
  int presellDay;
  int presellDeliveryType;
  String presellPrice;
  String goodsUnit;
  int decimalReservationNumber;
  int integralGiveType;
  int type;
  int bargainId;
  int groupId;
  List<dynamic> goodsGroupList;
  List<ProductBeanSpecListBean> specList;
  List<SkuBean> skuList;
  List<ProductBeanGoodsImageBean> goodsImgList;
  List<ProductBeanParentCategoryNameBean> parentCategoryName;
  String goodsAttributeName;
  List<dynamic> goodsAttributeList;
  int integralBalance;
  int currentTime;
  List<dynamic> goodsLadderPreferentialList;
  List<dynamic> goodsCouponList;
  String mansongName;
  dynamic promotionDetail;
  ProductBeanGoodsPurchaseRestrictionBean goodsPurchaseRestriction;
  String baoyouName;
  List<ProductBeanShippingFeeNameBean> shippingFeeName;
  String skuName;
  int skuId;
  String memberPrice;
  List<ProductBeanGoodsImageBean> imgList;
  int skuPicture;
  String picCoverMicro;
  String categoryName;

  bool get isPromotionGoods => !(marketPrice == price && marketPrice != 0);
  String get picCoverMid {
    return imgList?.isEmpty == true ? '' : imgList?.first?.picCover;
  }

  List<ProductBeanSpecValueBean> getSpecListByName(String name) {
    if (this.specList == null) return [];

    for (var item in this.specList) {
      if (name == item.specName) {
        return item.value;
      }
    }
    return [];
  }

  static ProductBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBean tmpBean = ProductBean();
    tmpBean.goodsId = map['goods_id'];
    tmpBean.goodsName = map['goods_name'];
    tmpBean.shopId = map['shop_id'];
    tmpBean.categoryId = map['category_id'];
    tmpBean.categoryId1 = map['category_id_1'];
    tmpBean.categoryId2 = map['category_id_2'];
    tmpBean.categoryId3 = map['category_id_3'];
    tmpBean.brandId = map['brand_id'];
    tmpBean.groupIdArray = map['group_id_array'];
    tmpBean.promotionType = map['promotion_type'];
    tmpBean.promoteId = map['promote_id'];
    tmpBean.goodsType = map['goods_type'];
    tmpBean.marketPrice = map['market_price'].runtimeType == double
        ? map['market_price']
        : double.parse(map['market_price'] ?? '0.00');
    tmpBean.price = map['price'].runtimeType == double
        ? map['price']
        : double.parse(map['price'] ?? '0.00');
    tmpBean.earnestMoney = map['earnest_money'];
    tmpBean.promotionPrice = map['promotion_price'];
    tmpBean.costPrice = map['cost_price'];
    tmpBean.pointExchangeType = map['point_exchange_type'];
    tmpBean.pointExchange = map['point_exchange'];
    tmpBean.givePoint = map['give_point'];
    tmpBean.isMemberDiscount = map['is_member_discount'];
    tmpBean.shippingFee = map['shipping_fee'];
    tmpBean.shippingFeeId = map['shipping_fee_id'];
    tmpBean.stock = map['stock'];
    tmpBean.maxBuy = map['max_buy'];
    tmpBean.clicks = map['clicks'];
    tmpBean.minStockAlarm = map['min_stock_alarm'];
    tmpBean.sales = map['sales'];
    tmpBean.collects = map['collects'];
    tmpBean.star = map['star'];
    tmpBean.evaluates = map['evaluates'];
    tmpBean.shares = map['shares'];
    tmpBean.provinceId = map['province_id'];
    tmpBean.cityId = map['city_id'];
    tmpBean.picture = map['picture'];
    tmpBean.keywords = map['keywords'];
    tmpBean.introduction = map['introduction'];
    tmpBean.description = map['description'];
    tmpBean.qRcode = map['QRcode'];
    tmpBean.code = map['code'];
    tmpBean.isStockVisible = map['is_stock_visible'];
    tmpBean.isHot = map['is_hot'];
    tmpBean.goodsSpecialType = map['goods_special_type'];

    tmpBean.isCollect = map['is_collect'];

    tmpBean.isRecommend = map['is_recommend'];
    tmpBean.isNew = map['is_new'];
    tmpBean.isPreSale = map['is_pre_sale'];
    tmpBean.isBill = map['is_bill'];
    tmpBean.state = map['state'];
    tmpBean.sort = map['sort'];
    tmpBean.imgIdArray = map['img_id_array'];
    tmpBean.skuImgArray = map['sku_img_array'];
    tmpBean.matchPoint = map['match_point'];
    tmpBean.matchRatio = map['match_ratio'];
    tmpBean.realSales = map['real_sales'];
    tmpBean.goodsAttributeId = map['goods_attribute_id'];
    tmpBean.goodsSpecFormat = map['goods_spec_format'];
    tmpBean.goodsWeight = map['goods_weight'];
    tmpBean.goodsVolume = map['goods_volume'];
    tmpBean.shippingFeeType = map['shipping_fee_type'];
    tmpBean.extendCategoryId = map['extend_category_id'];
    tmpBean.extendCategoryId1 = map['extend_category_id_1'];
    tmpBean.extendCategoryId2 = map['extend_category_id_2'];
    tmpBean.extendCategoryId3 = map['extend_category_id_3'];
    tmpBean.supplierId = map['supplier_id'];
    tmpBean.saleDate = map['sale_date'];
    tmpBean.createTime = map['create_time'];
    tmpBean.updateTime = map['update_time'];
    tmpBean.minBuy = map['min_buy'];
    tmpBean.isVirtual = map['is_virtual'];
    tmpBean.productionDate = map['production_date'];
    tmpBean.shelfLife = map['shelf_life'];
    tmpBean.goodsVideoAddress = map['goods_video_address'];
    tmpBean.pcCustomTemplate = map['pc_custom_template'];
    tmpBean.wapCustomTemplate = map['wap_custom_template'];
    tmpBean.maxUsePoint = map['max_use_point'];
    tmpBean.isOpenPresell = map['is_open_presell'];
    tmpBean.presellTime = map['presell_time'];
    tmpBean.presellDay = map['presell_day'];
    tmpBean.presellDeliveryType = map['presell_delivery_type'];
    tmpBean.presellPrice = map['presell_price'];
    tmpBean.goodsUnit = map['goods_unit'];
    tmpBean.decimalReservationNumber = map['decimal_reservation_number'];
    tmpBean.integralGiveType = map['integral_give_type'];
    tmpBean.type = map['type'];
    tmpBean.bargainId = map['bargain_id'];
    tmpBean.groupId = map['group_id'];
    tmpBean.goodsGroupList = map['goods_group_list'];
    tmpBean.specList = List()
      ..addAll((map['spec_list'] as List ?? [])
          .map((o) => ProductBeanSpecListBean.fromMap(o)));
    tmpBean.skuList = List()
      ..addAll((map['sku_list'] as List ?? []).map((o) => SkuBean.fromJson(o)));
    tmpBean.goodsImgList = List()
      ..addAll((map['goods_img_list'] as List ?? [])
          .map((o) => ProductBeanGoodsImageBean.fromMap(o)));
    tmpBean.parentCategoryName = List()
      ..addAll((map['parent_category_name'] as List ?? [])
          .map((o) => ProductBeanParentCategoryNameBean.fromMap(o)));
    tmpBean.goodsAttributeName = map['goods_attribute_name'];
    tmpBean.goodsAttributeList = map['goods_attribute_list'];
    tmpBean.integralBalance = map['integral_balance'];
    tmpBean.currentTime = map['current_time'];
    tmpBean.goodsLadderPreferentialList = map['goods_ladder_preferential_list'];
    tmpBean.goodsCouponList = map['goods_coupon_list'];
    tmpBean.mansongName = map['mansong_name'];
    tmpBean.promotionDetail = map['promotion_detail'];
    tmpBean.goodsPurchaseRestriction =
        ProductBeanGoodsPurchaseRestrictionBean.fromMap(
            map['goods_purchase_restriction']);
    tmpBean.baoyouName = map['baoyou_name'];
    tmpBean.shippingFeeName = List()
      ..addAll((map['shipping_fee_name'] as List ?? [])
          .map((o) => ProductBeanShippingFeeNameBean.fromMap(o)));
    tmpBean.skuName = map['sku_name'];
    tmpBean.skuId = map['sku_id'];
    tmpBean.memberPrice = map['member_price'];
    tmpBean.imgList = List()
      ..addAll((map['img_list'] as List ?? [])
          .map((o) => ProductBeanGoodsImageBean.fromMap(o)));
    tmpBean.skuPicture = map['sku_picture'];
    tmpBean?.picCoverMicro = map['pic_cover_micro'];
    tmpBean?.categoryName = map['category_name'];
    return tmpBean;
  }

  Map toJson() => {
        "goods_id": goodsId,
        "goods_name": goodsName,
        "shop_id": shopId,
        "category_id": categoryId,
        "category_id_1": categoryId1,
        "category_id_2": categoryId2,
        "category_id_3": categoryId3,
        "brand_id": brandId,
        "group_id_array": groupIdArray,
        "promotion_type": promotionType,
        "promote_id": promoteId,
        "goods_type": goodsType,
        "market_price": marketPrice,
        "price": price,
        "earnest_money": earnestMoney,
        "promotion_price": promotionPrice,
        "cost_price": costPrice,
        "point_exchange_type": pointExchangeType,
        "point_exchange": pointExchange,
        "give_point": givePoint,
        "is_member_discount": isMemberDiscount,
        "shipping_fee": shippingFee,
        "shipping_fee_id": shippingFeeId,
        "stock": stock,
        "max_buy": maxBuy,
        "clicks": clicks,
        "min_stock_alarm": minStockAlarm,
        "sales": sales,
        "collects": collects,
        "star": star,
        "evaluates": evaluates,
        "shares": shares,
        "province_id": provinceId,
        "city_id": cityId,
        "picture": picture,
        "keywords": keywords,
        "introduction": introduction,
        "description": description,
        "QRcode": qRcode,
        "code": code,
        "is_stock_visible": isStockVisible,
        "is_hot": isHot,
        "is_collect": isCollect,
        "is_recommend": isRecommend,
        "is_new": isNew,
        "is_pre_sale": isPreSale,
        "is_bill": isBill,
        "state": state,
        "sort": sort,
        "img_id_array": imgIdArray,
        "sku_img_array": skuImgArray,
        "match_point": matchPoint,
        "match_ratio": matchRatio,
        "real_sales": realSales,
        "goods_attribute_id": goodsAttributeId,
        "goods_spec_format": goodsSpecFormat,
        "goods_weight": goodsWeight,
        "goods_volume": goodsVolume,
        "shipping_fee_type": shippingFeeType,
        "extend_category_id": extendCategoryId,
        "extend_category_id_1": extendCategoryId1,
        "extend_category_id_2": extendCategoryId2,
        "extend_category_id_3": extendCategoryId3,
        "supplier_id": supplierId,
        "sale_date": saleDate,
        "create_time": createTime,
        "update_time": updateTime,
        "min_buy": minBuy,
        "is_virtual": isVirtual,
        "production_date": productionDate,
        "shelf_life": shelfLife,
        "goods_video_address": goodsVideoAddress,
        "pc_custom_template": pcCustomTemplate,
        "wap_custom_template": wapCustomTemplate,
        "max_use_point": maxUsePoint,
        "is_open_presell": isOpenPresell,
        "presell_time": presellTime,
        "presell_day": presellDay,
        "presell_delivery_type": presellDeliveryType,
        "presell_price": presellPrice,
        "goods_unit": goodsUnit,
        "decimal_reservation_number": decimalReservationNumber,
        "integral_give_type": integralGiveType,
        "type": type,
        "bargain_id": bargainId,
        "group_id": groupId,
        "goods_group_list": goodsGroupList,
        "spec_list": specList,
        "sku_list": skuList,
        "goods_img_list": goodsImgList,
        "parent_category_name": parentCategoryName,
        "goods_attribute_name": goodsAttributeName,
        "goods_attribute_list": goodsAttributeList,
        "integral_balance": integralBalance,
        "current_time": currentTime,
        "goods_ladder_preferential_list": goodsLadderPreferentialList,
        "goods_coupon_list": goodsCouponList,
        "mansong_name": mansongName,
        "promotion_detail": promotionDetail,
        "goods_purchase_restriction": goodsPurchaseRestriction,
        "baoyou_name": baoyouName,
        "shipping_fee_name": shippingFeeName,
        "sku_name": skuName,
        "sku_id": skuId,
        "member_price": memberPrice,
        "img_list": imgList,
        "sku_picture": skuPicture,
        "goods_special_type": goodsSpecialType
      };
}

/// pic_id : 18
/// shop_id : 0
/// album_id : 30
/// is_wide : 0
/// pic_name : "2019060303043746744"
/// pic_tag : "商品主图2"
/// pic_cover : "upload/goods/2019060303043746744.jpg"
/// pic_size : "61496"
/// pic_spec : "350,200"
/// pic_cover_big : "upload/goods/2019060303043746744_BIG.jpg"
/// pic_size_big : "19025"
/// pic_spec_big : "700*700"
/// pic_cover_mid : "upload/goods/2019060303043746744_MID.jpg"
/// pic_size_mid : "17166"
/// pic_spec_mid : "360*360"
/// pic_cover_small : "upload/goods/2019060303043746744_SMALL.jpg"
/// pic_size_small : "9161"
/// pic_spec_small : "240*240"
/// pic_cover_micro : "upload/goods/2019060303043746744_THUMB.jpg"
/// pic_size_micro : "1622"
/// pic_spec_micro : "60*60"
/// upload_time : 1559545477
/// upload_type : 1
/// domain : ""
/// bucket : ""

class ProductBeanGoodsImageBean {
  int picId;
  int shopId;
  int albumId;
  int isWide;
  String picName;
  String picTag;
  String picCover;
  String picSize;
  String picSpec;
  String picCoverBig;
  String picSizeBig;
  String picSpecBig;
  String picCoverMid;
  String picSizeMid;
  String picSpecMid;
  String picCoverSmall;
  String picSizeSmall;
  String picSpecSmall;
  String picCoverMicro;
  String picSizeMicro;
  String picSpecMicro;
  int uploadTime;
  int uploadType;
  String domain;
  String bucket;

  static ProductBeanGoodsImageBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanGoodsImageBean tempBean = ProductBeanGoodsImageBean();
    tempBean.picId = map['pic_id'];
    tempBean.shopId = map['shop_id'];
    tempBean.albumId = map['album_id'];
    tempBean.isWide = map['is_wide'];
    tempBean.picName = map['pic_name'];
    tempBean.picTag = map['pic_tag'];
    tempBean.picCover = map['pic_cover'];
    tempBean.picSize = map['pic_size'];
    tempBean.picSpec = map['pic_spec'];
    tempBean.picCoverBig = map['pic_cover_big'];
    tempBean.picSizeBig = map['pic_size_big'];
    tempBean.picSpecBig = map['pic_spec_big'];
    tempBean.picCoverMid = map['pic_cover_mid'];
    tempBean.picSizeMid = map['pic_size_mid'];
    tempBean.picSpecMid = map['pic_spec_mid'];
    tempBean.picCoverSmall = map['pic_cover_small'];
    tempBean.picSizeSmall = map['pic_size_small'];
    tempBean.picSpecSmall = map['pic_spec_small'];
    tempBean.picCoverMicro = map['pic_cover_micro'];
    tempBean.picSizeMicro = map['pic_size_micro'];
    tempBean.picSpecMicro = map['pic_spec_micro'];
    tempBean.uploadTime = map['upload_time'];
    tempBean.uploadType = map['upload_type'];
    tempBean.domain = map['domain'];
    tempBean.bucket = map['bucket'];
    return tempBean;
  }

  Map toJson() => {
        "pic_id": picId,
        "shop_id": shopId,
        "album_id": albumId,
        "is_wide": isWide,
        "pic_name": picName,
        "pic_tag": picTag,
        "pic_cover": picCover,
        "pic_size": picSize,
        "pic_spec": picSpec,
        "pic_cover_big": picCoverBig,
        "pic_size_big": picSizeBig,
        "pic_spec_big": picSpecBig,
        "pic_cover_mid": picCoverMid,
        "pic_size_mid": picSizeMid,
        "pic_spec_mid": picSpecMid,
        "pic_cover_small": picCoverSmall,
        "pic_size_small": picSizeSmall,
        "pic_spec_small": picSpecSmall,
        "pic_cover_micro": picCoverMicro,
        "pic_size_micro": picSizeMicro,
        "pic_spec_micro": picSpecMicro,
        "upload_time": uploadTime,
        "upload_type": uploadType,
        "domain": domain,
        "bucket": bucket,
      };
}

class ProductBeanShippingFeeNameBean {
  int coId;
  String companyName;
  int isDefault;
  int expressFee;

  static ProductBeanShippingFeeNameBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanShippingFeeNameBean bean = ProductBeanShippingFeeNameBean();
    bean.coId = map['co_id'];
    bean.companyName = map['company_name'];
    bean.isDefault = map['is_default'];
    bean.expressFee = map['express_fee'];
    return bean;
  }

  Map toJson() => {
        "co_id": coId,
        "company_name": companyName,
        "is_default": isDefault,
        "express_fee": expressFee,
      };
}

class ProductBeanGoodsPurchaseRestrictionBean {
  int code;
  String message;
  int value;

  static ProductBeanGoodsPurchaseRestrictionBean fromMap(
      Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanGoodsPurchaseRestrictionBean bean =
        ProductBeanGoodsPurchaseRestrictionBean();
    bean.code = map['code'];
    bean.message = map['message'];
    bean.value = map['value'];
    return bean;
  }

  Map toJson() => {
        "code": code,
        "message": message,
        "value": value,
      };
}

class ProductBeanSpecListBean {
  String specName;
  String specId;
  String specShowType;
  List<ProductBeanSpecValueBean> value;
  int sort;

  static ProductBeanSpecListBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanSpecListBean bean = ProductBeanSpecListBean();
    bean.specName = map['spec_name'];
    bean.specId = map['spec_id'];
    bean.specShowType = map['spec_show_type'].toString();
    bean.value = List()
      ..addAll((map['value'] as List ?? [])
          .map((o) => ProductBeanSpecValueBean.fromMap(o)));
    bean.sort = map['sort'];
    return bean;
  }

  Map toJson() => {
        "spec_name": specName,
        "spec_id": specId,
        "spec_show_type": specShowType,
        "value": value,
        "sort": sort,
      };
}

/// spec_id : "5"
/// spec_name : "幔头"
/// spec_value_name : "BMS1001 169"
/// spec_value_id : "23"
/// spec_show_type : "1"
/// spec_value_data : ""
/// selected : true
/// disabled : false

class ProductBeanSpecValueBean {
  String specId;
  String specName;
  String specValueName;
  String specValueId;
  String specShowType;
  String specValueData;
  bool selected;
  bool disabled;

  static ProductBeanSpecValueBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanSpecValueBean valueBean = ProductBeanSpecValueBean();
    valueBean.specId = map['spec_id'];
    valueBean.specName = map['spec_name'];
    valueBean.specValueName = map['spec_value_name'];
    valueBean.specValueId = map['spec_value_id'];
    valueBean.specShowType = map['spec_show_type'].toString();
    valueBean.specValueData = map['spec_value_data'];
    valueBean.selected = map['selected'];
    valueBean.disabled = map['disabled'];
    return valueBean;
  }

  Map toJson() => {
        "spec_id": specId,
        "spec_name": specName,
        "spec_value_name": specValueName,
        "spec_value_id": specValueId,
        "spec_show_type": specShowType,
        "spec_value_data": specValueData,
        "selected": selected,
        "disabled": disabled,
      };
}

class ProductBeanParentCategoryNameBean {
  int categoryId;
  String categoryName;
  int pid;
  int level;

  static ProductBeanParentCategoryNameBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBeanParentCategoryNameBean bean =
        ProductBeanParentCategoryNameBean();
    bean.categoryId = map['category_id'];
    bean.categoryName = map['category_name'];
    bean.pid = map['pid'];
    bean.level = map['level'];
    return bean;
  }

  Map toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "pid": pid,
        "level": level,
      };
}
