import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../AppHelper/Constants.dart';
import '../nav_bar.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {


  final _PasswordformKey = GlobalKey<FormState>();


  static final _oldpasswordController = TextEditingController();
  static final _newpasswordController = TextEditingController();
  static final _repasswordController = TextEditingController();

  var UserEmail;
  var phoneNumber;
  var _data;
    Future ChangePasswordFun() async {
    var cahngepassword = _PasswordformKey.currentState;
    if (cahngepassword.validate()) {

      // show_loading(context);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      UserEmail= preferences.getString('login');
      phoneNumber= preferences.getString('phone');
      var data = {
        "login": UserEmail.toString(),
        "password":  _oldpasswordController.text,
        "new_name":"New Name",
        "new_password": _newpasswordController.text,
        "new_phone": phoneNumber,
      };
      var url = "http://kuwaitlivestock.com:5000/change_login_data";
      dynamic response = await http.post(url, body: data);
      print(response.body);
      String jsonsDataString = response.body;
      _data =jsonDecode(jsonsDataString.replaceAll("'",'"')) ;
      print('hi hi hi hi hi hi hi ${_data['name']}'  );
      if (_data ['result'] == "success"){
        Showtoast("${AppController.strings.changeDataSuccess}");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navigation_bar()));
      } else {

        Showtoast("${AppController.strings.PleaseCheckPassword}");
        // show_dialogall(context,"filed","wrong email or password plese check");

      }
    }else{

    }
  }
  String newconfpassvalid(String val) {
    if (val.trim().isEmpty) {
      return '${AppController.strings.errorPassword}';
    }
    if (val.length < 6) {
      return '${AppController.strings.Passwordliss6}';
    }
    if (val != _newpasswordController.text) {
      return '${AppController.strings.errorMatchPassword}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Directionality(
        textDirection: AppController.textDirection,
        //textDirection: AppController.textDirection,
        //debugShowCheckedModeBanner: false,
        child: Scaffold(appBar: AppBar(backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black87),

      centerTitle: true,
      title:  Text(
      '${AppController.strings.ChangePassword}',
      style: TextStyle(fontSize: 20,color: Colors.black87),
    ),),
    body:  Directionality(
    textDirection:
    AppController.textDirection,
    child: Form(
      key: _PasswordformKey,
      child: Container(
        child: ListView(
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
         Padding(
                padding:
                EdgeInsets.all(10),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text('${AppController.strings.OldPassword}',style: TextStyle(fontSize: 18),),
          TextFormField(
          obscureText: true,
          validator:  (val) {
            return val
                .isEmpty
                ? AppController
                .strings
                .OldPassword
                : null;
          },

                      controller:
                      _oldpasswordController,
                      keyboardType:
                      TextInputType.text,
                      autocorrect: true,
                      decoration: KDecoration.copyWith(
                          hintText: '${AppController.strings.OldPassword}')
                  )
                ],)
            ),
            Padding(padding: EdgeInsets.only(right: 15,left: 15)
                ,child: Divider(thickness: 1,),
            ),
            Padding(
                padding:
                EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text('${AppController.strings.NewPassword}',style: TextStyle(fontSize: 18),),
                    TextFormField(
                        obscureText: true,
                         validator: newconfpassvalid,
                        controller: _newpasswordController,
                        keyboardType: TextInputType.text,
                        autocorrect: true,
                        decoration: KDecoration.copyWith(
                            hintText: '${AppController.strings.NewPassword}')

                    )
                  ],
                )
            ),
            Padding(
                padding:
                EdgeInsets.all(10),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                  Text('${AppController.strings.ConfirmNewPassword}',style: TextStyle(fontSize: 18),),

                  TextFormField(
                      obscureText: true,
                        validator: newconfpassvalid,
                      controller: _repasswordController,
                      keyboardType: TextInputType.text,
                      autocorrect: true,
                      decoration:KDecoration.copyWith(
                          hintText: '${AppController.strings.ConfirmNewPassword}')
                  )
                ],)
            ),
            Padding(
              padding:
              const EdgeInsets.only(
                  left: 5,right: 5),
              child:
              RaisedButton(
                padding: EdgeInsets.all(10),
                shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.red)
                ) ,
                color: Color(0xfff50000),

                child: Text(
                  '${AppController.strings.Change}',
                  style: TextStyle(
                      color:Colors.white,
                      fontWeight:
                      FontWeight
                          .bold,
                      fontSize:
                      18),
                ),
                elevation: 0.2,
                onPressed: () {
                  ChangePasswordFun();
                },
              ),
            ),
          ],
        ),
      ),
    ))
    ));
  }
  Future Showtoast( String Msg,){

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
