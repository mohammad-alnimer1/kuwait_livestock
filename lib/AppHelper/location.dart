import 'package:geolocator/geolocator.dart';
class Location {
  var longitude=0.0;
  var latitude=0.0;
  Future<void> getcorrentlocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
      print(latitude);
      print(longitude);

    }
    catch (e) {
      print(e);
    }
  }
}
