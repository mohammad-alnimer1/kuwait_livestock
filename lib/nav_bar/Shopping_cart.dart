import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/Module/Cart_product_Model.dart';
import 'package:kuwait_livestock/database/CartDatabase.dart';
import 'package:kuwait_livestock/product/ProductDetails.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login_Page.dart';
import '../PurchaseScreen.dart';

import 'package:fluttertoast/fluttertoast.dart';

class ShoppingCart extends StatefulWidget {
  ShoppingCart({this.appbar});
  final appbar;
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class Services {
  final String name;
  const Services(this.name);
}

class Quantity {
  final String number;
  const Quantity(this.number);
}

class _ShoppingCartState extends State<ShoppingCart> {
  String selectedSlicer;

  List<Services> getSlicer = <Services>[
    Services('no Slicer'),
    Services('Two pieces'),
    Services('Four pieces'),
    Services('six pieces'),
    Services('Eight pieces'),
  ];

  String selectedQuantity;

  List<Quantity> getQuantity = <Quantity>[
    Quantity('1'),
    Quantity('2'),
    Quantity('3'),
    Quantity('4'),
    Quantity('4'),
  ];
  List<CartProductModel> _cartproductmodel = [];
  List<CartProductModel> get cartproductmodel => _cartproductmodel;
  var dbHelper = CartDatabase.db;
  bool loading = true;
  getALLProduct() async {
    var dbHelper = CartDatabase.db;
    _cartproductmodel = await dbHelper.getALLProduct();
    setState(() {
      print(_cartproductmodel.length.toString());
    });
  }

  double get totalprice => _totalPrice;
  double _totalPrice = 0.0;

  bool isLogin = false;
  getLoggedInState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLogin = preferences.containsKey('isLogin');
    setState(() {
      return isLogin;
    });
  }

  double _TotalofItem = 0.0;

  var y;
  @override
  void initState() {
    print(widget.appbar);
    super.initState();
    getLoggedInState();
    setState(() {
      getALLProduct().then((number) {
        for (int i = 0; i < _cartproductmodel.length; i++) {
          _TotalofItem = (_cartproductmodel[i].qnty + _TotalofItem);
          _totalPrice += (_cartproductmodel[i].price * _cartproductmodel[i].qnty);
        }
        print('Total Price$_totalPrice');
        loading = false;

      });
    });
  }






  @override
  Widget build(BuildContext context) {
    var addtocart = Provider.of<AppProvider>(context);
    addtocart.getALLProduct();
    // print('${_cartproductmodel}0000000000000000');
    _TotalofItem;
    return cartproductmodel.length != 0
        ? Directionality(
            textDirection: AppController.textDirection,
            child: Scaffold(
              appBar:  widget.appbar == false
                  ? AppBar(
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  title: Text(
                    '${AppController.strings.shoppingCart}',
                    style: TextStyle(color: Colors.black),
                  ))
                  : null,
              bottomNavigationBar: Container(
                height: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 50,
                      child: Card(
                        child: Container(
                          child:
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${AppController.strings.Quantity}'),
                                    Text('${_TotalofItem.toString()}'),

                                    Text(
                                      '${AppController.strings.TotalSummation}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent),
                                    ),
                                    Text(
                                      '${_totalPrice.toString()}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent),
                                    )
                                  ],
                              )),


                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 2.5, bottom: 2.5, left: 20, right: 20),
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.red)),
                          color: Color(0xfff50000),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'إتمام الشراء',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                              )
                            ],
                          ),
                          elevation: 0.2,
                          onPressed: () {


                            if (isLogin == false) {
                              setState(() {
                                _showMaterialDialog();
                              });
                            } else {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                            builder: (context) => PurchaseScreen(
                              ConfirmedItems: _cartproductmodel,
                              count: _TotalofItem,
                              TotalPrice:_totalPrice

                            )));
                            }
                          }),
                    ),
                  ],
                ),
              ),
              body: ListView.builder(
                itemCount: cartproductmodel.length,
                itemBuilder: (context, index) {
                  return
                      Container(

                        // decoration: BoxDecoration(border:Border.fromBorderSide(BorderSide(color: Colors.black87)) ),

                        height: 165,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8,left: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3, top: 5),
                                            child: Text(
                                              '${cartproductmodel[index].name}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(bottom: 5,),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${AppController.strings.price}',
                                                    style: TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    '${cartproductmodel[index].price}',
                                                    style: TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    '${AppController.strings.KD}',
                                                    style: TextStyle(fontSize: 18),
                                                  ),
                                                ],
                                              )),
                                          Row(
                                            children: <Widget>[
                                              Text('${AppController.strings.Quantity} :'),
                                              roundiconbutton(
                                                height: 30,
                                                width: 30,
                                                iconq: FontAwesomeIcons.minus,
                                                onpriss: () {
                                                  setState(() {

                                                    if (_cartproductmodel[index].qnty !=
                                                        1.0) {
                                                      _cartproductmodel[index].qnty--;
                                                      _totalPrice -=
                                                          (cartproductmodel[index]
                                                              .price);
                                                      dbHelper.UpdateProduct(
                                                          _cartproductmodel[index]);
                                                      // _DecreaseCounter();
                                                      // print(_counter);
                                                    }
                                                  });
                                                },
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                cartproductmodel[index].qnty.toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              roundiconbutton(
                                                height: 30,
                                                width: 30,
                                                iconq: FontAwesomeIcons.plus,
                                                onpriss: () {
                                                  setState(() {
                                                    _TotalofItem ;   _cartproductmodel[index].qnty++;
                                                    _totalPrice += (cartproductmodel[index].price);
                                                    dbHelper.UpdateProduct(
                                                        _cartproductmodel[index]);
                                                    //  _incrementCounter();
                                                    // print(_counter);
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        height: 110,
                                        width: 110,
                                        child: Image.memory(
                                          cartproductmodel[index].image,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    // Expanded(
                                    //   flex: 3,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     child: DropdownButtonFormField<String>(
                                    //       validator: (value) {
                                    //         if (value == null) {
                                    //           return AppController
                                    //               .strings.fillDataError;
                                    //         }
                                    //         return null;
                                    //       },
                                    //       hint: Text(
                                    //           '${AppController.strings.selectServices}'),
                                    //       value: selectedSlicer,
                                    //       items: getSlicer
                                    //           .map((Services ServicesType) {
                                    //         return new DropdownMenuItem<String>(
                                    //           child: new Text(ServicesType.name),
                                    //           value: ServicesType.name,
                                    //         );
                                    //       }).toList(),
                                    //       onChanged: (value) {
                                    //         setState(() {
                                    //           selectedSlicer = value;
                                    //           print(selectedSlicer);
                                    //         });
                                    //       },
                                    //     ),
                                    //   ),
                                    // ),
                                    // Expanded(
                                    //   flex: 2,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     child: DropdownButtonFormField<String>(
                                    //       validator: (value) {
                                    //         if (value == null) {
                                    //           return AppController
                                    //               .strings.fillDataError;
                                    //         }
                                    //         return null;
                                    //       },
                                    //       value: selectedQuantity,
                                    //       items: getQuantity
                                    //           .map((Quantity QuantityType) {
                                    //         return new DropdownMenuItem<String>(
                                    //           child: new Text(QuantityType.number),
                                    //           value: QuantityType.number,
                                    //         );
                                    //       }).toList(),
                                    //       onChanged: (value) {
                                    //         setState(() {
                                    //           selectedQuantity = value;
                                    //           print(selectedQuantity);
                                    //         });
                                    //       },
                                    //     ),
                                    //   ),
                                    // ),
                                    Expanded(
                                        child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          addtocart.deleteItem(_cartproductmodel[index].idproductCart);
                                          getALLProduct();
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 15,left: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${AppController.strings.delete}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.deepOrangeAccent),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                                Divider(thickness: 1,color: Colors.black87,),

                              ],
                            ),

                          );



                },
              ),
            ))
        : Container(
            // height: MediaQuery.of(context).size.height * 0.600,
            child: ModalProgressHUD(
              color: Colors.white12,
              inAsyncCall: loading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Directionality(
                          textDirection: AppController.textDirection,
                          child: Scaffold(
                              appBar: widget.appbar == false
                                  ? AppBar(
                                      backgroundColor: Colors.white,
                                      centerTitle: true,
                                      leading: IconButton(
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: Colors.black87,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                      title: Text(
                                        '${AppController.strings.shoppingCart}',
                                        style: TextStyle(color: Colors.black),
                                      ))
                                  : null,
                              body: loading
                                  ? Center(
                                      child: Text(
                                          '${AppController.strings.PleaseWait}'))
                                  : Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(50),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: SvgPicture.asset(
                                                  'images/emptyCart.svg'),
                                            ),
                                            SizedBox(height: 50),
                                            Expanded(
                                              child: Text(
                                                '${AppController.strings.NoProduct}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black87),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ))))
                ],
              ),
            ),
          );
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("${AppController.strings.Note}"),
              content: new Text("${AppController.strings.pleaseLogin}"),
              actions: <Widget>[
                FlatButton(
                  child: Text('${AppController.strings.login}'),
                  onPressed: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LogInPage()));
                    });
                  },
                )
              ],
            ));
  }


}
