


import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitAssistant
{
  static double? getMarkerRotation(sLat,sLng,dLat,dLang)
  {
   double rot= SphericalUtil.computeHeading(LatLng(sLat ,sLng),LatLng(dLat, dLang)).toDouble();
   return rot;

  }


}