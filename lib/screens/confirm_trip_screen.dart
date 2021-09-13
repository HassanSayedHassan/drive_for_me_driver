import 'dart:async';

import 'package:drive_for_me_user/constants/map_config.dart';
import 'package:drive_for_me_user/helpers/help_fun.dart';
import 'package:drive_for_me_user/models/adress.dart';
import 'package:drive_for_me_user/models/direct_details.dart';
import 'package:drive_for_me_user/providers/locations_data_providers.dart';
import 'package:drive_for_me_user/services/location_sevices.dart';
import 'package:drive_for_me_user/widgets/arrive_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drive_for_me_user/helpers/location_help_func.dart';
import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../res.dart';
class ConfirmTripScreen extends StatefulWidget {

 final Address ? picKUpLocation,dropOffLocation;
 ConfirmTripScreen(this.picKUpLocation,this.dropOffLocation);
  @override
  _ConfirmTripScreenState createState() => _ConfirmTripScreenState();
}

class _ConfirmTripScreenState extends State<ConfirmTripScreen> {

  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _cameraMapController;

  /// ===========================================
  late DirectionDetails tripDirectionDetails;
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polyLineSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  late String _mapStyle;

  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    rootBundle.loadString(MyTheme(context).getMap).then((string) {
      _mapStyle = string;
    });
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
        zoom: 12,
      //  bearing: CAMERA_BEARING,
      //  tilt: CAMERA_TILT,
        target: LatLng(widget.picKUpLocation!.latitude!,widget.picKUpLocation!.longitude!),
    );
    return Stack(
      children: [
        GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            markers: markerSet,
            polylines: polyLineSet,
            mapType: MapType.normal,
           circles: circleSet,
            initialCameraPosition: initialLocation,
             onMapCreated: (GoogleMapController controller) {
               _controller.complete(controller);
               _cameraMapController = controller;
               _cameraMapController.setMapStyle(_mapStyle);

               getPlaceDirection();
    },
        ),
     //   ConfirmContainer(widget.picKUpLocation,widget.dropOffLocation)
      ],
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPosition =widget.picKUpLocation;
    var finalPosition = widget.dropOffLocation;

    var picUpLatLang = LatLng(initialPosition!.latitude!, initialPosition.longitude!);
    var dropOffLatLang = LatLng(finalPosition!.latitude!, finalPosition.longitude!);

    HelpFun.showLoading(context);

    var details = await LocationServices.obtainPlacesDirectionDetails(picUpLatLang, dropOffLatLang,context);

    setState(() {
      tripDirectionDetails=details!;
    });

    Navigator.pop(context);
    print("EncodedPoints${details?.encodedPoints}");

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResults =
    polylinePoints.decodePolyline(details!.encodedPoints!);

    if (decodedPolyLinePointsResults.isNotEmpty) {
      decodedPolyLinePointsResults.forEach((PointLatLng pointLatLang) {
        pLineCoordinates.add(LatLng(pointLatLang.latitude, pointLatLang.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
          color: Colors.pink,
          polylineId: PolylineId("polylineID"),
          jointType: JointType.round,
          points: pLineCoordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      polyLineSet.add(polyline);
    });

    LatLngBounds latlangBounds;
    if (picUpLatLang.latitude > dropOffLatLang.latitude &&
        picUpLatLang.longitude > dropOffLatLang.longitude) {
      latlangBounds =
          LatLngBounds(southwest: dropOffLatLang, northeast: picUpLatLang);
    } else if (picUpLatLang.longitude > dropOffLatLang.longitude) {
      latlangBounds = LatLngBounds(
          southwest: LatLng(picUpLatLang.latitude, dropOffLatLang.longitude),
          northeast: LatLng(dropOffLatLang.latitude, picUpLatLang.longitude));
    } else if (picUpLatLang.latitude > dropOffLatLang.latitude) {
      latlangBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLang.latitude, picUpLatLang.longitude),
          northeast: LatLng(picUpLatLang.latitude, dropOffLatLang.longitude));
    } else {
      latlangBounds =
          LatLngBounds(southwest: picUpLatLang, northeast: dropOffLatLang);
    }

    _cameraMapController.animateCamera(CameraUpdate.newLatLngBounds(latlangBounds, 70));
    Marker pickUpMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow:
        InfoWindow(title: initialPosition.placeName, snippet: "My Location"),
        position: picUpLatLang,
        markerId: MarkerId("PickUpId"));
    Marker dropOffMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow:
        InfoWindow(title: finalPosition.placeName, snippet: "DropOff"),
        position: dropOffLatLang,
        markerId: MarkerId("dropOffId"));

    setState(() {
      markerSet.add(pickUpMarker);
      markerSet.add(dropOffMarker);
    });

    Circle pickUpLocCircle = Circle(
        fillColor: Colors.blueAccent,
        center: picUpLatLang,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.yellowAccent,
        circleId: CircleId("PickUpId"));
    Circle dropOffLocCircle = Circle(
        fillColor: Colors.red,
        center: dropOffLatLang,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.deepPurple,
        circleId: CircleId("dropOffId"));

    setState(() {
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffLocCircle);
    });
  }
}
