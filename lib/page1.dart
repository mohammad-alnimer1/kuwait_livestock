import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart ' as http;
import 'package:kuwait_livestock/product/ProductDetails.dart';
import 'package:kuwait_livestock/product/Products.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AppHelper/AppController.dart';
import 'AppHelper/networking.dart';
import 'Module/Cart_product_Model.dart';
import 'Module/Category_Model.dart';
import 'Module/HomeProductModel.dart';
import 'Module/Product_Model.dart';
import 'api/Api.dart';

class page1 extends StatefulWidget {
  @override
  _page1State createState() => _page1State();
}

class _page1State extends State<page1> {
  bool loading = true;


  // Future<CategoryModel> _getAirQuality() async {
  //   var dio = Dio();
  //   var cookieJar;
  //   Response dioResponse;
  //
  //   try {
  //
  //     dioResponse = await dio.get("${Api().baseURL+'categ_ids'}");
  //
  //     return CategoryModel.fromJson(dioResponse.data["current"]);
  //
  //   } catch (e) {
  //     print('catch error: $e');
  //   }
  // }

  List<CategoryModel> CategoryList = List<CategoryModel>();

  Future<void> getCateg() async {
    final NetworkHelper networkHelper =
        NetworkHelper("${Api().baseURL + 'categ_ids'}");
    final Categorydata = await networkHelper.getdata();
    Categorydata.forEach((data) {
      var model = CategoryModel();
      model.id = data['id'];
      model.name = data['name'];
      model.images = base64.decode(data['image']);
      if (mounted)
        setState(() {
          CategoryList.add(model);
        });
    });
    // print(CategoryList[1].name);
  }

  List<ProductModel> ProductList = List<ProductModel>();

  int id;
  Uint8List bytes;
  Future<dynamic> getProduct() async {
    final NetworkHelper networkHelper =
        NetworkHelper(Api().baseURL + 'categ_ids?categ_id=${id = 1}');
    final Productdata = await networkHelper.getdata();
    Productdata.forEach((data) {
      var model = ProductModel();
      model.id = data['id'];
      print('hi hi hi hih ih hi hi id ${id}');
      model.name = data['name'];
      model.price = data['lst_price'];
      model.qty = data['qty_available'];
      //  model.price=data['image_1920'];
      // Uint8List.view(model.price=data['image_1920']);// bytes = base64.decode(_base64);
      model.images = base64.decode(data['image_1920']);
      setState(() {
        print(Productdata);
        ProductList.add(model);
      });
    });
  }

  List<ProductModel> ProductList1 = List<ProductModel>();

  int id1;
  Uint8List bytes1;
  Future<dynamic> getProduct1() async {
    final NetworkHelper networkHelper =
        NetworkHelper(Api().baseURL + 'categ_ids?categ_id=${id = 3}');
    final Productdata = await networkHelper.getdata();
    Productdata.forEach((data) {
      var model = ProductModel();
      model.id = data['id'];
      print('hi hi hi hih ih hi hi id ${id}');
      model.name = data['name'];
      model.price = data['lst_price'];
      model.qty = data['qty_available'];
      //  model.price=data['image_1920'];
      // Uint8List.view(model.price=data['image_1920']);// bytes = base64.decode(_base64);
      model.images = base64.decode(data['image_1920']);
      setState(() {
        print(Productdata);
        ProductList1.add(model);
      });
    });
  }

  @override
  void initState() {
    getCateg().then((value) => getProduct().then((value) => getProduct1()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Directionality(
        textDirection: AppController.textDirection,
        child: Scaffold(
         body: ListView(
         shrinkWrap: true,
         children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {},
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  labelText: '${AppController.strings.SearchAboutProduct}',
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey.shade100, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey.shade100, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Carousel(
                    animationDuration: Duration(seconds: 1),
                    //pageController: PageController(),
                    boxFit: BoxFit.cover,
                    animationCurve: Curves.fastOutSlowIn,
                    dotSize: 10.0,
                    autoplay: true,
                    dotIncreasedColor: Color(0xFFf33BE9F),
                    dotBgColor: Colors.transparent,
                    dotPosition: DotPosition.bottomCenter,
                    dotVerticalPadding: 10.0,
                    showIndicator: true,
                    indicatorBgPadding: 7.0,
                    autoplayDuration: Duration(seconds: 3),
                    borderRadius: true,
                    noRadiusForIndicator: true,
                    images: [
                      // for (var i = 0; i < slidImg.length; i++)
                      AssetImage('images/logo.jpeg'),
                      AssetImage('images/sh1.png'),


                      // NetworkImage('${Api().baseImgURL + imgdata[2]['Images']}'),
                    ],
                  )),
              height: 220,
            ),
          ),
          Container(
            height: 50,
            child: Image.asset(
              'images/cut.jpeg',
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 50,
              child: RaisedButton(
                onPressed: () {

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => page1(),
                  //   ),
                  // );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.indigo.shade900,

                child: Text(
                  'CUSTOMIZE YOUR CUT ',
                  style: TextStyle(
                      decorationThickness: 0.1,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
                elevation: 0.2,
                // onPressed: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) =>  GetinTouch(),
                //     ),
                //   );
                // },
              ),
            ),
          ),


          ProductList.isNotEmpty||ProductList1.isNotEmpty?  Column(
          children: [

         Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  CategoryList[1].name,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                height: 25,
              ),
              InkWell(
              onTap: () {
              int id = CategoryList[1].id;
              var CategoryName=CategoryList[1].name;
              print('idddddddddddddd ${id}');
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductsPage(id,CategoryName),
              ));
              },
              child:
                        Container(
                          child: Text(
                            '${AppController.strings.showAll}',
                            style: TextStyle(fontSize: 19,color: Colors.amber),

                          ),
                          height: 25,
                        ),)
            ],
          ),
        ),
        Column(
          children: [
            Container(
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 2.8),
                  mainAxisSpacing: 12,
                  crossAxisCount: 1,
                ),
                itemCount: ProductList1.take(5).length,
                itemBuilder: (context, index) {
                  return buildInkWell(index, context, ProductList1);
                },
              ),
              height: 302,
            )
          ],
        ),



        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  CategoryList[0].name,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                height: 25,
              ),
    InkWell(
    onTap: () {
    int id = CategoryList[0].id;
    var CategoryName=CategoryList[0].name;
    print('idddddddddddddd ${id}');
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProductsPage(id,CategoryName),
    ));
    },
    child: Container(
                child: Text(
                  '${AppController.strings.showAll}',
                  style: TextStyle(fontSize: 19,color: Colors.amber),
                ),
                height: 25,
              )),
            ],
          ),
        ),
        Container(
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 2.8),
              mainAxisSpacing: 12,
              crossAxisCount: 1,
            ),
            itemCount: ProductList.take(5).length,
            itemBuilder: (context, index) {
              return buildInkWell(index, context, ProductList);
            },
          ),
          height: 302,
        )
      ],
    ): Container(
            height: MediaQuery.of(context).size.height*0.600,
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
              ),
            ),
          )
        ],
      ),
    ));
  }

  InkWell buildInkWell(int index, BuildContext context, Produc) {
    var addtocart = Provider.of<AppProvider>(context);

    return InkWell(
      onTap: () {
        int id = Produc[index].id;
        var name = Produc[index].name;
        List message_ids = Produc[index].message_ids;
        double qty = Produc[index].qty;
        String description = Produc[index].description;
        double price = Produc[index].price;
        var img = Produc[index].images;
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
                  Produc[index].images,
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
                              '${Produc[index].name}',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                          child: Row(
                                children: [
                                  Text(
                                    '${AppController.strings.price}/',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${Produc[index].price} ',
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
                              )),
                      Produc[index].qty != 0
                          ? RaisedButton(
                              child: Text(
                                '${AppController.strings.addToCart}',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              onPressed: () {
                                addtocart.addProduct(CartProductModel(
                                    idproductCart: Produc[index].id,
                                    name: Produc[index].name,
                                    image: Produc[index].images,
                                    price: Produc[index].price,
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
