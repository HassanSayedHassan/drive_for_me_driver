import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_for_me_user/constants/color.dart';
import 'package:drive_for_me_user/constants/map_config.dart';
import 'package:drive_for_me_user/helpers/help_fun.dart';
import 'package:drive_for_me_user/providers/driver_provider.dart';
import 'package:drive_for_me_user/providers/locations_data_providers.dart';
import 'package:drive_for_me_user/res.dart';
import 'package:drive_for_me_user/screens/current_request_screen.dart';
import 'package:drive_for_me_user/screens/search_screen.dart';
import 'package:drive_for_me_user/services/firebase_api.dart';
import 'package:drive_for_me_user/services/location_service_repository.dart';
import 'package:drive_for_me_user/services/location_services_func.dart';
import 'package:drive_for_me_user/services/location_sevices.dart';
import 'package:drive_for_me_user/services/notification_services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:drive_for_me_user/helpers/location_help_func.dart';
import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _cameraControllerCompleter = Completer();
  late GoogleMapController _cameraMapController;
  late String _mapStyle;

  Set<Marker> markerSet = {};

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(26.8700401, 27.9822166),
    zoom: 5.83,
  );

  bool status=false;

  ReceivePort port = ReceivePort();
  @override
  void initState() {
    super.initState();


    if (IsolateNameServer.lookupPortByName(LocationServiceRepository.isolateName) != null) {
      IsolateNameServer.removePortNameMapping(LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(port.sendPort, LocationServiceRepository.isolateName);

    port.listen((dynamic data) async {

    },
    );
    LocationServicesFunc().initPlatformState();
  }



  @override
  Future<void> didChangeDependencies() async {
    markerSet.clear();

    rootBundle.loadString(MyTheme(context).getMap).then((string) {
      _mapStyle = string;
    });

    Position currPosition = await LocationHelpFunc().determinePosition();

    LocationServices.searchCoordinateAddress(currPosition, context);

    Marker currPositionMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: "My Location", snippet: "My Location"),
        position: LatLng(currPosition.latitude, currPosition.longitude),
        markerId: MarkerId("PickUpId"));

    setState(() {
      markerSet.add(currPositionMarker);
    });

    PushNotificationServices pushNotificationServices = PushNotificationServices(context);
    pushNotificationServices.inialize();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var driver=Provider.of<DriverProvider>(context,listen: false).getCurrentDriver;

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyTheme(context).backgroundColor,
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              markers: markerSet,
              onMapCreated: (GoogleMapController controller) {
                _cameraControllerCompleter.complete(controller);
                _cameraMapController = controller;
                _cameraMapController.setMapStyle(_mapStyle);
                LocationHelpFunc()
                    .moveCameraToCurrentPosition(_cameraMapController, context);
              },
            ),
            drowTopContainer(),
            Positioned(
              left: 10.w,
              top: 30.h,
              child: InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.dehaze_rounded,
                    color: MyTheme(context).iconColor,
                    size: 35,
                  )),
            ),
            Positioned(
              right: 10.w,
              top: 30.h,
              child: InkWell(
                  onTap: () {
                     Navigator.push(context, MaterialPageRoute(
                             builder: (context) => CurrentRequestScreen(),));

                   /* LocationHelpFunc().moveCameraToCurrentPosition(
                        _cameraMapController, context);*/
                  },
                  child: Icon(
                    Icons.my_location,
                    color: MyTheme(context).iconColor,
                    size: 35,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget drowTopContainer() {
    var driver=Provider.of<DriverProvider>(context,listen: false).getCurrentDriver;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child:  StreamBuilder<QuerySnapshot>(

          stream: FirebaseFirestore.instance.collection('drivers').where("id",isEqualTo:driver.id).snapshots(),
          builder: (context, snapshot) {
           // print("New Data is ${snapshot.data!.docs[0]["status"]}");
            return InkWell(
              onTap: ()
              {

                if(snapshot.hasData && snapshot.data!.docs[0]["status"]==false)
                  {
                    LocationServicesFunc().onStart();
                  }
                else if(snapshot.hasData && snapshot.data!.docs[0]["status"]==true)
                  {
                    LocationServicesFunc().onStop();
                  }

                if(snapshot.hasData)
                  {
                    FireBaseApi(context).setCurrentDriveStatus(snapshot.data!.docs[0]["status"], driver.id!);
                  }

              },
              child: Container(
                height: 100,
                alignment: Alignment.center,
                color: snapshot.hasData?
                snapshot.data!.docs[0]["status"]==false?Colors.black54:Colors.green:Colors.black54,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child:  Text(
                  snapshot.hasData?
                  snapshot.data!.docs[0]["status"]==true?"Online Now":"Offline, Go Online Now ":"Offline, Go Online Now ",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
    );
  }




}

