import 'dart:convert';

import 'dart:typed_data';

class CategoryModel{
  int id;
  String name;
  Uint8List images;
   CategoryModel({this.id, this.name, this.images});
  //
  // CategoryModel.fromJson(Map<String, dynamic> json)
  //     : id = json['id'],
  //       name = json['name'],
  //       images = json['images'];
}