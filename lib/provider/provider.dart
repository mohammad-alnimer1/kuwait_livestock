import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kuwait_livestock/AppHelper/networking.dart';
import 'package:kuwait_livestock/Module/AddressModel.dart';
import 'package:kuwait_livestock/Module/Cart_product_Model.dart';
import 'package:kuwait_livestock/Module/Category_Model.dart';
import 'package:kuwait_livestock/Module/CommentModel.dart';
import 'package:kuwait_livestock/Module/FavoriteModel.dart';
import 'package:kuwait_livestock/Module/Product_Model.dart';
import 'package:kuwait_livestock/Module/RatingModel.dart';
import 'package:kuwait_livestock/api/Api.dart';
import 'package:kuwait_livestock/database/CartDatabase.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AppProvider with ChangeNotifier {
  List<CartProductModel> _cartproductmodel=[];
  List<CartProductModel> get cartproductmodel=>_cartproductmodel;

  getALLProduct() async {
    var dbHelper = CartDatabase.db;
    _cartproductmodel = await dbHelper.getALLProduct();
    getTotalPrice();
    print(_cartproductmodel.length.toString());
  }


  double get totalprice => _totalPrice;
  double _totalPrice = 0.0;


  getTotalPrice(){
    for (int i = 0; i < _cartproductmodel.length; i++) {
      _totalPrice += (_cartproductmodel[i].price * _cartproductmodel[i].qnty);
    }
  }


  addProduct(CartProductModel cartproductmodel)async{
    for(int i =0; i<_cartproductmodel.length;i++){
      if(_cartproductmodel[i].idproductCart==cartproductmodel.idproductCart){
        return;
      }
    }
    var dbHelper =CartDatabase.db;
    await dbHelper.insert(cartproductmodel);
    _cartproductmodel.add(cartproductmodel);
    _totalPrice += (cartproductmodel.price * cartproductmodel.qnty);
    notifyListeners();

  }

  deleteItem(int index)async{
    var dbHelper =CartDatabase.db;
    await dbHelper.deleteitem(index);
    notifyListeners();
  }



  increaseQnty(int index){
    _cartproductmodel[index].qnty++;
    _totalPrice += (cartproductmodel[index].price);
    notifyListeners();
  }

  decreaseQnty(int index){
    _cartproductmodel[index].qnty--;
    _totalPrice -= (cartproductmodel[index].price);
    notifyListeners();
  }



  Future Registrationform(String nameController,String  emailController, String passwordController,String phoneController) async {
    var result;
    var _data;
    var url = "http://kuwaitlivestock.com:5000/registration_partners";

        var data = {
          "name": nameController,
          "login": emailController,
          "password": passwordController,
          "phone": phoneController
        };



        dynamic response = await http.post(url, body: data);

        print(response.body);

        if (response.statusCode == 200) {

        String jsonsDataString = response.body;

        _data = jsonDecode(jsonsDataString.replaceAll("'", '"'));

        print('hi hi hi hi hihi hi ${_data}');

        notifyListeners();
        result = {'result': 'success', 'message': 'Login Successful', };
    }  else {

          notifyListeners();
          result = {
            'status': 'failure',
            'message': json.decode(response.body)['Login failure']
          };
        }
    return result;
  }

  //
  // List<AddressModel> AddressList = List<AddressModel>();
  // String userIdSP;
  // Future<dynamic> getAllAddresses() async {
  //   notifyListeners();
  //
  //   SharedPreferences pre = await SharedPreferences.getInstance();
  //
  //   userIdSP = pre.getString('user_id');
  //   final NetworkHelper networkHelper = NetworkHelper(Api().baseURL + 'GetAddress?user_id=${userIdSP}');
  //   final Productdata = await networkHelper.getdata();
  //
  //   Productdata.forEach((data) {
  //     var model = AddressModel();
  //     model.Addressid = data['id'];
  //     print('hi hi hi hih ih hi hi id ${data}');
  //     model.AddressName = data['name_address'];
  //     model.country_id = data['country_id'];
  //     model.state_id = data['state_id'];
  //     model.building_address = data['building_address'];
  //     model.note_address = data['note_address'];
  //     model.latitude = data['latitude'];
  //     model.longitude = data['longitude'];
  //     model.street = data['street'];
  //
  //       print(Productdata);
  //        AddressList.add(model);
  //
  //   });
  //
  //
  // }

  List<FavoriteModel> _Favoritemodel=[];
  List<FavoriteModel> get Favoritemodel=>_Favoritemodel;


  addToFavorite(FavoriteModel addFavoritemodel)async{
    for(int i =0; i<_Favoritemodel.length;i++){
      if(_Favoritemodel[i].idproductFavorite==addFavoritemodel.idproductFavorite){
        return;
      }
    }
    var dbHelper =CartDatabase.db;
    await dbHelper.insertFavorite(addFavoritemodel);
    _Favoritemodel.add(addFavoritemodel);
    notifyListeners();
  }

  getALLFav() async {
    var dbHelper = CartDatabase.db;
    _Favoritemodel = await dbHelper.getAllFavorite();

    print(_Favoritemodel.length.toString());
    notifyListeners();
  }



var TermsandConditions;

  Future<void> getTermsandConditions()async{

    final  NetworkHelper networkHelper =NetworkHelper("${Api().baseURL+'TermsandConditions'}");
    TermsandConditions = await networkHelper.getdata();
    TermsandConditions['TermsandConditions'];

    // print(CategoryList[1].name);
    notifyListeners();
  }








  List<ProductModel> ProductList = List<ProductModel>();

  int id;
  // Uint8List bytes;
  Future<dynamic> getProduct(id) async {
    final NetworkHelper networkHelper =
    NetworkHelper('http://kuwaitlivestock.com:5000/categ_ids?categ_id=$id');
    final Productdata = await networkHelper.getdata();
    Productdata.forEach((data) {
      var model = ProductModel();
      model.id = data['id'];
      print('hi hi hi hih ih hi hi id ${id}');
      model.name = data['name'];
      model.price = data['lst_price'];
      //  model.price=data['image_1920'];
      // Uint8List.view(model.price=data['image_1920']);// bytes = base64.decode(_base64);
      model.images = base64.decode(data['image_1920']);

        ProductList.add(model);
      print(ProductList[0].message_ids);

    });
  }



  List <CategoryModel> CategoryList =List<CategoryModel>();


  Future<void> getCateg(  )async{

    final  NetworkHelper networkHelper =NetworkHelper("${Api().baseURL+'categ_ids'}");

    final Categorydata = await networkHelper.getdata();

    Categorydata.forEach((data){

      var model= CategoryModel();
      model.id=data['id'];
      model.name=data['name'];
      model.images =base64.decode(data['image']);

          CategoryList.add(model);

    });

    // print(CategoryList[1].name);

  }



  double rat;
  List <CommentModel> CommentList= List<CommentModel>();
  List <RatingModel> RatingList= List<RatingModel>();
  var Categorydata;
  Future<void> getproductDetails(var id) async {
    final NetworkHelper networkHelper = NetworkHelper(
        "${Api().baseURL + 'product_ids?product_id=${id}'}");
    Categorydata = await networkHelper.getdata();

    final commentList = Categorydata[0]['message_ids'];

    commentList.forEach((data){
      var model= CommentModel();
      model.author_id=data['author_id'];
      model.body=data['body'];
      model.date =data['date'];
      model.rate_product_ids =data['rate_product_ids'];

          CommentList.add(model);

    });
    final rating= Categorydata[0]['rate_product_ids'];
    rating.forEach((data){
      var model= RatingModel();
      model.Rating=data['rate'];

          RatingList.add(model);

    });

  }


}