import 'dart:convert';
import 'package:http/http.dart ' as http;

class NetworkHelper {
  NetworkHelper(this.url);
   final url;
   Future <dynamic> getdata()async{
    http.Response response = await http.get(url);
     if (response.statusCode == 200) {
     final extractdata= json.decode(response.body.replaceAll("'",'"').replaceAll("False", "\"False\"").replaceAll('<p>', "").replaceAll('</p>', ''));
     return extractdata;
     }else {
       print(response.statusCode);
     }


  }
}
