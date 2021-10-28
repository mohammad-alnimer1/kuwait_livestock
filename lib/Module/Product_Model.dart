import 'dart:typed_data';

class ProductModel{
  int id;
  String name;
  String description;
  double qty;
  double price;
  Uint8List images;
  var message_ids;
  ToMap(){
    var map =Map<String ,dynamic>();
    map['id']=id;
    map['name']=name;
    map['description']=description;
    map['qty_available']=qty;
    map['lst_price']=price;
    map['image_1920']=images;
  }
  fromMap(){

  }

}