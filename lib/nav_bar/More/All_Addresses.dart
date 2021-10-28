import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/AppHelper/location.dart';
import 'package:kuwait_livestock/AppHelper/networking.dart';
import 'package:kuwait_livestock/Module/AddressModel.dart';
import 'package:kuwait_livestock/api/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kuwait_livestock/AppHelper/CardAddress.dart';
import 'Add_Address.dart';
import 'EditAddress.dart';

class AllAddresses extends StatefulWidget {
  final addSuccess;
  AllAddresses({this.addSuccess});
  @override
  _AllAddressesState createState() => _AllAddressesState();
}

class _AllAddressesState extends State<AllAddresses> {
  var latitude;
  var longitude;

  Future<dynamic> getlocation() async {
    Location location = Location();
    await location.getcorrentlocation();
    latitude = location.latitude;
    longitude = location.longitude;
  }

  String userIdSP;

  @override
  void initState() {
    super.initState();
    getAllAddresses(userIdSP);
    getlocation();
  }

  List<AddressModel> AddressList = List<AddressModel>();

  Future<dynamic> getAllAddresses(String id) async {
    SharedPreferences pre = await SharedPreferences.getInstance();

    userIdSP = pre.getString('user_id');
    final NetworkHelper networkHelper =
    NetworkHelper(Api().baseURL + 'GetAddress?user_id=${userIdSP}');
    final Productdata = await networkHelper.getdata();

    Productdata.forEach((data) {
      var model = AddressModel();
      model.Addressid = data['id'];
      print('hi hi hi hih ih hi hi id ${data}');
      model.AddressName = data['name_address'];
      model.country_id = data['country_id'];
      model.state_id = data['state_id'];
      model.building_address = data['building_address'];
      model.note_address = data['note_address'];
      model.latitude = data['latitude'];
      model.longitude = data['longitude'];
      model.street = data['street'];

      setState(() {
        print(Productdata);
        AddressList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: AppController.textDirection,
        child: Scaffold(
          appBar: AppBar(
            actions: [
            InkWell(
                onTap: () {
                  var long = longitude;
                  var lat = latitude;
                  print('lat$lat');
                  print('long$long');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddAdress(
                                lat: lat,
                                longi: long,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    '${AppController.strings.add}',
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 18,
                    ),
                  )),
                ),
              ),
            ],
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black87),
            centerTitle: true,
            title: Text(
              '${AppController.strings.Addresses}',
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
          ),
          body: ListView.builder(
            itemCount: AddressList.length,
            itemBuilder: (context, index) {
              return AddressCard(AddressList: AddressList);
            },
          ),
        ));
  }
}

