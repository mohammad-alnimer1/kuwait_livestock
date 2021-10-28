import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'GetinTouch.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  String _phone = '0787174588';
  String email = 'mohammad@gmail.com';

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  List contactUs;
  loginform() async {
    var data = '';
    var url = "http://kuwaitlivestock.com:5000/call_us";
    var response = await http.post(url, body: data);
    setState(() {
      contactUs = jsonDecode(response.body.replaceAll("'", '"'));
      print(contactUs);

    });
  }

  @override
  void initState() {
    loginform();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Directionality(
        textDirection: AppController.textDirection,
        //textDirection: AppController.textDirection,
        //debugShowCheckedModeBanner: false,
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: Text(
          '${AppController.strings.ContactUs}',
          style: TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ),
          body: ListView(
          children: [
           Flex(
             crossAxisAlignment: CrossAxisAlignment.stretch,

             direction: Axis.vertical,
             children: [
               Container(
                 height: 250,
                   margin: EdgeInsets.all(10),
                   decoration: BoxDecoration(
                     image: DecorationImage(
                       fit: BoxFit.fill,
                       image: AssetImage(
                         'images/logo.jpeg',
                       ),
                     ),
                     borderRadius: BorderRadius.all(Radius.circular(40)),
                   )),
               Padding(
                 padding: const EdgeInsets.all(10),
                 child: Container(
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(10),
                       color: Colors.black12),
                   height: 50,
                   child: Row(
                     children: [
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(
                           'Kuwait',
                           style: TextStyle(fontSize: 18),
                         ),
                       )
                     ],
                   ),
                 ),
               ),
               Container(
                 width: double.infinity,
                 child: Padding(
                   padding: const EdgeInsets.all(10),
                   child: Text(
                     'data data data data data data data data data data data data data',
                     style: TextStyle(fontSize: 18),
                   ),
                 ),
               ),
               InkWell(
                 onTap: () {
                   setState(() {
                     _makePhoneCall('tel:$_phone');
                   });
                 },
                 child: Padding(
                   padding: const EdgeInsets.all(10),
                   child: Container(
                     decoration: BoxDecoration(
                         border: Border.all(
                           color: Color(0xfff50000),
                         ),
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.white),
                     height: 50,
                     child: Row(
                       children: [
                         Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Icon(Icons.phone)),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text(
                             '079999999999',
                             style: TextStyle(
                                 fontSize: 18, color: Color(0xfff50000)),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ),
               InkWell(
                 onTap: () {
                   setState(() {
                     _makePhoneCall('mailto:${email}');
                   });
                 },
                 child: Padding(
                   padding: const EdgeInsets.all(10),
                   child: Container(
                     decoration: BoxDecoration(
                         border: Border.all(
                           color: Color(0xfff50000),
                         ),
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.white),
                     height: 50,
                     child: Row(
                       children: [
                         Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Icon(Icons.email_outlined)
                         ),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text(
                             'mohammafd@gmail.com',
                             style: TextStyle(
                                 fontSize: 18, color: Color(0xfff50000)),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.all(10),
                 child: Container(
                   height: 50,
                   child: RaisedButton(
                     shape:RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                         side: BorderSide(color: Colors.red)
                     ) ,
                     color: Color(0xfff50000),

                     child: Text(
                       '${AppController.strings.GetinTouch}',
                       style: TextStyle(color:Colors.white,
                           fontWeight: FontWeight.bold, fontSize: 18),
                     ),
                     elevation: 0.2,
                     onPressed: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) =>  GetinTouch(),
                         ),
                       );
                     },
                   ),
                 ),
               ),
             ],
           )

        ],
      ),
    ));
  }
}
