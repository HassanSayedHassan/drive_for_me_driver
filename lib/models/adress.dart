import 'dart:core';

import 'package:flutter/material.dart';
class Address
{
  String? placeFormattedAddress;
  String ?placeName;
  String ?placeId;
  double ?latitude;
  double ?longitude;

  Address({this.placeFormattedAddress, this.placeName, this.placeId,
    this.latitude, this.longitude});

  Address.fromJson(Map<String, dynamic> json) {

    placeFormattedAddress = json['placeFormattedAddress'];
    placeName = json['placeName'];
    placeId = json['placeId'];
    latitude = json['latitude'];
    longitude = json['longitude'];

  }

  Map<String, dynamic> toJson() => {
    'placeFormattedAddress': placeFormattedAddress,
    'placeName': placeName,
    'placeId': placeId,
    'latitude': latitude,
    'longitude': longitude,
  };

}