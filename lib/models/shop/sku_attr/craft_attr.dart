import 'package:taojuwu/models/zy_response.dart';

class CraftAttr extends ZYResponse<List<CraftAttrBean>>{
  
   CraftAttr.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    List _data = json['data'] is List?json['data']:[];
   this.data =
        this.valid ? _data.map((item)=>CraftAttrBean.fromJson(item)).toList() : null;
  }
 
}


class CraftAttrBean{
   int id;
   String name;
   String picture;
   double price;
  
  CraftAttrBean({this.id,this.name,this.price,this.picture});
  
  CraftAttrBean.fromJson(Map<String,dynamic> json){
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