import 'package:flutter/widgets.dart';
import 'package:kuwait_livestock/AppHelper/Constants.dart';
import 'package:kuwait_livestock/Module/Cart_product_Model.dart';
import 'package:kuwait_livestock/Module/FavoriteModel.dart';
import 'package:kuwait_livestock/Module/Product_Model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class CartDatabase{

  CartDatabase._();
  static final CartDatabase db =CartDatabase._();
  static Database _database;
  Future <Database>get database async{
    if (_database!=null) return _database;
    _database= await initDb();
    return _database;

  }

  // $columnimage TEXT NOT NULL
  //     String query='''
  //       CREATE TABLE (
  //       TEXT NOT NULL ,
  //       TEXT NOT NULL ,
  //        DOUBLE NOT NULL ,
  //       )
  //       ''';

  initDb()async{
    String path =join(await getDatabasesPath(),'CartProduct.db');
    return await openDatabase(path,version: 5,
        onCreate: (Database db,int version)async{
      await db.execute("CREATE TABLE $tableCartProduct("
          "$columnProductId INTEGER NOT NULL,"
          "$columnName TEXT NOT NULL,"
          "$columnimage TEXT NOT NULL,"
          "$columnqnty DOUBLE NOT NULL,"
          "$columnprice DOUBLE NOT NULL"
          ")");

      await db.execute("CREATE TABLE $tableFavoriteProduct("
          "$columnFavoriteId INTEGER NOT NULL"
          ")");

    });
  }
  Future<List<FavoriteModel>> getAllFavorite()async{
    var dbClient= await database;
    List<Map> maps= await dbClient.query(tableFavoriteProduct);
    List<FavoriteModel> list =maps.isNotEmpty? maps.map((Favoriteproduct) => FavoriteModel.fromJson(Favoriteproduct)).toList():[];
    return list;
  }
  insertFavorite(FavoriteModel model)async{
    var dbClient= await database;
    await dbClient.insert(tableFavoriteProduct, model.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);
  }














 Future<List<CartProductModel>> getALLProduct()async{
    var dbClient= await database;
    List<Map> maps= await dbClient.query(tableCartProduct);
    List<CartProductModel> list =maps.isNotEmpty? maps.map((product) => CartProductModel.fromJson(product)).toList():[];
    return list;
  }
  insert(CartProductModel model)async{
    var dbClient= await database;
    await dbClient.insert(tableCartProduct, model.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  UpdateProduct(CartProductModel model)async{
    var dbClient=await database;
    return await dbClient.update(tableCartProduct, model.toJson(),
    where: '$columnProductId = ?',whereArgs: [model.idproductCart]
    );
  }
  Future<void>deleteitem(int id)async{
    var dbClient=await database;
    return await dbClient.delete(tableCartProduct,where: '$columnProductId = ?',whereArgs: [id]);
  }
}