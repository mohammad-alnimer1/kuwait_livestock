import 'dart:convert';
import 'dart:ui';
import 'package:flutter_collapse/flutter_collapse.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kuwait_livestock/AppHelper/networking.dart';
import 'package:kuwait_livestock/Module/Cart_product_Model.dart';
import 'package:kuwait_livestock/Module/User.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'AppHelper/AppController.dart';
import 'CardPayment.dart';
import 'AppHelper/Constants.dart';
import 'Module/AddressModel.dart';
import 'api/Api.dart';
import 'nav_bar/More/All_Addresses.dart';
import 'package:kuwait_livestock/AppHelper/CardAddress.dart';

import 'nav_bar/More/termsAndCondition.dart';
import 'nav_bar/nav_bar.dart';
import 'package:date_time_picker/date_time_picker.dart';

class PurchaseScreen extends StatefulWidget {
  final List<CartProductModel> ConfirmedItems;
  final count;
  final TotalPrice;
  PurchaseScreen({this.ConfirmedItems, this.count, this.TotalPrice});
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class Services {
  final String name;
  const Services(this.name);
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  static final _fromdateController = TextEditingController();
  static final _discountsController = TextEditingController();
  DateTime selectedDate = DateTime.now();



  bool _validate = false;
  List<AddressModel> AddressList = List<AddressModel>();
  String userIdSP;
  Future<dynamic> getAllAddresses(String id) async {
    SharedPreferences pre = await SharedPreferences.getInstance();

    userIdSP = pre.getString('user_id');
    final NetworkHelper networkHelper =
        NetworkHelper(Api().baseURL + 'GetAddress?user_id=${userIdSP}');
    final Productdata = await networkHelper.getdata();

    Productdata.forEach((data) {
      var model = AddressModel();
      model.Addressid = data['id'];
      print('hi hi hi hih ih hi hi id ${data}');
      model.AddressName = data['name_address'];
      model.country_id = data['country_id'];
      model.state_id = data['state_id'];
      model.building_address = data['building_address'];
      model.note_address = data['note_address'];
      model.latitude = data['latitude'];
      model.longitude = data['longitude'];
      model.street = data['street'];

      setState(() {
        print(Productdata);
        AddressList.add(model);
      });
    });
  }

  var ir;
  void i() {
    ir = jsonEncode(widget.ConfirmedItems.map((e) => e.toJson1()).toList());
    print('ir $ir');
  }

  var _data;

  var UserEmail;
  Future ChangePasswordFun() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    UserEmail = preferences.getString('login');

    var data = {
      "login": UserEmail.toString(),
      "order_lines_ids": ir.toString(),
      'type_payment': 'cod',
      'delivery_date': '2021-12-13 08:01:00'
    };
    print(ir);
    var url = "http://kuwaitlivestock.com:5000/create_order";
    dynamic response = await http.post(url, body: data);
    print(response.body);
    String jsonsDataString = response.body;
    _data = jsonDecode(jsonsDataString.replaceAll("'", '"'));
    print('hi hi hi hi hi hi hi ${_data}');
    if (_data['result'] == "success") {
      // Showtoast("${AppController.strings.changeDataSuccess}");
      if (_LanggroupValue == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CardPayment()));
      } else if (_LanggroupValue == 2) {
        showDialog(
            context: context,
            builder: (context) => Directionality(
                  textDirection: AppController.textDirection,
                  child: AlertDialog(
                    title: Text('${AppController.strings.confirmOrder}'),
                    content:
                        Text('${AppController.strings.orderConfirmDetails}'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('${AppController.strings.ok}'),
                      ),
                    ],
                  ),
                ));
      }
    } else {
      //  Showtoast("${AppController.strings.PleaseCheckPassword}");
      // show_dialogall(context,"filed","wrong email or password plese check");

    }
  }

  var discounts_data;
  bool discountBool = false;
  Future discounts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    UserEmail = preferences.getString('login');

    var data = {
      "code": _discountsController.text,
      "amount": widget.TotalPrice.toString()
    };
    var url = "http://kuwaitlivestock.com:5000/discounts_nsbeh";
    dynamic response = await http.post(url, body: data);
    print(response.body);
    String jsonsDataString = response.body;
    discounts_data = jsonDecode(jsonsDataString.replaceAll("'", '"'));
    print('hi hi hi hi hi hi hi ${discounts_data}');
    if (discounts_data['result'] == "success") {
      Showtoast("${AppController.strings.discountSuccess}");
      discountBool = true;

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => navigation_bar()));
    } else if (discounts_data['result'] == "failure") {
      Showtoast("${AppController.strings.DiscountFailed}");
      // show_dialogall(context,"filed","wrong email or password plese check");
    }
  }

  @override
  void initState() {
    print('TotalPrice${widget.TotalPrice}');
    totalSummation();
    i();
    getAllAddresses(userIdSP);
    changeLng();
    super.initState();
  }

  var isExpanded = false;

  _onExpansionChanged(bool val) {
    setState(() {
      isExpanded = val;
    });
  }

  double totalSummationOfItem;

  totalSummation() {
    for (int i = 0; i < widget.ConfirmedItems.length; i++) {}
    print('totalSummationOfItem$totalSummationOfItem');
  }

  int _activeMeterIndex;
  int selected = -1; //attention
  bool ignoring = true;
  bool ignoring1 = true;
  bool ignoring2 = true;
  bool ignoring3 = true;
  bool ignoring4 = true;
  bool ignoring5 = true;

  void button(newState) {
    if (newState)
      setState(() {
        Duration(seconds: 20000);
        selected = 0;
      });
    else
      setState(() {
        selected = -1;
      });
  }

  int _LanggroupValue = 0;

  int changeLng() {
    if (_LanggroupValue == 1) {
      return _LanggroupValue = 1;
    } else if (_LanggroupValue == 0) {
      return _LanggroupValue = 0;
    }
  }

  Future<bool> lang() async {
    SharedPreferences pre = await SharedPreferences.getInstance();

    if (pre.getString('lng') == '1') {
      setState(() {
        _LanggroupValue = 1;
      });
    } else {
      setState(() {
        _LanggroupValue = 0;
      });
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _fromdateController.text=selectedDate.toString();
      });
  }

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: AppController.textDirection,
        child: Scaffold(
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
                padding: EdgeInsets.all(10),
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(5),
                //     side: BorderSide(color: Colors.red)
                // ),
                color: _isChecked == true
                    ? Color(0xfff50000)
                    : Colors.grey.shade400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${AppController.strings.confirmOrder}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
                elevation: 0.2,
                onPressed: () {
                  totalSummation();
                  ChangePasswordFun();
                }),
          ),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black87),
            backgroundColor: Colors.white,
            title: Text(
              '${AppController.strings.PurchaseScreen}',
              style: TextStyle(color: Colors.black87),
            ),
            centerTitle: true,
          ),
          body: ListView(
            key: Key('builder ${selected.toString()}'),
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.black87),
                )),
                child: ExpansionTile(
                  collapsedBackgroundColor: Colors.grey.shade400,
                  backgroundColor: Colors.white,
                  onExpansionChanged: ((newState) {
                    if (newState)
                      setState(() {
                        Duration(seconds: 20000);
                        selected = 0;
                      });
                    else
                      setState(() {
                        selected = -1;
                      });
                  }),
                  key: Key(0.toString()), //attention
                  initiallyExpanded: 0 == selected,
                  title: Text(
                    '${AppController.strings.DeliveryMethod}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  leading: Text(
                    '${AppController.strings.Step1}:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Container(
                            width: 25,
                            child: Radio(
                                value: _LanggroupValue,
                                groupValue: _LanggroupValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _LanggroupValue = newValue;
                                  });
                                  //  changeLng( ) ;
                                }),
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  _LanggroupValue = 1;
                                });
                                //  changeLng( );
                              },
                              child:
                                  Text('${AppController.strings.Homedelivery}'))
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 5, right: 5, left: 5, bottom: 5),
                              child: Text(
                                '${AppController.strings.CheckYourAddress}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            AddressCard(
                              AddressList: AddressList,
                            ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.all(10),
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
                                '${AppController.strings.Continue}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          elevation: 0.2,
                          onPressed: () {
                            ignoring = false;
                            button(false);
                            setState(() {
                              Duration(seconds: 20000);
                              selected = 1;
                            });
                          }),
                    ),
                  ],
                ),
              ),
              IgnorePointer(
                  ignoring: ignoring,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: Colors.black87),
                      )),
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.grey.shade400,
                        backgroundColor: Colors.white,
                        onExpansionChanged: ((newState) {
                          if (newState)
                            setState(() {
                              Duration(seconds: 20000);
                              selected = 1;
                            });
                          else
                            setState(() {
                              selected = -1;
                            });
                        }),
                        // onExpansionChanged: _onExpansionChanged,
                        maintainState: true,
                        key: Key(1.toString()), //attention
                        initiallyExpanded: 1 == selected,
                        title: Text(
                          '${AppController.strings.DeliveryDate}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        leading: Text(
                          '${AppController.strings.Step2}:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: InkWell(
                              child: TextFormField(
                                enabled: false,
                                controller: _fromdateController,
                                onChanged: (value) {},
                                decoration: KDecoration.copyWith(
                                  labelText:
                                      '${AppController.strings.ChooseDate}',
                                  errorText: _validate
                                      ? '${AppController.strings.pleaseFilltheData}'
                                      : null,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _selectDate(context);
                                });
                                },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
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
                                      '${AppController.strings.Continue}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                elevation: 0.2,
                                onPressed: () {
                                  ignoring1 = false;

                                  button(true);
                                  setState(() {
                                    selected = 2;
                                  });
                                }),
                          ),
                        ],
                      )
                  )
              ),
              IgnorePointer(
                  ignoring: ignoring1,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: Colors.black87),
                      )),
                      child: ExpansionTile(
                        maintainState: true,
                        collapsedBackgroundColor: Colors.grey.shade400,
                        onExpansionChanged: ((newState) {
                          if (newState)
                            setState(() {
                              selected = 2;
                            });
                          else
                            setState(() {
                              selected = -1;
                            });
                        }),
                        // onExpansionChanged: _onExpansionChanged,
                        key: Key(1.toString()), //attention
                        initiallyExpanded: 2 == selected,
                        backgroundColor: Colors.white,
                        title: Text(
                          '${AppController.strings.paymentType}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        leading: Text(
                          '${AppController.strings.Step3}:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  width: 25,
                                  child: Radio(
                                      value: 0,
                                      groupValue: _LanggroupValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _LanggroupValue = newValue;
                                          print(_LanggroupValue);
                                        });
                                        //  changeLng( ) ;
                                      }),
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        _LanggroupValue = 1;
                                      });
                                      //  changeLng( );
                                    },
                                    child: Text('Knet'))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  width: 25,
                                  child: Radio(
                                      value: 1,
                                      groupValue: _LanggroupValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _LanggroupValue = newValue;
                                          print(_LanggroupValue);
                                        });
                                        //  changeLng( ) ;
                                      }),
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        _LanggroupValue = 2;
                                      });
                                      //  changeLng( );
                                    },
                                    child: Text('MasterCard'))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  width: 25,
                                  child: Radio(
                                      value: 2,
                                      groupValue: _LanggroupValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _LanggroupValue = newValue;
                                          print(_LanggroupValue);
                                        });
                                        //  changeLng( ) ;
                                      }),
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        _LanggroupValue = 3;
                                      });
                                      //  changeLng( );
                                    },
                                    child: Text('Cash On delivery'))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
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
                                      '${AppController.strings.Continue}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                elevation: 0.2,
                                onPressed: () {
                                  ignoring2=false;

                                  button(false);
                                  setState(() {
                                    selected = 3;

                                  });
                                }),
                          ),
                        ],
                      ))),
              IgnorePointer(
                  ignoring: ignoring2,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: Colors.black87),
                      )),
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.grey.shade400,

                        key: Key(3.toString()), //attention
                        initiallyExpanded: 3 == selected,
                        backgroundColor: Colors.white,
                        onExpansionChanged: ((newState) {
                          if (newState)
                            setState(() {
                              selected = 3;
                            });
                          else
                            setState(() {
                              selected = -1;
                            });
                        }),
                        title: Text(
                          '${AppController.strings.PromoCode}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        leading: Text(
                          '${AppController.strings.Step4}:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                                textAlign: TextAlign.center,
                                onChanged: (value) {},
                                controller: _discountsController,
                                decoration: KDecoration.copyWith(
                                    labelText:
                                        '${AppController.strings.EnterPromoCode}')),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        color: Color(0xff957e7e),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${AppController.strings.Skip}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        elevation: 0.2,
                                        onPressed: () {
                                          ignoring3=false;
                                          button(false);
                                          setState(() {
                                            selected = 4;
                                          });
                                        }),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side:
                                                BorderSide(color: Colors.red)),
                                        color: Color(0xfff50000),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${AppController.strings.Continue}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        elevation: 0.2,
                                        onPressed: () {
                                          discounts();
                                          ignoring3=false;
                                        }),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ))),
              IgnorePointer(
                  ignoring: ignoring3,
                  child: ExpansionTile(
                    collapsedBackgroundColor: Colors.grey.shade400,

                    key: Key(3.toString()), //attention
                    initiallyExpanded: 4 == selected,
                    backgroundColor: Colors.white,
                    onExpansionChanged: ((newState) {
                      if (newState)
                        setState(() {
                          Duration(seconds: 20000);
                          selected = 4;
                        });
                      else
                        setState(() {
                          selected = -1;
                        });
                    }),
                    title: Text(
                      '${AppController.strings.confirmOrder}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    leading: Text(
                      '${AppController.strings.Step5}:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.ConfirmedItems.length.ceil(),
                                addSemanticIndexes: true,
                                itemBuilder: (context, index) {
                                  totalSummationOfItem = widget
                                          .ConfirmedItems[index].price
                                          .toDouble() *
                                      widget.ConfirmedItems[index].qnty
                                          .toDouble();
                                  return Column(
                                    children: [
                                      Container(
                                        color: Colors.black12,
                                        child: Row(
                                          children: [
                                            Text(widget
                                                .ConfirmedItems[index].name),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                  '${AppController.strings.Quantity}'),
                                              Text(widget
                                                  .ConfirmedItems[index].qnty
                                                  .toString())
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                  '${AppController.strings.price_unit}'),
                                              Text(widget
                                                  .ConfirmedItems[index].price
                                                  .toString())
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                  '${AppController.strings.totalprice_unit}'),
                                              Text(totalSummationOfItem
                                                  .toString())
                                            ],
                                          )
                                        ],
                                      ),
                                      Divider(),
                                    ],
                                  );
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                        '${AppController.strings.PricebeforeDiscount}'),
                                  ),
                                  Container(
                                    child: Text(
                                        '${widget.TotalPrice} ${AppController.strings.KD}'),
                                  )
                                ],
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                        '${AppController.strings.PriceAfterDiscount}'),
                                  ),
                                  discountBool == false
                                      ? Container(
                                          child: Text(
                                              '${AppController.strings.Nodiscount}'),
                                        )
                                      : Container(),
                                ],
                              ),
                              Divider(
                                color: Colors.black87,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      '${AppController.strings.TotalSummation}',
                                      style: TextStyle(fontSize: 19),
                                    ),
                                  ),
                                  Container(
                                      child: Text(
                                          '${widget.TotalPrice} ${AppController.strings.KD}')),
                                ],
                              )
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            // Expanded(
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: RaisedButton(
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(5),
                            //         ),
                            //         color: Color(0xff957e7e),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.center,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.center,
                            //           children: [
                            //             Text(
                            //               '${AppController.strings.Skip}',
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontWeight: FontWeight.bold,
                            //                   fontSize: 18),
                            //             ),
                            //           ],
                            //         ),
                            //     elevation: 0.2,
                            //     onPressed: () {
                            //
                            //         }),
                            //   ),
                            // ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: BorderSide(color: Colors.red)),
                                    color: Color(0xfff50000),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Continue',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    elevation: 0.2,
                                    onPressed: () {
                                      button(false);
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 300,
                        child: Row(
                          children: [
                            Text('${AppController.strings.agree}',
                                style: TextStyle(fontSize: 16)),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TermsConditions(),
                                  ),
                                );
                              },
                              child: Text('${AppController.strings.terms}',
                                  style: TextStyle(
                                      color: Color(0xFFFF4F4F), fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: 15,
                          height: 15,
                          child: Checkbox(
                            value: _isChecked,
                            onChanged: (val) {
                              setState(() {
                                _isChecked = val;
                              });
                            },
                          ))
                    ],
                  )),
            ],
          ),
        ));
  }

  Future Showtoast(
    String Msg,
  ) {
    Fluttertoast.showToast(
        msg: Msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xFFFFADAD),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

//     Collapse(
//              title: Container(
//               child: Row(children: [
//               Text(
//                 '${AppController.strings.Step1} ',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 Text('${AppController.strings.DeliveryMethod}'),
//
//             ],)
//                 ),
//
//                 body: Column(children: [
//                   Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 25,
//                           child: Radio(
//                               value: _LanggroupValue,
//                               groupValue: _LanggroupValue,
//                               onChanged: (newValue) {
//                                 setState(() {
//                                   _LanggroupValue = newValue;
//                                 });
//                                 //  changeLng( ) ;
//                               }),
//                         ),
//                         InkWell(
//                             onTap: () {
//                               setState(() {
//                                 _LanggroupValue = 1;
//                               });
//                               //  changeLng( );
//                             },
//                             child:
//                             Text('${AppController.strings.Homedelivery}'))
//                       ],
//                     ),
//                   ),
//                   Padding(
//                       padding: EdgeInsets.all(10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 top: 5, right: 5, left: 5, bottom: 5),
//                             child: Text(
//                               '${AppController.strings.CheckYourAddress}',
//                               style: TextStyle(fontSize: 18),
//                             ),
//                           ),
//                           AddressCard(
//                             AddressList: AddressList,
//                           ),
//                         ],
//                       )),
//                   Padding(
//                     padding: EdgeInsets.all(10),
//                     child: RaisedButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                             side: BorderSide(color: Colors.red)),
//                         color: Color(0xfff50000),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               '${AppController.strings.Continue}',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18),
//                             ),
//                           ],
//                         ),
//                         elevation: 0.2,
//                         onPressed: () {
//                           button(false);
//                           setState(() {
//                             Duration(seconds: 20000);
//                             selected = 1;
//                             status2 =true;
//
//                           });
//                         }),
//                   ),
//                 ],),
//                 value: status1,
//                 onChange: (bool value) {
//                   setState(() {
//                     status1 = value;
//                   });
//                 },
//               ),
//
//            Collapse(
//                 padding: EdgeInsets.all(0),
//                 title: Text('2'),
//                 body: Container(
//                   color: Colors.blue,
//                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//
//                     ],
//                   ),
//                 ),
//                 value: status2,
//                 onChange: (bool value) {
//                   setState(() {
//
//                   });
//                 },
//               ),
