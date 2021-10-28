import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/AppHelper/networking.dart';
import 'package:kuwait_livestock/AppHelper/staticWidget.dart';
import 'package:kuwait_livestock/api/Api.dart';
import 'package:kuwait_livestock/homePage.dart';
import 'AppHelper/AppSharedPrefs.dart';
import 'AppHelper/Constants.dart';
import 'Module/AddressModel.dart';
import 'Registration.dart';
import 'AppHelper/buttonClass.dart';
import 'nav_bar/nav_bar.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController PasswordController = new TextEditingController();
  var _data;
  Future loginform() async {
    var logindata = GlobalFormKey.currentState;
    if (logindata.validate()) {
      logindata.save();
      // show_loading(context);

      var data = {
        "login": emailController.text,
        "password": PasswordController.text
      };
      var url = "http://kuwaitlivestock.com:5000/login_data";
      dynamic response = await http.post(url, body: data);
      print(response.body);

      String jsonsDataString = response.body;
      _data =jsonDecode(jsonsDataString.replaceAll("'",'"')) ;
      print('hi hi hi hi hihi hi ${_data['name']}'  );
      if (_data ['result'] == "success"){

        savepreflogin(id: _data['user_id'],name:_data['name'],phone: _data['phone'],login: _data['login'], );
        AppSharedPrefs.saveIsLoginSP(true);
        print(await AppSharedPrefs.saveIsLoginSP(true));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navigation_bar()));
      } else {
        Showtoast();
        // show_dialogall(context,"filed","wrong email or password plese check");

      }
    }else{

    }
  }

  List<AddressModel> AddressList = List<AddressModel>();

  Future<dynamic> getAddress() async {
    final NetworkHelper networkHelper = NetworkHelper(Api().baseURL + 'GetAddress?user_id=${ _data['user_id']}');
    final Productdata = await networkHelper.getdata();


    Productdata.forEach((data) {
      var model = AddressModel();
      model.Addressid = data['id'];
     // print('hi hi hi hih ih hi hi id ${id}');
      model.AddressName = data['name_address'];
      model.longitude = data['longitude'];
      model.latitude = data['latitude'];
      model.country_id = data['country_id'];
      model.state_id = data['state_id'];
      model.building_address = data['building_address'];
      model.note_address = data['note_address'];
      model.street = data['street'];

      setState(() {
        print(Productdata);
        AddressList.add(model);
      });
    });
  }

  // savepreflogin(String name,String login,String id) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.setString("user_id",id);
  //   pref.setString("name", name);
  //   pref.setString("login", login);
  //   print (pref.getString("id"));
  //   print(pref.getString("name"));
  //   print(pref.getString("login"));
  //
  // }

  // void main()async {
  //   String url = "http://kuwaitlivestock.com:5000/login_data";
  //   var response = await http.post(url, body: {
  //     "password" :PasswordController.text,
  //     "login":emailController.text
  //   });
  //
  //   var body = jsonEncode(response.body);
  //
  //   if(response.statusCode == 200){
  //     debugPrint("Data posted successfully");
  //   }else{
  //     debugPrint("Something went wrong! Status Code is: ${response.statusCode}");
  //   }
  //
  // }


  GlobalKey<FormState> GlobalFormKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  Directionality(
        textDirection: AppController.textDirection,
        child:  Scaffold(

      bottomNavigationBar: Container(
        height: 150,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: button(
                buttonName: '${AppController.strings.login}',
                color: Colors.indigoAccent,
                onpress: () async {
                  setState(() {
                    loginform();
                  });
                  // print(email);
                  // print(password);
                  // try {
                  //   setState(() {
                  //     ShowSpinar=true;
                  //   });
                  //   final newuser = await _auth.createUserWithEmailAndPassword(
                  //       email: email, password: password);
                  //
                  //
                  //   if (newuser != null) {
                  //     Navigator.pushNamed(context, ChatScreen.id);
                  //   }
                  //
                  //
                  // } catch (e) {
                  //   setState(() {
                  //     ShowSpinar=false;
                  //   });
                  //   print(e);
                  // }
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${AppController.strings.createANewAccount}',
                      style: TextStyle(fontSize: 16),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationPage()));
                      },
                      child: Text(
                        '${AppController.strings.registration}',
                        style:
                            TextStyle(color: Color(0xFFFF4F4F), fontSize: 16),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body:Form(
    key: GlobalFormKey,
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
            width: double.infinity,
            child: Image.asset(
              'images/logo.jpeg',
              fit: BoxFit.fill,
            ),
            color: Colors.white,
          )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                color: Colors.black12.withOpacity(0.01),
                child:  ListView(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '${AppController.strings.login}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                            autocorrect: false,
                          validator: staticWidget().emailvalid,
                            controller: emailController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {},
                            decoration: KDecoration.copyWith(
                                labelText: '${AppController.strings.enterYourEmail}')),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                            autocorrect: false,
                          validator: staticWidget().validEmpty,
                            controller: PasswordController,
                            textAlign: TextAlign.center,
                            onChanged: (value) {},
                            decoration: KDecoration.copyWith(
                                labelText: '${AppController.strings.enterpassword}')),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: InkWell(
                          child: Text(
                            '${AppController.strings.forgotYourPassword}',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFFF4F4F)),
                          ),
                          onTap: () {},
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

        ],
      )),
    ));
  }

  Future Showtoast(){
    Fluttertoast.showToast(

        msg: "${AppController.strings.wrongEmailOrPassword}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xFFFFADAD),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
