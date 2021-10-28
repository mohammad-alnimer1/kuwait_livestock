import 'package:flutter/material.dart';
import 'package:kuwait_livestock/Module/AddressModel.dart';
import 'package:kuwait_livestock/nav_bar/More/EditAddress.dart';

import 'AppController.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    @required this.AddressList,
  });

  final List<AddressModel> AddressList;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.black12.withOpacity(0.04)),
              height: 50,
              child: Align(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    AddressList[0].AddressName,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                alignment: Alignment.centerRight,
              )),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 5, right: 8, left: 8, top: 5),
            child: Text(AddressList[0].state_id[1]),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, right: 8, left: 8),
            child: Text(AddressList[0].country_id[1]),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, right: 8, left: 8),
            child: Text(AddressList[0].building_address),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, right: 8, left: 8),
            child: Text(AddressList[0].street),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, right: 8, left: 8),
            child: Text(AddressList[0].note_address),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Text(
                    '${AppController.strings.EditYourAddress}',
                    style: TextStyle(fontSize: 18, color: Colors.orangeAccent),
                  ),
                  onTap: () {
                    var Addressid = AddressList[0].Addressid;
                    //  print('hi hi hi hih ih hi hi id ${data}');
                    var AddressName = AddressList[0].AddressName;
                    var country_id = AddressList[0].country_id;
                    var state_id = AddressList[0].state_id;
                    var building_address = AddressList[0].building_address;
                    var note_address = AddressList[0].note_address;
                    var latitude = AddressList[0].latitude;
                    var longitude = AddressList[0].longitude;
                    var street = AddressList[0].street;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditAdress(
                                  Addressid: Addressid,
                                  AddressName: AddressName,
                                  country_id: country_id,
                                  stateid: state_id,
                                  Building: building_address,
                                  notes: note_address,
                                  ParcelStreet: street,
                                  lat: latitude,
                                  longi: longitude,
                                )));
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
