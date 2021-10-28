import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kuwait_livestock/AppHelper/AppSharedPrefs.dart';
import 'package:kuwait_livestock/AppHelper/Constants.dart';
import 'package:kuwait_livestock/AppHelper/location.dart';
import 'package:kuwait_livestock/AppHelper/networking.dart';
import 'package:kuwait_livestock/Module/countryModel.dart';
import 'package:kuwait_livestock/Module/stateModel.dart';
import 'package:kuwait_livestock/api/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'All_Addresses.dart';

class EditAdress extends StatefulWidget {
  final longi;
  final lat;
  final AddressName;
  final ParcelStreet;
  final Building;
  final notes;
  final stateid;
  final Addressid;
  final country_id;
  EditAdress(
      {this.longi,
      this.lat,
      this.AddressName,
      this.Building,
      this.notes,
      this.ParcelStreet,
      this.stateid,
      this.Addressid,
      this.country_id});
  @override
  _EditAdressState createState() => _EditAdressState();
}

class _EditAdressState extends State<EditAdress> {
  String state;
  int intContryid;
  TextEditingController AddressNameController = new TextEditingController();
  TextEditingController ParcelStreetController = new TextEditingController();
  TextEditingController AreaController = new TextEditingController();
  TextEditingController BuildingController = new TextEditingController();
  TextEditingController notesController = new TextEditingController();
  GlobalKey<FormState> GlobalFormKey = new GlobalKey<FormState>();
  PanelController _pc2 = new PanelController();

  var LongeitudeTapped;
  var latitudeTapped;

  var latitude;
  var longitude;

  bool loading = true;

  List<Marker> myMarker = [];
  _handleTap(LatLng TappedPint) {
    print(TappedPint);
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(TappedPint.toString()),
        position: TappedPint,
      ));

      print('TappedPint.longitude');
      LongeitudeTapped = TappedPint.longitude;
      latitudeTapped = TappedPint.latitude;
      print(LongeitudeTapped);
      print(latitudeTapped);
    });
  }

  String country;
  List<countryModel> countryList = List<countryModel>();

  Future<dynamic> getcountry() async {
    final NetworkHelper networkHelper =
        NetworkHelper(Api().baseURL + 'country');
    final Productdata = await networkHelper.getdata();
    print('hi hi hi hih ih hi hi id ${Productdata}');
    Productdata.forEach((data) {
      var model = countryModel();
      model.id = data['id'];
      model.name = data['name'];
      setState(() {
        print(Productdata);
        countryList.add(model);
      });
    });
  }

  List<stateModel> stateList = List<stateModel>();
  Future<dynamic> getstate(int id) async {
    final NetworkHelper networkHelper =
        NetworkHelper(Api().baseURL + 'state?country_id=${id}');
    final Productdata = await networkHelper.getdata();
    setState(() {
      Productdata.forEach((data) {
        var model = stateModel();
        model.id = data['id'];
        print('hi hi hi hih ih hi hi id ${model.id}');
        model.name = data['name'];

        print(Productdata);
        stateList.add(model);
      });
    });
  }

  var UserEmail;
  var UserPhone;
  var _data;
  Future SendAddressform() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    UserEmail = preferences.getString('login');
    UserPhone = preferences.getString('phone');
    print(UserEmail);
    print(UserPhone);
    var logindata = GlobalFormKey.currentState;
    if (logindata.validate()) {
      logindata.save();
      // show_loading(context);

      var data = {
        //'id':widget.Addressid.toString(),
        'login': UserEmail.toString(),
        'phone': UserPhone.toString(),
        "name_address": AddressNameController.text,
        "street": ParcelStreetController.text,
        'country_id': intContryid.toString(),
        'state_id': state.toString(),
        "building_address": BuildingController.text,
        "note_address": notesController.text,
        'longitude': LongeitudeTapped.toString(),
        'latitude': latitudeTapped.toString(),
      };
      print(widget.Addressid);
      print(AddressNameController.text);
      print(intContryid);
      print(state);
      print(BuildingController.text);
      print(notesController.text);
      print('LongeitudeTapped');
      print(LongeitudeTapped);
      print('latitudeTapped');
      print(latitudeTapped);
      var url = "http://kuwaitlivestock.com:5000/SaveAddress";
      dynamic response = await http.post(url, body: data);
      print(response.body);

      String jsonsDataString = response.body;
      _data = jsonDecode(jsonsDataString.replaceAll("'", '"'));
      print('hi hi hi hi hihi hi ${_data}');
      if (_data['result'] == "success") {
        // savepreflogin(
        //     _data['name'], _data['login'], _data['user_id'], _data['phone']);
        // AppSharedPrefs.saveIsLoginSP(true);
        // print(await AppSharedPrefs.saveIsLoginSP(true));

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AllAddresses()));
      } else {
        //  Showtoast();
        // show_dialogall(context,"filed","wrong email or password plese check");

      }
    } else {}
  }

  @override
  void initState() {
    _handleTap;
    getcountry();

    latitudeTapped = double.parse(widget.lat);
    LongeitudeTapped = double.parse(widget.longi);
    print(latitude);
    print(longitude);
    super.initState();
    AddressNameController.text = widget.AddressName;
    ParcelStreetController.text = widget.ParcelStreet;
    BuildingController.text = widget.Building;
    notesController.text = widget.notes;
    country = widget.country_id[0].toString();
    print('country $country');
    print(widget.country_id);
    state = widget.stateid[0].toString();
    print('state $state');
    print(widget.stateid);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: AppController.textDirection,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Text(
                '${AppController.strings.addAddress}',
                style: TextStyle(color: Colors.black),
              )),
          body: Stack(
            children: [
              Form(
                key: GlobalFormKey,
                child: ListView(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _pc2.open();
                          });
                        },
                        child: Text('${AppController.strings.MarklocationMap}')),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppController.strings.addressName}:',
                              style: TextStyle(fontSize: 18),
                            ),
                            TextFormField(
                                validator: (value) => value.isEmpty
                                    ? '${AppController.strings.fillDataError}'
                                    : null,
                                controller: AddressNameController,
                                keyboardType: TextInputType.text,
                                autocorrect: true,
                                decoration: KDecoration.copyWith(
                                    hintText:
                                        '${AppController.strings.addressName}'))
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppController.strings.ParcelStreet}',
                              style: TextStyle(fontSize: 18),
                            ),
                            TextFormField(
                                maxLines: 4,
                                validator: (value) => value.isEmpty
                                    ? '${AppController.strings.fillDataError}'
                                    : null,
                                controller: ParcelStreetController,
                                keyboardType: TextInputType.text,
                                autocorrect: true,
                                decoration: KDecoration.copyWith(
                                    hintText:
                                        '${AppController.strings.ParcelStreet}'))
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppController.strings.countryName}',
                            style: TextStyle(fontSize: 18),
                          ),
                          DropdownButtonFormField<dynamic>(
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              labelText: "${AppController.strings.countryName}",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlueAccent, width: 5),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            value: country,
                            items: countryList
                                .map((list) => DropdownMenuItem(
                                    child: Text(list.name),
                                    value: list.id.toString()))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                country = value;
                                intContryid = int.parse(country);
                                getstate(intContryid);

                                //  print(intContryid);
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return AppController.strings.fillDataError;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppController.strings.city}',
                            style: TextStyle(fontSize: 18),
                          ),
                          DropdownButtonFormField<dynamic>(
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              labelText: "${AppController.strings.city}",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlueAccent, width: 5),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            value: state,
                            items: stateList
                                .map((statelist) => DropdownMenuItem(
                                    child: Text(statelist.name),
                                    value: statelist.id.toString()))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                state = value;
                                print('state');
                                print(state);
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return AppController.strings.fillDataError;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppController.strings.Area}:',
                              style: TextStyle(fontSize: 18),
                            ),
                            TextFormField(
                                validator: (value) => value.isEmpty
                                    ? '${AppController.strings.fillDataError}'
                                    : null,
                                controller: AreaController,
                                keyboardType: TextInputType.text,
                                autocorrect: true,
                                decoration: KDecoration.copyWith(
                                    hintText: '${AppController.strings.Area}'))
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppController.strings.Building}:',
                              style: TextStyle(fontSize: 18),
                            ),
                            TextFormField(
                                validator: (value) => value.isEmpty
                                    ? '${AppController.strings.fillDataError}'
                                    : null,
                                controller: BuildingController,
                                keyboardType: TextInputType.text,
                                autocorrect: true,
                                decoration: KDecoration.copyWith(
                                    hintText:
                                        '${AppController.strings.Building}'))
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppController.strings.notes}:',
                              style: TextStyle(fontSize: 18),
                            ),
                            TextFormField(
                                maxLines: 4,
                                validator: (value) => value.isEmpty
                                    ? '${AppController.strings.fillDataError}'
                                    : null,
                                controller: notesController,
                                keyboardType: TextInputType.text,
                                autocorrect: true,
                                decoration: KDecoration.copyWith(
                                    hintText: '${AppController.strings.notes}'))
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.red)),
                        color: Color(0xfff50000),
                        child: Text(
                          '${AppController.strings.save}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        elevation: 0.2,
                        onPressed: () {
                          setState(() {
                            SendAddressform();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SlidingUpPanel(
                minHeight: 1,
                  controller: _pc2,
                  isDraggable: false,
                  renderPanelSheet: true,
                  header: Container(child: IconButton(icon: Icon(Icons.arrow_circle_down), onPressed: (){
                    _pc2.close();
                  }),),
                  panel: Center(
                      child: Container(
                          color: Colors.blueAccent,
                          height: 400,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target:
                                    LatLng(latitudeTapped, LongeitudeTapped),
                                zoom: 5),
                            onTap: _handleTap,
                            markers: Set.from(myMarker),
                          )))
              )

            ],
          ),
        ));
  }
// Future Showtoast(){
//   Fluttertoast.showToast(
//
//      // msg: "${AppController.strings.pleaseComplete}",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Color(0xFFFFADAD),
//       textColor: Colors.white,
//       fontSize: 16.0);
// }
}
