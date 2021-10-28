import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/AppHelper/networking.dart';
import 'package:kuwait_livestock/Module/Cart_product_Model.dart';
import 'package:kuwait_livestock/Module/Category_Model.dart';
import 'package:kuwait_livestock/Module/Product_Model.dart';
import 'package:kuwait_livestock/Module/servCat.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kuwait_livestock/api/Api.dart';

import 'package:kuwait_livestock/product/ProductDetails.dart';
import 'package:kuwait_livestock/product/Products.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Category_Page extends StatefulWidget {


  @override
  _Category_PageState createState() => _Category_PageState();
}



class _Category_PageState extends State<Category_Page> {









List <CategoryModel> CategoryList =List<CategoryModel>();

  Future<void> getCateg()async{

    final  NetworkHelper networkHelper =NetworkHelper("${Api().baseURL+'categ_ids'}");
    final Categorydata = await networkHelper.getdata();
    Categorydata.forEach((data){
       var model= CategoryModel();
       model.id=data['id'];
       model.name=data['name'];
       model.images =base64.decode(data['image']);
       if (mounted)
         setState(() {
           CategoryList.add(model);
         });

    });
   // print(CategoryList[1].name);

  }







  // List<String> items=[];
  // List Category;
  // String imge;
  // Future<void> getInfo() async {
  //   try {
  //     final response = await http.get("http://kuwaitlivestock.com:5000/categ_ids");
  //     response.body.replaceAll("'", '"');
  //     final extractedData = json.decode(response.body.replaceAll("'", '"'));
  //     Category =extractedData;
  //     if (extractedData == null) {
  //       return;
  //     }
  //     extractedData.forEach((slidedata) {
  //       items.add(slidedata['image']);
  //       print(slidedata['image']);
  //
  //     });
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

List<ProductModel> ProductList = List<ProductModel>();


bool loading = true;


@override
  void initState() {
    super.initState();
    getCateg();
  }
TextEditingController controller = new TextEditingController();

int id;
Uint8List bytes;

onSearchTextChanged(String text,) async {
  _searchResult.clear();
  if (text.isEmpty) {
    setState(() {});
    return;
  }

  ProductList.forEach((itemsearch) {
    if (itemsearch.name.contains(text)) _searchResult.add(itemsearch);
  });
  setState(() {});
}

List<ProductModel> _searchResult = [];

  @override
  Widget build(BuildContext context) {
    return  Directionality(
        textDirection: AppController.textDirection,
        child:Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: ListView(

            children: [
              // ClipRRect(
              // borderRadius: BorderRadius.circular(16),
              //   child: Image.memory(
              //     bytes,
              //     width: 300,
              //     height: 250,
              //     fit: BoxFit.cover,
              //   )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: onSearchTextChanged,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      labelText: '${AppController.strings.SearchAboutProduct}',
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
              Divider(
                thickness: 1,
              ),
              Container(
                height: 50,
                child:    Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text(
                        '${AppController.strings.category}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),),
              _searchResult.length != 0||controller.text.isNotEmpty
              ? new GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 0.95),
                  mainAxisSpacing: 15,
                  crossAxisCount: 2,),
                itemCount: _searchResult.length,
                itemBuilder: (context, index) {
                  return new InkWell(
                    onTap: () {
                      int id = _searchResult[index].id;
                      var name = _searchResult[index].name;
                      List message_ids = _searchResult[index].message_ids;
                      double qty = _searchResult[index].qty;
                      double price = _searchResult[index].price;
                      var img = _searchResult[index].images;
                      Navigator.push(context, MaterialPageRoute(
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
                    child:Card(
                      elevation: 8,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                  child: Image.memory(
                                    _searchResult[index].images,
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
                                                '${_searchResult[index].name}',
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
                                                      '${_searchResult[index].price} ',
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
                                        _searchResult[index].qty != 0
                                            ? RaisedButton(
                                          child: Text(
                                            '${AppController.strings.addToCart}',
                                            style: TextStyle(
                                                fontSize: 15, color: Colors.white),
                                          ),
                                          onPressed: () {
                                            // addtocart.addProduct(CartProductModel(
                                            //     idproductCart: ProductList[index].id,
                                            //     name: ProductList[index].name,
                                            //     image: ProductList[index].images,
                                            //     price: ProductList[index].price,
                                            //     qnty: 1));
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
                    ),);
                },
              ) : CategoryList.isNotEmpty?
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.65),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 10,
                ),
                itemCount: CategoryList.length,
                itemBuilder: (context, index) {

                  return InkWell(
                    onTap: () {
                      int id = CategoryList[index].id;
                      var CategoryName=CategoryList[index].name;
                      print('idddddddddddddd ${id}');
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductsPage(id,CategoryName),
                          ));
                    },
                    child: Card(
                      borderOnForeground: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      semanticContainer: true,
                      elevation: 3,
                      child:Container(child:  Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Expanded(
                            child: Image.memory(

                              CategoryList[index].images,
                              fit: BoxFit.cover,
                              //
                            ),
                          ),
                          Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                ),
                                child: Center(
                                    child: Text(
                                      '${CategoryList[index].name}',
                                      textAlign: TextAlign.center,
                                      style:
                                      TextStyle(color: Colors.grey, fontSize: 15),
                                    )),
                              )),
                        ],
                      ),decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400,),borderRadius: BorderRadius.all(Radius.circular(10))),)
                    ),
                  );
                },
              )
              :Container(
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
        )
    );
  }
InkWell buildInkWell(int index, BuildContext context) {
  var addtocart = Provider.of<AppProvider>(context);

  return InkWell(
    onTap: () {
      int id = _searchResult[index].id;
      var name = _searchResult[index].name;
      List message_ids = _searchResult[index].message_ids;
      double qty = _searchResult[index].qty;
      String description = _searchResult[index].description;
      double price = _searchResult[index].price;
      var img = _searchResult[index].images;
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
                    _searchResult[index].images,
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
                                '${_searchResult[index].name}',
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
                                      '${_searchResult[index].price} ',
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
                        _searchResult[index].qty != 0
                            ? RaisedButton(
                          child: Text(
                            '${AppController.strings.addToCart}',
                            style: TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                          onPressed: () {
                            addtocart.addProduct(CartProductModel(
                                idproductCart: ProductList[index].id,
                                name: _searchResult[index].name,
                                image: _searchResult[index].images,
                                price: _searchResult[index].price,
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

