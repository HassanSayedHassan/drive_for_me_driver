import 'dart:async';
import 'package:drive_for_me_user/widgets/end_container.dart';
import 'package:flutter_svg/svg.dart';
import 'package:drive_for_me_user/helpers/help_fun.dart';
import 'package:drive_for_me_user/helpers/map_kit_assistant.dart';
import 'package:drive_for_me_user/models/direct_details.dart';
import 'package:drive_for_me_user/models/request_model.dart';
import 'package:drive_for_me_user/services/location_sevices.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:drive_for_me_user/helpers/location_help_func.dart';
import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../res.dart';
import 'arrive_container.dart';
class GoingToDropoff extends StatefulWidget {
  final  RequestModel? requestModel;
  GoingToDropoff(this.requestModel);

  @override
  _GoingToDropoffState createState() => _GoingToDropoffState();
}

class _GoingToDropoffState extends State<GoingToDropoff> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _cameraMapController;

  /// ===========================================
  DirectionDetails? tripDirectionDetails;
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polyLineSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  late String _mapStyle;



  String durationRide ="";
  BitmapDescriptor? animatedMarkerIcon;

  void creatIconMarker()
  {
    if(animatedMarkerIcon==null)
    {
      ImageConfiguration imageConfiguration=createLocalImageConfiguration(context,size:Size(2,2) );
      BitmapDescriptor.fromAssetImage( imageConfiguration, Res.uber).then((value) {
        animatedMarkerIcon=value;
      });
    }
  }



  LatLng?  myPosition;



  @override
  void initState() {
    super.initState();

    getDriveLiveLocation();
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
    creatIconMarker();
    CameraPosition initialLocation = CameraPosition(
      zoom: 12,
        //bearing: CAMERA_BEARING,
       // tilt: CAMERA_TILT,
      target: LatLng(widget.requestModel!.pickUpLocation!.latitude!,widget.requestModel!.pickUpLocation!.longitude!),
    );
    return Scaffold(
      body: Stack(
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
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
              _cameraMapController = controller;
              _cameraMapController.setMapStyle(_mapStyle);

              LatLng dropOffLatLang =LatLng(widget.requestModel!.dropOffLocation!.latitude!,widget.requestModel!.dropOffLocation!.longitude!);

              await  getPlaceDirection(myPosition!,dropOffLatLang);
              getDriveLiveLocation();

            },
          ),

          EndContainer(widget.requestModel!.pickUpLocation!,widget.requestModel!.dropOffLocation!,durationRide,widget.requestModel)
        ],
      ),
    );
  }

  void getDriveLiveLocation()
  {

    LatLng oldPos=LatLng(0,0);
    FirebaseDatabase.instance.reference().child('driversLocation').child(widget.requestModel!.driverModel!.id!).onValue.listen((event) {
      Map data = event.snapshot.value;
      double myLatitude=data["latitude"];
      double myLongitude=data["longitude"];

      myPosition=LatLng(myLatitude,myLongitude);
      var rot =MapKitAssistant.getMarkerRotation(oldPos.latitude, oldPos.longitude, myPosition!.latitude, myPosition!.latitude);

      Marker animatedMarker=Marker(
        markerId: MarkerId('animating'),
        position: myPosition!,
        rotation: rot!,
        icon: animatedMarkerIcon!,
        infoWindow: InfoWindow(title: 'current Location'),

      );
      setState(() {
        CameraPosition cameraPosition=CameraPosition(target: myPosition!,zoom: 17,);
        _cameraMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        markerSet.removeWhere((marker) => marker.mapsId.value=='animating');
        markerSet.add(animatedMarker);
      });
      oldPos=myPosition!;
      updateRideDetails();


    });
  }

  Future<void> getPlaceDirection(LatLng picUpLatLang, LatLng dropOffLatLang) async {
    HelpFun.showLoading(context);

    var details = await LocationServices.obtainPlacesDirectionDetails(
        picUpLatLang, dropOffLatLang,context);

    Navigator.pop(context);
    print("EncodedPoints${details!.encodedPoints}");

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResults =
    polylinePoints.decodePolyline(details.encodedPoints!);

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

    _cameraMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latlangBounds, 70));
    Marker pickUpMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),


        position: picUpLatLang,
        markerId: MarkerId("PickUpId"));
    Marker dropOffMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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




  Future<void> updateRideDetails()  async {

    LatLng  destinationLatLng=LatLng( widget.requestModel!.pickUpLocation!.latitude!,widget.requestModel!.pickUpLocation!.longitude!);
    LatLng posLatLng=LatLng( widget.requestModel!.dropOffLocation!.latitude!,widget.requestModel!.dropOffLocation!.longitude!);


    var destinationDetails= await LocationServices.obtainPlacesDirectionDetails(posLatLng, destinationLatLng,context);
    if(destinationDetails!=null)
    {
      setState(() {
        durationRide= destinationDetails.durationText!;
      });
    }
  }

}




