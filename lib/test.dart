//
// import 'dart:convert';
// import 'package:http/http.dart ' as http;
// import 'package:kuwait_livestock/Module/CategoryModule.dart';
// import 'package:kuwait_livestock/Module/servCat.dart';
// final String url = 'http://kuwaitlivestock.com:5000/categ_ids';
// var client = http.Client();
// var data;
//
// Future<void> fetchData() async {
//   http.Response response = await http.get(Uri.encodeFull(url),);
//   if(response.statusCode == 200){ // Connection Ok
//     data=json.decode(json.encode(response.body));
//     List<categorymodule> _list = List<categorymodule>();
//     print('hi hi hi hi hi hbi hi hihi '+data);
//     // print('++++++++++++++++++++++++ '+data[0]['name']);
//   } else {
//     throw('error');
//   }
// }