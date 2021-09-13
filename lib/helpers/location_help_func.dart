

import 'package:drive_for_me_user/providers/locations_data_providers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LocationHelpFunc
{
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
   void moveCameraToCurrentPosition(_cameraMapController,context) async {
    Position  currentPosition = await determinePosition();



    LatLng latLngPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
    CameraPosition cameraPosition =
    CameraPosition(target: latLngPosition, zoom: 14);
    _cameraMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //  String address = await AssistantMethods.searchCordinateAdress(current_possition, context);
    //  print("Adress ${address}");

  }

}