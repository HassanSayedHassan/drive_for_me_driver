
import 'package:drive_for_me_user/models/adress.dart';
import 'package:flutter/cupertino.dart';

class LocationsDataProviders with ChangeNotifier
{
  Address ? picKUpLocation,dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpLocation)
  {
    picKUpLocation=pickUpLocation;
    notifyListeners();
  }
  void updateDropOffLocationAddress(Address dropOffLocation)
  {
    dropOffLocation=dropOffLocation;
    notifyListeners();
  }

}