import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/Login_Page.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:timer_button/timer_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:timer_button/timer_button.dart';

import 'AppHelper/buttonClass.dart';

class Verification extends StatefulWidget {
  final myRandomnum;
  final myphonenum;
  final myFullname;
  final myEmail;
  final myPassword;
  Verification(
      {this.myphonenum, this.myFullname, this.myEmail, this.myPassword,this.myRandomnum});
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  static final _verificationCode = TextEditingController();

  String validdata(String val){
    if(val.trim().isEmpty){
      return "${AppController.strings.pleaseFilltheData}";
    }
  }

  final VerificationKey = GlobalKey<FormState>();


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
     // 5GKjb

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
        toNumber: '${widget.myphonenum}}',
        messageBody:
            '${AppController.strings.Dear}, \n${randomNum},${AppController.strings.smsText}');
  }

  @override
  Widget build(BuildContext context) {
    AppProvider auth = Provider.of<AppProvider>(context);

     Registrationform()  {
      if (randomNum==_verificationCode.text||widget.myRandomnum==_verificationCode.text){
        print('enter user');
        print(randomNum);
        print(_verificationCode.text);

      final successfulMessage = auth.Registrationform(
        widget.myFullname,
        widget.myEmail,
        widget.myPassword,
        widget.myphonenum,
      );

      successfulMessage.then((response) {
        if (response['result'] == "success") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LogInPage()));
          _showMaterialDialog();
        } else {
          Navigator.of(context).pop();
          // show_dialogall(context,"filed","wrong email or password plese check");
        }
      });
      }
    }

    bool onPressedValue = true;
    int timeOutInSeconds = 20;

    return Directionality(
        textDirection: AppController.textDirection,
        child: Scaffold(
          key: VerificationKey,
          resizeToAvoidBottomInset: false,
          body: Container(
            color: Colors.white,
            child: Form(
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '${AppController.strings.Verification},',
                              style: TextStyle(fontSize: 30),
                            ),
                            Text(
                              '${AppController.strings.message}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 2,
                    child: ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: TextFormField(
                                validator: validdata,
                                controller: _verificationCode,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.phone_iphone),
                                    hintText:
                                        "${AppController.strings.EnterTheCode}"),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: button(
                                  buttonName: '${AppController.strings.Next} ',
                                  color: Colors.grey,
                                  onpress: () {
                                    Registrationform();
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => NavBarWidget(),
                                    //   ),
                                    // );
                                  },
                                )),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Row(
                                children: [
                                  Text(
                                      '${AppController.strings.DidntgettheCode}',
                                      style: TextStyle(fontSize: 18)),

                                  TimerButton(
                                    label: "${AppController.strings.ReSend}",
                                    timeOutInSeconds: 50,
                                    onPressed: () {
                                      getvalu();
                                      sendSms();
                                    },
                                    disabledColor: Colors.red,
                                    color: Colors.white10,
                                    disabledTextStyle:
                                        new TextStyle(fontSize: 20.0),
                                    activeTextStyle: new TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                  )

                                  // InkWell(
                                  //   child: Text(
                                  //     'RESEND IT',
                                  //     style:
                                  //     TextStyle(fontSize: 18, color: Colors.lightBlueAccent),
                                  //   ),
                                  //   // onTap: () {
                                  //   //   Navigator.push(
                                  //   //     context,
                                  //   //     MaterialPageRoute(
                                  //   //       builder: (context) =>  SignUp(),
                                  //   //     ),
                                  //   //   );
                                  //   // },
                                  // )
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            height: 150,
            width: 200,
          ),
        ));
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("${AppController.strings.Note}"),
              content:
                  new Text("${AppController.strings.ClientAccountcreated}"),
              actions: <Widget>[
                FlatButton(
                  child: Text('${AppController.strings.ok}'),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                )
              ],
            ));
  }
}
