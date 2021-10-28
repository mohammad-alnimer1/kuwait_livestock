import 'dart:typed_data';

class CartProductModel {
  int idproductCart;
  String name;
  double price;
  Uint8List image;
  double qnty;

  CartProductModel({this.name, this.price, this.qnty, this.image,
    this.idproductCart
  });
  CartProductModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    idproductCart = map['product_id'];
    name = map['name'];
    image = map['image'];
    price = map['price_unit'];
    qnty = map['product_uom_qty'];
  }
  toJson() {
    return {
     'product_id':idproductCart,
      'name': name,
      'price_unit': price,
     'image': image,
      'product_uom_qty': qnty};
  }
  toJson1() {
    return {
     'product_id':idproductCart,
      'name': name,
      'price_unit': price,
      'product_uom_qty': qnty};
  }
}
