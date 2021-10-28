import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kuwait_livestock/AppHelper/AppColors.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/AppHelper/networking.dart';
import 'package:kuwait_livestock/api/Api.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../homePage.dart';



class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  bool loading=true;
  String About = "";

  var AboutUs;
  Future<void> getAboutUs()async{

    final  NetworkHelper networkHelper =NetworkHelper("${Api().baseURL+'WhoWe'}");
    AboutUs = await networkHelper.getdata();
 setState(() {
   AboutUs['image'];
   AboutUs['info'];

 });
    print(AboutUs['info']);
  }

  @override
  void initState() {
    getAboutUs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: AppController.textDirection,
      //debugShowCheckedModeBanner: false,
      child: Scaffold(

          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black87),
            centerTitle: true,
            title: Text(
              '${AppController.strings.about}',
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
          ),
          backgroundColor: Colors.white,
          body:AboutUs!=null? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Directionality(
              textDirection: AppController.textDirection,
              child: ListView(
                children: [
                  // AboutImg.runtimeType!=String?   Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: CircleAvatar(
                  //     backgroundColor: AppColors.greyColor,
                  //     radius: 90.0,
                  //     child: CircleAvatar(
                  //       backgroundColor: AppColors.whiteColor,
                  //       radius: 85,
                  //       child: Image.memory(AboutImg),
                  //     ),
                  //   ),
                  // ):
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black12,
                      radius: 110.0,
                     child: CircleAvatar(
                       backgroundColor: Colors.white,
                       radius: 100.0,
                        backgroundImage: AssetImage('images/logo.jpeg'),
                     ),
                    ),
                  ),
                  Text(
                    AppController.strings.about,
                    style: new TextStyle(fontSize: 25.0, color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 10.0,
                    child: Text(
                      '${AboutUs['info']}',

                      textDirection: AppController.textDirection,
                    ),
                  ),

                ],
              ),
            ),
          ):Container(
        height: double.infinity,
        child: Card(
          child: ModalProgressHUD(
              color: Colors.white12,
              inAsyncCall: loading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: loading
                        ? Center(
                        child: Text(
                            '${AppController.strings.PleaseWait}'))
                        : Center(
                      child: Text(
                        '${AppController.strings.NoNotification}',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),),
    );
  }
}
