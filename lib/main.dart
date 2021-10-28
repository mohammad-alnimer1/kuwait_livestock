import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:kuwait_livestock/homePage.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:flutter/services.dart';

import 'AppHelper/AppController.dart';
import 'AppHelper/AppString.dart';
import 'nav_bar/nav_bar.dart';
import 'LanguagePageMain.dart';

void main() async {
  runApp(ChangeNotifierProvider<AppProvider>(
    create: (_) => AppProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isLogin = false;

  getLoggedInState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    isLogin = preferences.getBool('isLogin');
    return isLogin;
  }

  var languageState;
  langState()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      languageState = preferences.getString("lng");
      if(languageState=='Ar'){
        AppController.strings = ArabicString();
      }else if(languageState=='En') {
        AppController.strings = EnglishString();
      }
    });
  }

  @override
  void initState() {
    langState();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white


    ));
    Widget example = Stack(
      children: [
        SplashScreenView(
          home: navigation_bar(),
          duration: 5000,
          imageSize: 500,
          imageSrc: "images/logo.jpeg",
          textType: TextType.NormalText,
          textStyle: TextStyle(
            fontFamily: 'Nasser ☞',
            fontSize: 14,
            color: const Color(0xff393b75),
            fontWeight: FontWeight.w700,
            height: 1.0714285714285714,
          ),
          backgroundColor: Colors.white,
        ),
      ],
    );

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(  elevation: 0,
      )),

      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      home:
      //isLogin == true &&
          languageState=='Ar'||languageState=='En'? example : LangpageMain(),
    );
  }
}


