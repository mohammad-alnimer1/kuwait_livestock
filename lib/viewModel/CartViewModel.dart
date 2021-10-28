
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kuwait_livestock/Module/Cart_product_Model.dart';
import 'package:kuwait_livestock/database/CartDatabase.dart';

class CartViewModel extends GetxController{
  ValueNotifier<bool> get loading =>_loading;
  ValueNotifier<bool>_loading =ValueNotifier(false);
  //
  // List<CartProductModel> _cartproductmodel=[];
  // List<CartProductModel> get cartproductmodel=>_cartproductmodel;
  // getALLProduct()async{
  //
  //   var dbHelper =CartDatabase.db;
  //   _cartproductmodel=  await dbHelper.getALLProduct();
  //
  //     print(_cartproductmodel.length.toString());
  //   update();
  //
  // }

  // addProduct(CartProductModel cartproductmodel)async{
  //   var dbHelper =CartDatabase.db;
  //   await dbHelper.insert(cartproductmodel);
  //   update();
  // }
}