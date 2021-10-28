import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:kuwait_livestock/provider/provider.dart';
import 'package:provider/provider.dart';

class TermsConditions extends StatefulWidget {
  @override
  _TermsConditionsState createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  bool loading = true;




  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context );
    provider.getTermsandConditions();
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
              '${AppController.strings.terms}',
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
          ),
          backgroundColor: Colors.white,

          body:ModalProgressHUD(
              inAsyncCall:provider.TermsandConditions==null? loading=true:loading=false,
              child:   Padding(
              padding: const EdgeInsets.all(10.0),
              child: Directionality(
                textDirection: AppController.textDirection,
                child: ListView(
                  children: [
                    SizedBox(height: 10,),
                    provider.TermsandConditions!=null? Container(
                      width: 10.0,
                      child: Text(
                        '${provider.TermsandConditions}',
                        maxLines: 500,
                        textDirection: AppController.textDirection,
                      ),
                    ):Container(),
                  ],
                ),
              ),

          )
      ),
    ));
  }
}
