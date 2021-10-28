import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/AppHelper/AppSharedPrefs.dart';
import 'package:kuwait_livestock/AppHelper/staticWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:timer_button/timer_button.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../../AppHelper/Constants.dart';
import '../nav_bar.dart';

class AccountInformation extends StatefulWidget {
  @override
  _AccountInformationState createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  final _EditAccountInformation = GlobalKey<FormState>();
  final _EditProfileformKey = GlobalKey<FormState>();
  static final _UserNameController = TextEditingController();
  static final _emailcontroller = TextEditingController();
  static final _ChangePhoneController = TextEditingController();
  static final _Locationcontroller = TextEditingController();
  static final _PreviousUserNameController = TextEditingController();
  static final _userPasswordController = TextEditingController();
  static final _verificationCode = TextEditingController();

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  PhoneNumber number = PhoneNumber(isoCode: 'JO');
  var randomNum;
  TwilioFlutter twilioFlutter;

  getpref() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    _UserNameController.text = pre.getString('name');
    _emailcontroller.text = pre.getString('login');
    _ChangePhoneController.text = pre.getString('phone');
  }

  @override
  void initState() {
    super.initState();
    getpref();
    randomNum = getRandomString(6);
    print(randomNum); // 5GKjb

    twilioFlutter = TwilioFlutter(
        accountSid: 'AC1e97706c4fd096cf4ae9a706ffb5397c',
        authToken: '3bae9c32fbe0bce71272ce17255bf578',
        twilioNumber: '+18102672092');
  }

  var _data;
  Future profileform() async {
    var logindata = _EditAccountInformation.currentState;

    logindata.save();
    // show_loading(context);

    var data = {
      "login": _PreviousUserNameController.text,
      "password": _userPasswordController.text,
      "new_name": _UserNameController.text,
      "new_login": _emailcontroller.text,
      "new_phone": phonenum.toString(),
    };

    var url = "http://kuwaitlivestock.com:5000/change_login_name";
    dynamic response = await http.post(url, body: data);
    print(response.body);

    String jsonsDataString = response.body;
    _data = jsonDecode(jsonsDataString.replaceAll("'", '"'));
    print('hi hi hi hi hihi hi ${_data['message']}');

    if (_data['result'] == "success") {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("name", _UserNameController.text);
      pref.setString("login", _emailcontroller.text);
      pref.setString("phone", phonenum.toString());
      print(pref.getString("name"));
      print(pref.getString("login"));
      print(pref.getString("phone"));

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => navigation_bar()));
    } else {
      Navigator.of(context).pop();
      // show_dialogall(context,"filed","wrong email or password plese check");
    }
  }

  var phonenum;
  var b;
  getvalu() {
    b = phonenum.toString();
    print(b + 'phooooooooooon');
    return b;
  }

  void sendSms() async {
    twilioFlutter.sendSMS(
        toNumber: '${phonenum}}',
        messageBody:
            '${AppController.strings.Dear}, \n${randomNum},${AppController.strings.smsText}');
  }

  bool showTextForm=false ;
  bool showTextForm1 ;


  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: AppController.textDirection,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black87),
            backgroundColor: Colors.white,
            title: Text(
              '${AppController.strings.EditProfile}',
              style: TextStyle(color: Colors.black87),
            ),
            centerTitle: true,
          ),
          body: Form(
            key: _EditAccountInformation,
            child: Container(
              child: ListView(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${AppController.strings.name}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          TextFormField(
                              validator: (value) => value.isEmpty
                                  ? '${AppController.strings.FillUserNameData}'
                                  : null,
                              controller: _UserNameController,
                              keyboardType: TextInputType.text,
                              autocorrect: true,
                              decoration: KDecoration.copyWith(
                                  hintText:
                                      '${AppController.strings.ChangeUserName}'))
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${AppController.strings.email}',
                            style: TextStyle(fontSize: 18),
                          ),
                          TextFormField(
                              validator: (value) => value.isEmpty
                                  ? '${AppController.strings.FillLocation}'
                                  : null,
                              controller: _emailcontroller,
                              keyboardType: TextInputType.text,
                              autocorrect: true,
                              decoration: KDecoration.copyWith(
                                  hintText: '${AppController.strings.email}'))
                        ],
                      )),
                  // Padding(
                  //     padding: EdgeInsets.all(10),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.stretch,
                  //       children: [
                  //         Text('${AppController.strings.countryName}',
                  //             style: TextStyle(fontSize: 18),),
                  //         TextField(
                  //             controller: _Locationcontroller,
                  //             keyboardType: TextInputType.emailAddress,
                  //             onChanged: (value) {},
                  //             decoration: KDecoration.copyWith(
                  //                 hintText:
                  //                     '${AppController.strings.ChangeLocation}'))
                  //       ],
                  //     )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${AppController.strings.phoneNum}',
                            style: TextStyle(fontSize: 18),
                          ),
                          Row(
                            children: [
                         Container(child:      TextFormField(
                             enabled: false,
                             controller: _ChangePhoneController,
                             keyboardType: TextInputType.text,
                             autocorrect: true,
                             decoration: KDecoration.copyWith(
                               filled: true,
                             )),width: 220,),
                              TextButton(onPressed: (){
                              setState(() {
                                showTextForm=!showTextForm;
                              });

                              },child: Text(AppController.strings.ChangePhoneNumber),),
                            ],
                          )
                        ],
                      )),
                  showTextForm==true? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InternationalPhoneNumberInput(
                      inputDecoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              if(showTextForm1==true){
                                sendSms();
                                setState(() {
                                  showDialog(

                                      context: context,
                                      builder: (BuildContext context) {
                                        return  Directionality(
                                            textDirection: AppController.textDirection,
                                            child: AlertDialog(
                                              scrollable: true,
                                                titlePadding: EdgeInsets.all(0),
                                                titleTextStyle: TextStyle(),
                                                title: Container(child:Text(
                                                  '${AppController.strings.ConfirmPhoneNumber}',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87
                                                  ),
                                                ),),
                                                content:Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Text(AppController.strings.smsCodeAccount),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                      child: TextFormField(
                                                        validator: staticWidget().validEmpty,
                                                        controller: _verificationCode,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Icon(Icons.phone_iphone),
                                                            hintText:
                                                            "${AppController.strings.EnterTheCode}"),
                                                      ),
                                                    ),
                                                    TimerButton(
                                                      label: "${AppController.strings.ReSend}",
                                                      timeOutInSeconds: 50,
                                                      onPressed: () {
                                                        getvalu();
                                                        sendSms();
                                                      },
                                                      disabledColor: Colors.white,
                                                      color: Colors.white10,
                                                      disabledTextStyle:
                                                      new TextStyle(fontSize: 20.0),
                                                      activeTextStyle: new TextStyle(
                                                          fontSize: 20.0, color: Colors.white),
                                                    ),
                                                    RaisedButton(
                                                      textColor: Colors.white,
                                                        color: Color(0xfff50000),
                                                        child: Text('${AppController.strings.confirm}'),
                                                        onPressed: (){

                                                          if(_verificationCode.text.isNotEmpty && randomNum==_verificationCode.text ){
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return Directionality(
                                                                      textDirection: AppController.textDirection,
                                                                      child: AlertDialog(
                                                                        titlePadding: EdgeInsets.all(0),
                                                                        titleTextStyle: TextStyle(),
                                                                        title: Container(
                                                                            height: 50,
                                                                            width: 150,
                                                                            child: Center(
                                                                                child: Text(
                                                                                  '${AppController.strings.EditProfile}',
                                                                                  style: TextStyle(
                                                                                      fontSize: 20,
                                                                                      fontWeight: FontWeight.bold),
                                                                                )),
                                                                            color: Colors.orangeAccent),
                                                                        content: Form(
                                                                          key: _EditProfileformKey,
                                                                          child: Container(
                                                                            width: 250,
                                                                            height: 200,
                                                                            child: ListView(
                                                                              // mainAxisSize: MainAxisSize.min,
                                                                              children: <Widget>[
                                                                                Padding(
                                                                                    padding: EdgeInsets.all(5),
                                                                                    child: TextFormField(
                                                                                      validator: (value) => value
                                                                                          .isEmpty
                                                                                          ? '${AppController.strings.FillUserNameData}'
                                                                                          : null,
                                                                                      controller:
                                                                                      _PreviousUserNameController,
                                                                                      keyboardType:
                                                                                      TextInputType.text,
                                                                                      autocorrect: true,
                                                                                      decoration:
                                                                                      KDecoration.copyWith(
                                                                                          hintText:
                                                                                          '${AppController.strings.CurrantEmail}'),
                                                                                    )),
                                                                                Padding(
                                                                                    padding: EdgeInsets.all(5),
                                                                                    child: TextFormField(
                                                                                      validator: (value) => value
                                                                                          .isEmpty
                                                                                          ? '${AppController.strings.FillPhoneNumberData}'
                                                                                          : null,
                                                                                      controller:
                                                                                      _userPasswordController,
                                                                                      keyboardType:
                                                                                      TextInputType.text,
                                                                                      autocorrect: true,
                                                                                      decoration:
                                                                                      KDecoration.copyWith(
                                                                                          hintText:
                                                                                          '${AppController.strings.userPassword}'),
                                                                                    )),
                                                                                Row(
                                                                                  mainAxisAlignment:
                                                                                  MainAxisAlignment
                                                                                      .spaceBetween,
                                                                                  children: [
                                                                                    RaisedButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Text(
                                                                                          '${AppController.strings.cancel}'),
                                                                                    ),
                                                                                    RaisedButton(
                                                                                      onPressed: () {
                                                                                        if (_EditProfileformKey
                                                                                            .currentState
                                                                                            .validate()) {
                                                                                          profileform();
                                                                                        }
                                                                                      },
                                                                                      color: Color(0xfff50000),
                                                                                      child: Text(
                                                                                          '${AppController.strings.send}'),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ));
                                                                });
                                                          }
                                                        }
                                                    )
                                                  ],
                                                ),
                                            )
                                            );
                                      });

                                });
                              }

                            }),
                        prefixIcon: Icon(Icons.phone_android),
                        hintText: AppController.strings.phoneNum,
                      ),
                      onInputChanged: (PhoneNumber number) {
                        phonenum = number.phoneNumber;
                        print('phonenum=$phonenum');
                      },
                      errorMessage:'Invalid phone number' ,

                      onInputValidated: (bool value) {
                        print("value$value");
                        showTextForm1=value;
                        print(showTextForm1);
                      setState(() {
                        if (value == false ) {
                          setState(() {
                          return  value == false;
                          });

                        }else if(value == true){
                          setState(() {

                             showTextForm1 == value;
                          });

                        }
                      });
                      },
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      initialValue: number,
                      //textFieldController: _ChangePhoneController,

                      formatInput: false,

                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      validator: staticWidget().validEmpty,
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      },
                    ),
                  ):Container(),



                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: RaisedButton(
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.red)),
                      color: Color(0xfff50000),
                      child: Text(
                        '${AppController.strings.Change}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      elevation: 0.2,
                      onPressed: () {
                        setState(() {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Directionality(
                                    textDirection: AppController.textDirection,
                                    child: AlertDialog(
                                      titlePadding: EdgeInsets.all(0),
                                      titleTextStyle: TextStyle(),
                                      title: Container(
                                          height: 50,
                                          width: 150,
                                          child: Center(
                                              child: Text(
                                            '${AppController.strings.EditProfile}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          )),
                                          color: Colors.orangeAccent),
                                      content: Form(
                                        key: _EditProfileformKey,
                                        child: Container(
                                          width: 250,
                                          height: 200,
                                          child: ListView(
                                            // mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: TextFormField(
                                                    validator: (value) => value
                                                            .isEmpty
                                                        ? '${AppController.strings.FillUserNameData}'
                                                        : null,
                                                    controller:
                                                        _PreviousUserNameController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: true,
                                                    decoration:
                                                        KDecoration.copyWith(
                                                            hintText:
                                                                '${AppController.strings.CurrantEmail}'),
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: TextFormField(
                                                    validator: (value) => value
                                                            .isEmpty
                                                        ? '${AppController.strings.FillPhoneNumberData}'
                                                        : null,
                                                    controller:
                                                        _userPasswordController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    autocorrect: true,
                                                    decoration:
                                                        KDecoration.copyWith(
                                                            hintText:
                                                                '${AppController.strings.userPassword}'),
                                                  )),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  RaisedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                        '${AppController.strings.cancel}'),
                                                  ),
                                                  RaisedButton(
                                                    onPressed: () {
                                                      if (_EditProfileformKey
                                                          .currentState
                                                          .validate()) {
                                                        profileform();
                                                      }
                                                    },
                                                    color: Color(0xfff50000),
                                                    child: Text(
                                                        '${AppController.strings.send}'),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              });
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
    );

  }


}
