import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kuwait_livestock/AppHelper/AppSharedPrefs.dart';
import 'package:kuwait_livestock/AppHelper/Constants.dart';
import 'package:kuwait_livestock/AppHelper/ShoppingCartButton.dart';
import 'package:kuwait_livestock/AppHelper/networking.dart';
import 'package:kuwait_livestock/AppHelper/staticWidget.dart';
import 'package:kuwait_livestock/Module/Cart_product_Model.dart';
import 'package:kuwait_livestock/Module/FavoriteModel.dart';
import 'package:kuwait_livestock/Module/Product_Model.dart';
import 'package:kuwait_livestock/api/Api.dart';
import 'package:kuwait_livestock/database/CartDatabase.dart';
import 'package:kuwait_livestock/nav_bar/Shopping_cart.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:kuwait_livestock/Module/CommentModel.dart';
import 'package:kuwait_livestock/Module/RatingModel.dart';


class ProductDetails extends StatefulWidget {
  final id;
  final name;
  final description;
  final qty;
  final price;
  final img;
  final message_ids;

  ProductDetails(
      {this.id,
      this.name,
      this.qty,
      this.price,
      this.img,
      this.description,
      this.message_ids});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String validEmpty(String val) {
    if (val.trim().isEmpty) {
      return "${AppController.strings.pleaseEnterYourName}";
    }
  }

  List<CartProductModel> _cartproductmodel = [];
  List<CartProductModel> get cartproductmodel => _cartproductmodel;

  String availableString;
  String available() {
    if (widget.qty == 0 || widget.qty == null) {
      return availableString = '${AppController.strings.outOfStock}';
    } else {
      return availableString = '${AppController.strings.inStock}';
    }
  }




double rat;
  List <CommentModel> CommentList= List<CommentModel>();
  List <RatingModel> RatingList= List<RatingModel>();
  var Categorydata;
  Future<void> getproductDetails(var id) async {
    final NetworkHelper networkHelper = NetworkHelper(
        "${Api().baseURL + 'product_ids?product_id=${widget.id}'}");
    Categorydata = await networkHelper.getdata();

   final commentList = Categorydata[0]['message_ids'];

    commentList.forEach((data){
      var model= CommentModel();
      model.author_id=data['author_id'];
      model.body=data['body'];
      model.date =data['date'];
      model.rate_product_ids =data['rate_product_ids'];

      if (mounted)
        setState(() {
          CommentList.add(model);
        });

    });
    final rating= Categorydata[0]['rate_product_ids'];
    rating.forEach((data){
      var model= RatingModel();
      model.Rating=data['rate'];

      if (mounted)
        setState(() {
          RatingList.add(model);
        });

    });

  }

  bool isLogin = false;

  getLoggedInState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    isLogin = preferences.getBool('isLogin');
    return isLogin;
  }



  @override
  void initState() {
    super.initState();
    print(widget.message_ids);
    available();
    setState(() {
      // getProduct();
      getLoggedInState();
      getproductDetails(widget.id);
      getALLFavorite();
      getALLProduct();
    });
    print('hi hi hi hi hi hi hi ${widget.id}');
  }

  double _counter = 1;
  bool pressGeoON = false;

  bool addToWish = false;

  void _incrementCounter() {
    setState(() {
      if (widget.qty != 0 || widget.qty == null) {
        if (_counter < widget.qty) {
          _counter++;
        }
      }
    });
  }

  void _DecreaseCounter() {
    setState(() {
      if (widget.qty != 0 || widget.qty == null) {
        if (_counter == 1) {
          return _counter = 1;
        } else {
          _counter--;
        }
      } else {
        return _counter;
      }
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> CommentKey = GlobalKey<FormState>();

  getALLProduct() async {
    var dbHelper = CartDatabase.db;
    _cartproductmodel = await dbHelper.getALLProduct();
    setState(() {
      print(_cartproductmodel.length.toString());
    });
  }

  List<FavoriteModel> _Favoritemodel = [];
  List<FavoriteModel> get Favoritemodel => _Favoritemodel;

  getALLFavorite() async {
    var dbHelper = CartDatabase.db;

    _Favoritemodel = await dbHelper.getAllFavorite();
    setState(() {
      // print('${_Favoritemodel[4].idproductFavorite}');
      print(_Favoritemodel);
    });
  }

  var name;

  getpref() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    name = pre.getStringList('Listid');
    print(name);
  }

  // Future setList()async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   prefs.setStringList('Listid', intProductListOriginal);
  //
  //   var yourLis = prefs.getStringList('Listid');
  //   print(yourLis.length);
  // }
  //itemCount:CategoryList[0]['message_ids'][i]['author_id'][1],
  double get totalprice => _totalPrice;
  double _totalPrice = 0.0;

  // Future<dynamic> getProduct() async {
  //   final NetworkHelper networkHelper =
  //   NetworkHelper('http://kuwaitlivestock.com:5000/product_ids?product_id=8');
  //   var Productdata = await networkHelper.getdata();
  //   print();
  //
  // }
  TextEditingController CommentController = new TextEditingController();
  var _data;
  sendComment() async {
    var logindata = CommentKey.currentState;
    SharedPreferences pre = await SharedPreferences.getInstance();
    var userIdSP = pre.getString('user_id');
    if (logindata.validate()) {
      var data = {
        "comment": CommentController.text.toString(),
        'user_id': userIdSP.toString(),
        'product_id': widget.id.toString(),
        'date': '2021-12-13 08:01:00',
      };
      var url = "http://kuwaitlivestock.com:5000/create_comment";
      dynamic response = await http.post(url, body: data);
      print(response.body);
      String jsonsDataString = response.body;
      _data =jsonDecode(jsonsDataString.replaceAll("'",'"')) ;
      if(_data ['result'] == "success"){
        Navigator.pop(context);
      }}
    }


  @override
  Widget build(BuildContext context) {
    var addtoFavorite = Provider.of<AppProvider>(context);
    var addtocart = Provider.of<AppProvider>(context);

    return Directionality(
        textDirection: AppController.textDirection,
        child: Scaffold(
          key: _scaffoldKey,
          bottomNavigationBar: Container(
            child: Material(
              color: Color(0xfff50000),
              borderRadius: BorderRadius.circular(10),
              elevation: 5.0,
              child: MaterialButton(
                onPressed: () {
                  addtocart.addProduct(CartProductModel(
                      idproductCart: widget.id,
                      name: widget.name,
                      image: widget.img,
                      price: widget.price,
                      qnty: _counter));
                },
                minWidth: 200.0,
                height: 42.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${AppController.strings.addToCart}  ',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Icon(Icons.shopping_cart_outlined, color: Colors.white)
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              actions: [
                Container(height: 150, width: 50,
                    child:InkWell(onTap: (){
                      bool appbar=false;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShoppingCart(appbar: appbar,),
                          ));
                    },
                  child:  shoppingCartButton(),))
              ],
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Text(
                '${widget.name}',
                style: TextStyle(color: Colors.black),
              )),
          body: ListView(
            children: [
              Container(child: Image.memory(widget.img)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Padding(padding: EdgeInsets.all(10),
                  child: Column(children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Text('${AppController.strings.productName} : ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('${widget.name}',
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        IconButton(
                            icon: pressGeoON == false
                                ? FaIcon(FontAwesomeIcons.heart)
                                : FaIcon(FontAwesomeIcons.solidHeart),
                            onPressed: () {
                              setState(() {
                                AppSharedPrefs.idList.add(widget.id.toString());
                                AppSharedPrefs.saveListIDInSP(
                                    AppSharedPrefs.idList);

                                // intProductListOriginal.add(widget.id.toString());
                                addtoFavorite.addToFavorite(FavoriteModel(
                                  idproductFavorite: widget.id,
                                ));
                                pressGeoON = !pressGeoON;
                              });
                            })
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('${AppController.strings.price}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Text(' ${widget.price} ',
                                  style: TextStyle(fontSize: 15)),
                              Text('${AppController.strings.KD}',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          Row(
                            children: [
                              Text('${AppController.strings.available} : ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Text('$availableString',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    widget.qty != 0 || widget.qty == null
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child:  Text(
                              '${AppController.strings.selectQuantity} :',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          children: <Widget>[
                            Row(children: [
                              roundiconbutton(
                                height: 30,
                                width: 30,
                                iconq: FontAwesomeIcons.minus,
                                onpriss: () {
                                  setState(() {
                                    _DecreaseCounter();
                                    print(_counter);
                                  });
                                },
                              ),

                              Text(
                                _counter.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),

                              roundiconbutton(
                                width: 30,
                                height: 30,
                                iconq: FontAwesomeIcons.plus,
                                onpriss: () {
                                  setState(() {
                                    _incrementCounter();
                                    print(_counter);
                                  });
                                },
                              ),
                            ],),

                          ],
                        ),
                        Row(
                          children: [
                            Text('${AppController.strings.maximumAvailableStock}',
                                style: TextStyle(fontSize: 12)),
                            Text('${widget.qty}', style: TextStyle(fontSize: 12)),
                          ],
                        ),

                      ],
                    )
                        : Container(),

                  ],),
                ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 15, top: 10, bottom: 10, left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${AppController.strings.details}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Categorydata!=null?    Text('${Categorydata[0]['description']}'):Container(height: 50,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: CommentList.length,
                    itemBuilder: (context, index) {

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          borderOnForeground: true,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               Text('${CommentList[index].author_id[1]}'),
                               Text('${CommentList[index].body}'),

                                  RatingBar.builder(
                                 initialRating:1 ,
                                  itemSize: 25,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {

                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  isLogin!=null? Container(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            '${AppController.strings.AddComment}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Form(
                          key: CommentKey,
                          child: Center(
                            child: TextFormField(
                              controller: CommentController,
                              validator: validEmpty,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                  ),
                                  filled: true),
                              maxLines: 3,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            '${AppController.strings.AddRating}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        RatingBar.builder(
                          initialRating:1 ,
                          itemSize: 25,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(
                            horizontal: 1,
                          ),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {

                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 15),
                              child: RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    sendComment();

                                  });
                                },
                                child: Text('${AppController.strings.send}'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ):Container()
                ],
              )
            ],
          ),
        ));
  }


}

class roundiconbutton extends StatelessWidget {
  const roundiconbutton({@required this.iconq, @required this.onpriss,this.width,this.height});

  final IconData iconq;
  final Function onpriss;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        constraints: BoxConstraints.tightFor(

          width: width,
          height: height,
        ),
        child: Icon(
          iconq,
          color: Colors.black,
          size: 15,
        ),
        fillColor: Colors.white,
        shape: CircleBorder(),
        elevation: 6,

        onPressed: onpriss);
  }
}
