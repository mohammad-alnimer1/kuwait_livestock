
import 'package:flutter/material.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/nav_bar/Shopping_cart.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:provider/provider.dart';
  class ShowDialog extends StatelessWidget {
    String titel ;
    String content;
    ShowDialog({this.content,this.titel});

  @override
  Widget build(BuildContext context) {
     showDialog(context: context, builder: (BuildContext context)
     {
       return AlertDialog(

         title: Text(titel),
         //Text("${ AppController.strings.KuwaitiLivestock}"),
         content: Text(
             content), //Text("${AppController.strings.itemsuccessfullyadd}"),

       );
     });
  }
}


