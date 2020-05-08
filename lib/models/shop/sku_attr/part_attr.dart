import 'package:taojuwu/models/zy_response.dart';

class PartAttr extends ZYResponse<List<PartAttrBean>>{
  
   PartAttr.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    List _data = json['data'] is List?json['data']:[];
   this.data =
        this.valid ? _data.map((item)=>PartAttrBean.fromJson(item)).toList() : null;
  }
 
}


class PartAttrBean{
   int id;
   String name;
   String picture;
   double price;
  
  PartAttrBean({this.id,this.name,this.price,this.picture});
  
  PartAttrBean.fromJson(Map<String,dynamic> json){
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