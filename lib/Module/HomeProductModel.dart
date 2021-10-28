import 'dart:typed_data';

import 'Product_Model.dart';

class HomeProductModel{

  int id;
  String name;
  Uint8List image;
  List<ProductModel> productIds;
  HomeProductModel({this.id,this.name, this.image, this.productIds});

  factory HomeProductModel.fromJson(Map<String, dynamic> json) =>
      HomeProductModel(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        productIds: json['product_ids'],
      );
}