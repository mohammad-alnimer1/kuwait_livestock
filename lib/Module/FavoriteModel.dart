import 'dart:typed_data';

class FavoriteModel{
  int idproductFavorite;

  FavoriteModel ({this.idproductFavorite,});
  FavoriteModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    idproductFavorite = map['id'];

  }
  toJson() {
    return {
      'id':idproductFavorite,
      };
  }

}