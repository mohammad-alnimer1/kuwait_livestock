import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../More/OrderDetails.dart';

class ArchiveOrders extends StatefulWidget {
  @override
  _ArchiveOrdersState createState() => _ArchiveOrdersState();
}

class _ArchiveOrdersState extends State<ArchiveOrders> {
  var UserEmail;
  List previousOrderlist;
  Future getArchiveOrders() async {
    // show_loading(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    UserEmail = preferences.getString('login');
    var data = {
      "login": UserEmail.toString(),
    };
    var url = "http://kuwaitlivestock.com:5000/get_order";
    dynamic response = await http.post(url, body: data);
    //print(response.body);
    setState(() {
      String jsonsDataString = response.body;
      previousOrderlist = jsonDecode(jsonsDataString.replaceAll("'", '"').replaceAll("False", "\"False\""));
      print('hi hi hi hi hi hi hi ${previousOrderlist}');
    });

    // for (var previousOrder in previousOrderlist){ //prints the name of each family member
    //   var familyMemberName = previousOrderlist[0]['partner_id'];
    //   print(familyMemberName);
    // }
  }

  @override
  void initState() {
    getArchiveOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: AppController.textDirection,
        child:  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '${AppController.strings.previousOrders}',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: previousOrderlist == null
          ? Container()
          : ListView.builder(
              itemCount: previousOrderlist.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                      subtitle: Container(child:  Row(children: [Text('${AppController.strings.paymentType}:',),Text('${previousOrderlist[index]['type_payment']}'),],),width: 150,),
                  title:  Container(child:  Row(children: [Text('${AppController.strings.orderNumber}:'),Text('${previousOrderlist[index]['name']}'),],),width: 150,) ,
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    List  order_line = previousOrderlist[index]['order_line'];
                    var amount_total =previousOrderlist[index]['amount_total'];
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrderDetails(partner_id: order_line,amount_total:amount_total),
                      ),);
                  },
                ));
              },
            ),
    ));
  }
}
