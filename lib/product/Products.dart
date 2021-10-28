import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/AppHelper/ShoppingCartButton.dart';
import 'package:kuwait_livestock/AppHelper/networking.dart';
import 'package:kuwait_livestock/Module/Cart_product_Model.dart';
import 'package:kuwait_livestock/Module/Product_Model.dart';
import 'package:kuwait_livestock/api/Api.dart';
import 'package:kuwait_livestock/database/CartDatabase.dart';
import 'package:kuwait_livestock/nav_bar/Shopping_cart.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProductDetails.dart';
import 'package:kuwait_livestock/AppHelper/ShowDealog.dart';

class ProductsPage extends StatefulWidget {
  final CategoryName;
  final id;
  ProductsPage(this.id, this.CategoryName);
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<ProductModel> ProductList = List<ProductModel>();

  int id;
  Uint8List bytes;
  Future<dynamic> getProduct(id) async {
    final NetworkHelper networkHelper =
        NetworkHelper(Api().baseURL + 'categ_ids?categ_id=${id = widget.id}');
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
        loading = false;
      });
    });
  }

  onSearchTextChanged(
    String text,
  ) async {
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

  TextEditingController controller = new TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    langState();
    getProduct(id = widget.id);
  }

  @override
  Widget build(BuildContext context) {
    var counter = Provider.of<AppProvider>(context);
    var addtocart = Provider.of<AppProvider>(context);

    counter.cartproductmodel.length.toString();
    return Directionality(
        textDirection: AppController.textDirection,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            actions: [
              Container(height: 150, width: 50, child: InkWell(child: shoppingCartButton(),onTap: () {
                bool appbar=false;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShoppingCart(appbar: appbar,),
                    ));

              },))
            ],
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black87),
            centerTitle: true,
            title: Text(
              '${widget.CategoryName}',
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
          ),
          body: Scaffold(
            body: ModalProgressHUD(
                color: Colors.white12,
                inAsyncCall: loading,
                child: Column(
                  children: [
                    ProductList.length != 0
                        ? Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextField(
                                controller: controller,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: onSearchTextChanged,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  labelText: '${AppController.strings.SearchAboutProduct} ',
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade100, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade100, width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                )),
                          )
                        : Container(),
                  Expanded(
                   child: _searchResult.length != 0||controller.text.isNotEmpty
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
                                    ),);
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: ProductList != null
                                  ? GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width /
                                                (MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    0.90),
                                        mainAxisSpacing: 15,
                                        crossAxisCount: 2,
                                      ),
                                      // gridDelegate:
                                      // SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                      itemCount: ProductList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                                  color: Colors
                                                                      .black87),
                                                            ),
                                                          )),
                                              ],
                                            )),
                                      ),
                                    ),
                            ),
                    ),
                  ],
                )),
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
