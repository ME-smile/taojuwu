import 'package:taojuwu/models/zy_response.dart';

class WindowGauzeAttr extends ZYResponse<List<WindowGauzeAttrBean>>{
  
   WindowGauzeAttr.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    List _data = json['data'] is List?json['data']:[];
   this.data =
        this.valid ? _data.map((item)=>WindowGauzeAttrBean.fromJson(item)).toList() : null;
  }
 
}


class WindowGauzeAttrBean{
   int id;
   String name;
   String picture;
   double price;
  
  WindowGauzeAttrBean({this.id,this.name,this.price,this.picture});
  
  WindowGauzeAttrBean.fromJson(Map<String,dynamic> json){
    id =  json['id'].runtimeType == int
        ? json['id']
        : int.parse(json['id']);
    name = json['name']??'';
    picture = json['picture']??'';
    price = json['price'].runtimeType == double?json['price'] : double.parse(json['price']);
  }

  Map<String, dynamic> toJson()=>{
    'id':id,
    'name':name,
    'picture':picture,
    'price':price
  };

}