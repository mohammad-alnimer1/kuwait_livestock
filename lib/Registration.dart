import 'dart:convert';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:http/http.dart' as http;
import 'package:kuwait_livestock/AppHelper/staticWidget.dart';
import 'package:kuwait_livestock/Login_Page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'AppHelper/Constants.dart';
import 'AppHelper/buttonClass.dart';
import 'AppHelper/staticWidget.dart';
import 'Verification_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  var randomNum;

  TwilioFlutter twilioFlutter;
  @override
  void initState() {
    randomNum = getRandomString(6);
    print(randomNum); // 5GKjb

    twilioFlutter = TwilioFlutter(
        accountSid: 'AC1e97706c4fd096cf4ae9a706ffb5397c',
        authToken: '3bae9c32fbe0bce71272ce17255bf578',
        twilioNumber: '+18102672092');

    super.initState();
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

  String validdata(String val) {
    if (val.trim().isEmpty) {
      return "${AppController.strings.pleaseFilltheData}";
    }
  }

  final RegistrationKey = GlobalKey<FormState>();
  String emailController;
  String nameController;
  String passwordController;
  String phoneController;
  PhoneNumber number = PhoneNumber(isoCode: 'JO');

  bool _isChecked = false;
  String _currText = '';
  @override
  Widget build(BuildContext context) {
    AppProvider auth = Provider.of<AppProvider>(context);

    Future Registrationform() async {
      var Registration = RegistrationKey.currentState;
      if (Registration.validate()) {
        Registration.save();
        if (_isChecked == true) {
          sendSms();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Verification(
                        myEmail: emailController,
                        myFullname: nameController,
                        myPassword: passwordController,
                        myphonenum: phonenum,
                        myRandomnum: randomNum,
                      )));
        } else {
          Showtoast();
          // show_dialogall(context,"filed","wrong email or password plese check");
        }
      }
    }

    return Directionality(
        textDirection: AppController.textDirection,
        child: Form(
          key: RegistrationKey,
          child: Scaffold(
            bottomNavigationBar: Container(
              height: 150,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: button(
                      buttonName: '${AppController.strings.signUp}',
                      color: Colors.indigoAccent,
                      onpress: () async {
                        try {
                          setState(() {
                            // ShowSpinar=true;

                            Registrationform();
                          });
                        } catch (e) {
                          setState(() {
                            // ShowSpinar=false;
                          });
                          print(e);
                        }
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${AppController.strings.alreadyHaveAccount} ',
                            style: TextStyle(fontSize: 16),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              '${AppController.strings.login}',
                              style: TextStyle(
                                  color: Color(0xFFFF4F4F), fontSize: 16),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: CircleAvatar(
                      backgroundColor: Colors.black12,
                      maxRadius: 95,
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: 85,
                          child: Container(
                            child: Image.asset(
                              'images/head.jpeg',
                              fit: BoxFit.fill,
                            ),
                            height: 100,
                          )),
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        color: Colors.black12.withOpacity(0.01),
                        child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Center(
                                  child: Text(
                                '${AppController.strings.signUp}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1),
                              )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                  validator: staticWidget().namevalid,
                                  onSaved: (value) => nameController = value,
                                  // controller: nameController,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {},
                                  decoration: KDecoration.copyWith(
                                      labelText:
                                          '${AppController.strings.enterFullName}',
                                      labelStyle: TextStyle(fontSize: 18))),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                  validator: staticWidget().emailvalid,
                                  onSaved: (value) => emailController = value,

                                  // controller: emailController,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {},
                                  decoration: KDecoration.copyWith(
                                      labelText:
                                          '${AppController.strings.enterYourEmail}',
                                      labelStyle: TextStyle(fontSize: 18))),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                  validator: staticWidget().passwordValid,
                                  onSaved: (value) =>
                                      passwordController = value,

                                  // controller: passwordController,
                                  textAlign: TextAlign.center,
                                  obscureText: true,
                                  onChanged: (value) {},
                                  decoration: KDecoration.copyWith(
                                      labelText:
                                          '${AppController.strings.enterpassword}',
                                      labelStyle: TextStyle(fontSize: 18))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: InternationalPhoneNumberInput(
                                inputDecoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone_android),
                                  hintText: AppController.strings.phoneNum,
                                ),
                                onInputChanged: (PhoneNumber number) {
                                  phonenum = number.phoneNumber;
                                  print('phonenum=$phonenum');
                                },
                                onInputValidated: (bool value) {
                                  print(value);
                                },
                                selectorConfig: SelectorConfig(
                                  selectorType:
                                      PhoneInputSelectorType.BOTTOM_SHEET,
                                ),
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle:
                                    TextStyle(color: Colors.black),
                                initialValue: number,
                                //textFieldController: phoneController,

                                formatInput: false,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                validator: validdata,
                                onSaved: (PhoneNumber number) {
                                  print('On Saved: $number');
                                },
                              ),
                            ),
                            Container(
                              child: Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: 300,
                                        child: Row(
                                          children: [
                                            Text(
                                                '${AppController.strings.agree}',
                                                style: TextStyle(fontSize: 16)),
                                            InkWell(
                                              onTap: () {},
                                              child: Text(
                                                  '${AppController.strings.privacyPolicy}',
                                                  style: TextStyle(
                                                      color: Color(0xFFFF4F4F),
                                                      fontSize: 16)),
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
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  // _showCupertinoDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (_) => new CupertinoAlertDialog(
  //         title: new Text("Cupertino Dialog"),
  //         content: new Text("Hey! I'm Coflutter!"),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Close me!'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           )
  //         ],
  //       ));
  // }
  Showtoast() {
    Fluttertoast.showToast(
        msg: "${AppController.strings.mustAgree}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xFFFFADAD),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
