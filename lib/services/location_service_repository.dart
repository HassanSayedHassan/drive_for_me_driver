import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:background_locator/location_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_for_me_user/constants/map_config.dart';
import 'package:drive_for_me_user/providers/driver_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocationServiceRepository {

  static LocationServiceRepository _instance = LocationServiceRepository._();

  LocationServiceRepository._();

  factory LocationServiceRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';

  int _count = -1;

  Future<void> init(Map<dynamic, dynamic> params) async {
    //TODO change logs
    print("***********Init callback handler");

    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> dispose() async {
    print("***********Dispose callback handler");
    print("$_count");

    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> callback(LocationDto locationDto) async {
    print('$_count location in dart: ${locationDto.toString()}');
    await Firebase.initializeApp();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentDriverUid= prefs.getString('driverId') ?? "";
    print("currentDriverUid $currentDriverUid");
   if(currentDriverUid!='')
      {
        FirebaseDatabase.instance.reference().child('driversLocation').child(currentDriverUid).set(
            {
              'latitude': locationDto.latitude,
              'longitude': locationDto.longitude,
              'data': DateTime.now().toIso8601String().toString(),

            });
     }

    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(locationDto);
    _count++;
  }

}
