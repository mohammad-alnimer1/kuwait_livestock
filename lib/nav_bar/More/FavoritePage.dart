import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/AppHelper/networking.dart';
import 'package:kuwait_livestock/Module/Cart_product_Model.dart';
import 'package:kuwait_livestock/Module/FavoriteModel.dart';
import 'package:kuwait_livestock/Module/Product_Model.dart';
import 'package:kuwait_livestock/api/Api.dart';
import 'package:kuwait_livestock/database/CartDatabase.dart';
import 'package:kuwait_livestock/product/ProductDetails.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;

class FavoritPage extends StatefulWidget {
  @override
  _FavoritPageState createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  // List<FavoriteModel> _Favoritemodel = [];
  // List<FavoriteModel> get Favoritemodel => _Favoritemodel;
  //
  // getALLFavorite() async {
  //   var dbHelper = CartDatabase.db;
  //   _Favoritemodel = await dbHelper.getAllFavorite();
  //
  //   print(_Favoritemodel[0].idproductFavorite);
  //
  // }

  bool loading = true;


  List<ProductModel> ProductList = List<ProductModel>();
  int id;
  Uint8List bytes;
  // Future<dynamic> getProduct() async {
  //   // ProductList=[];
  //   // print("*****"+id);
  //   final NetworkHelper networkHelper =
  //       NetworkHelper(Api().baseURL + 'GetProductsByIds');//مثlets try to remove id from request
  //   final Productdata = await networkHelper.getdata();
  //
  //   Productdata.forEach((data) {
  //     var model = ProductModel();
  //     model.id = data['id'];
  //     print('hi hi hi hih ih hi hi id ${id}');
  //     model.name = data['name'];
  //     model.price = data['lst_price'];
  //     model.qty = data['qty_available'];
  //
  //      model.price=data['image_1920'];
  //     Uint8List.view(model.price=data['image_1920']);// bytes = base64.decode(_base64);
  //     model.images = base64.decode(data['image_1920']);
  //     ProductList.add(model);
  //
  //    setState(() {
  //       print(Productdata);
  //       print(model.name);
  //       ProductList.add(ProductList[0]);
  //     });
  //   });
  // }


  List<String> ProdectIDs=[];
  var UseEmail;
  List _data;


  @override
  void initState() {

    super.initState();
    ChangePasswordFun();
    // getpref();

  }

  //
  // List name = [];
  // getpref() async {
  //   SharedPreferences pre = await SharedPreferences.getInstance();
  //   name = pre.getStringList('Listid');
  //   // print(name.indexWhere(element));
  //   Map<String, dynamic> map = {};
  //
  //   name.forEach((element) {
  //     //map.update("id${i}", (value) => element);
  //    /* map["id${i}"] = element;
  //     i++;
  //     print(name);*/
  //     print(element+"/////////////");
  //
  //   });
  //
  // }

  Future ChangePasswordFun() async {
    // show_loading(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    ProdectIDs= preferences.getStringList('Listid');

    print('0000000000$ProdectIDs');
    print(ProdectIDs.join(' ,'));
    UseEmail= preferences.getString('login');
     Map<String, dynamic> requestPayload = {
      "product_ids":ProdectIDs.join(' ,'),//ProdectIDs.toString(),
     //"login": UseEmail.toString(),
    };
    var url = "http://kuwaitlivestock.com:5000/GetProductsByIds";
    dynamic response = await http.post(url, body: requestPayload);
    //print(response.body);
    String jsonsDataString = response.body;
    _data =jsonDecode(jsonsDataString.replaceAll("'",'"').replaceAll("False", "\"False\""));
    print('hi hi hi hi hi hi hi ${_data}'  );
    _data.forEach((data) {
      var model = ProductModel();
      model.id = data['id'];

      print('hi hi hi hih ih hi hi id ${id}');

      model.name = data['name'];
      model.price = data['lst_price'];
      model.qty = data['qty_available'];
      //  model.price=data['image_1920'];
      // Uint8List.view(model.price=data['image_1920']);// bytes = base64.decode(_base64);
      model.images =base64.decode(data['image_1920']);

      setState(() {
        print(_data);
        ProductList.add(model);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: AppController.textDirection,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black87),
            centerTitle: true,
            title: Text(
              '${AppController.strings.Favorite}',
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
          ),
          body: Scaffold(
            body: Column(
              children: [
                // ProductList.length != 0
                //     ? Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: TextField(
                //             textAlign: TextAlign.center,
                //             keyboardType: TextInputType.emailAddress,
                //             onChanged: (text) {
                //               text = text.toLowerCase();
                //               setState(() {
                //                 ProductList.where((name) {
                //                   var itemname = name.name;
                //                   return itemname.contains(text);
                //                 }).toList();
                //               });
                //             },
                //             decoration: InputDecoration(
                //               labelText: 'Search about product ',
                //               suffixIcon: Icon(
                //                 Icons.search,
                //                 color: Colors.grey,
                //               ),
                //               contentPadding: EdgeInsets.symmetric(
                //                   vertical: 10.0, horizontal: 20.0),
                //               border: OutlineInputBorder(
                //                 borderRadius:
                //                     BorderRadius.all(Radius.circular(10.0)),
                //               ),
                //               enabledBorder: OutlineInputBorder(
                //                 borderSide: BorderSide(
                //                     color: Colors.blueAccent, width: 1.0),
                //                 borderRadius:
                //                     BorderRadius.all(Radius.circular(10.0)),
                //               ),
                //               focusedBorder: OutlineInputBorder(
                //                 borderSide: BorderSide(
                //                     color: Colors.blueAccent, width: 2.0),
                //                 borderRadius:
                //                     BorderRadius.all(Radius.circular(10.0)),
                //               ),
                //             )),
                //       )
                //     : Container(),
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: ProductList != null
                        ? GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 0.93),
                              mainAxisSpacing: 15,
                              crossAxisCount: 2,
                            ),
                            // gridDelegate:
                            // SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                            itemCount: ProductList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildInkWell(index, context);

                              //   Container(
                              //     child:
                              //     Image.network('https://www.standardcoldpressedoil.com/hub/wp-content/uploads/2020/05/human-brain-hologram-dark-background_99433-52.jpg'
                              //       // Api().baseImgURL + _imageAlbumData[index].image,
                              //       ,fit: BoxFit.fitWidth,
                              //     )
                              // );

                            })
                        : Container(
                            height: 250,
                            child: Card(
                              child: ModalProgressHUD(
                                  color: Colors.white12,
                                  inAsyncCall: loading,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: loading
                                              ? Center(
                                                  child: Text(
                                                      '${AppController.strings.PleaseWait}'))
                                              : Center(
                                                  child: Text(
                                                    '${AppController.strings.NoProduct}',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black87),
                                                  ),
                                                )),
                                    ],
                                  )),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  InkWell buildInkWell(int index, BuildContext context) {
    var addtocart = Provider.of<AppProvider>(context);

    return InkWell(
      onTap: () {
        int id = ProductList[index].id;
        var name = ProductList[index].name;
        List message_ids = ProductList[index].message_ids;
        double qty = ProductList[index].qty;
        String description = ProductList[index].description;
        double price = ProductList[index].price;
        var img = ProductList[index].images;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(
              id: id,
              img: img,
              name: name,
              price: price,
              qty: qty,
              message_ids: message_ids,
            ),
          ),
        );
      },
      child: Card(
        elevation: 8,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: Image.memory(
                      ProductList[index].images,
                      fit: BoxFit.fill,
                    )),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '${ProductList[index].name}',
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${AppController.strings.KuwaitiLivestock}',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                top: 3,
                              ),
                              child: Directionality(
                                  textDirection: languageState == "Ar"
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  child: Row(
                                    children: [
                                      Text(
                                        '${AppController.strings.price}/',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${ProductList[index].price} ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.lightBlueAccent),
                                      ),
                                      Text(
                                        '${AppController.strings.KD}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ))),
                          ProductList[index].qty != 0
                              ? RaisedButton(
                            child: Text(
                              '${AppController.strings.addToCart}',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                            onPressed: () {
                              addtocart.addProduct(CartProductModel(
                                  idproductCart: ProductList[index].id,
                                  name: ProductList[index].name,
                                  image: ProductList[index].images,
                                  price: ProductList[index].price,
                                  qnty: 1));
                              setState(() {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return new AlertDialog(
                                        titlePadding: EdgeInsets.all(0),
                                        contentPadding: EdgeInsets.all(0),
                                        title: new Column(
                                          children: [
                                            Text(
                                                "${AppController.strings.KuwaitiLivestock}"),
                                            Divider(
                                              thickness: 1,
                                            )
                                          ],
                                        ),
                                        content: new Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                  "${AppController.strings.itemsuccessfullyadd}"),
                                              Divider(
                                                thickness: 1,
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop();
                                                  },
                                                  child: Text(
                                                    '${AppController.strings.ok}',
                                                    textAlign:
                                                    TextAlign.center,
                                                    style: TextStyle(
                                                        color: Color(
                                                            0xffcd1313)),
                                                  ))
                                            ],
                                          ),
                                          height: 95,
                                        ),
                                      );
                                    });
                              });
                            },
                            color: Color(0xfff50000),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Color(0xfff50000))),
                          )
                              : RaisedButton(
                            child: Text(
                              '${AppController.strings.outOfStock}',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                            onPressed: () {},
                            color: Colors.grey.shade200,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Color(0xfff50000))),
                          )
                        ],
                      ),
                    )),
              ],
            ),
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                        height: 30,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.lightBlueAccent,
                        ),
                        child: Center(
                          child: Text(
                            'Livestock',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ))),
              ],
            )
          ],
        ),
      ),
    );
  }
  var languageState;
  void langState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    languageState = preferences.getString("lng");
    print(languageState);
  }
}
