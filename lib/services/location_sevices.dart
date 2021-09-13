

import 'dart:convert';

import 'package:drive_for_me_user/constants/map_config.dart';
import 'package:drive_for_me_user/helpers/help_fun.dart';
import 'package:drive_for_me_user/models/adress.dart';
import 'package:drive_for_me_user/models/direct_details.dart';
import 'package:drive_for_me_user/models/place.dart';
import 'package:drive_for_me_user/providers/locations_data_providers.dart';
import 'package:drive_for_me_user/screens/confirm_trip_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
class LocationServices
{

  static Future<dynamic> getRequest(String url)async{
    http.Response response=await http.get(Uri.parse(url));

    try{
      if(response.statusCode==200)
      {
        String jSonData=response.body;
        var decodeData=jsonDecode(jSonData);
        return decodeData;
      }
      else{
        return "failed";
      }
    }
    catch(exp)
    {
      return "failed";
    }
  }
  static Future<String> searchCoordinateAddress(Position position,context) async
  {
    String placeAddress="";
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey"));
    request.headers.addAll(headers);


    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("SuccessPlace");
        var jsonData = await response.stream.bytesToString();
        print("jsonData $jsonData");
        var data = jsonDecode(jsonData);

        placeAddress=data["results"][0]["address_components"][1]["long_name"]; /// ToDo change this
        String ?formattedAddress=data["results"][0]["formatted_address"];
        print("currrr position ${formattedAddress}");
        Address userPickerUpAddress=Address();
        userPickerUpAddress.longitude=position.longitude;
        userPickerUpAddress.latitude=position.latitude;
        userPickerUpAddress.placeName=placeAddress;
         userPickerUpAddress.placeFormattedAddress=formattedAddress;

        Provider.of<LocationsDataProviders>(context,listen: false).updatePickUpLocationAddress(userPickerUpAddress);

        return placeAddress;

      } else {
        var jsonData = await response.stream.bytesToString();
        var Data = jsonDecode(jsonData);
        print("jsonData ${Data["message"]}");
        HelpFun.showErrorToast(context, "Error On searchCoordinateAddress");
        print("Error");
        return "";
      }
    } catch (error) {
      HelpFun.showErrorToast(context, "catch Error On searchCoordinateAddress");
      print("Errorrr $error ");
      return "" ;
    }

  }





  Future<List<PlacePredictions>?> findPlaceCompleter(String placeName,context)async
  {
    if(placeName.length>1)
    {
      List<PlacePredictions>? placePredictionsList=[];
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:eg'));
      request.headers.addAll(headers);
      try {
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          print("SuccessPlace");
          var jsonData = await response.stream.bytesToString();
          print("jsonData $jsonData");
          var data = jsonDecode(jsonData)["predictions"];

          for (var item in data) {
            placePredictionsList.add(PlacePredictions.fomJason(item));
          }
          print("placePredictionsList ${placePredictionsList.length}");
          return placePredictionsList;

        } else {
          var jsonData = await response.stream.bytesToString();
          var Data = jsonDecode(jsonData);
          print("jsonData ${Data["message"]}");
          HelpFun.showErrorToast(context, "Error on findPlaceCompleter");
          print("Error");
          return [];
        }
      } catch (error) {
        HelpFun.showErrorToast(context, "Error on findPlaceCompleter");
        print("Errorrr $error ");
        return [];
      }

    }

  }

  void getPlaceAddressDetails(String placeId,context)async
  {

    HelpFun.showLoading(context);
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey"));
    request.headers.addAll(headers);


    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("SuccessPlaceDetails");
        var jsonData = await response.stream.bytesToString();
        print("jsonData $jsonData");
        var res=jsonDecode(jsonData);


        Address address=Address();
        address.placeName=res["result"]["name"];
        address.placeFormattedAddress=res["result"]["formatted_address"];
        address.placeId=placeId;
        address.latitude=res["result"]["geometry"]["location"]["lat"];
        address.longitude=res["result"]["geometry"]["location"]["lng"];

        Provider.of<LocationsDataProviders>(context,listen: false).updateDropOffLocationAddress(address);
        print("Your going ${address.placeFormattedAddress}");

        HelpFun.closeLoading(context);

        print("check  null ${Provider.of<LocationsDataProviders>(context,listen: false).picKUpLocation}");
        print("check2  null ${address.longitude}");
         Navigator.push(context, MaterialPageRoute(
                 builder: (context) => ConfirmTripScreen( Provider.of<LocationsDataProviders>(context,listen: false).picKUpLocation,
                     address),));

      } else {
        var jsonData = await response.stream.bytesToString();
        var Data = jsonDecode(jsonData);
        print("jsonData ${Data["message"]}");
        HelpFun.closeLoading(context);
        HelpFun.showErrorToast(context, "Error on getPlaceAddressDetails");

        print("Error");
        return ;
      }
    } catch (error) {
      HelpFun.closeLoading(context);
      HelpFun.showErrorToast(context, "catch Error on getPlaceAddressDetails");

      print("Errorrr $error ");
      return ;
    }

  }


  static Future<DirectionDetails?> obtainPlacesDirectionDetails(LatLng initialPosition,LatLng finalPosition,context)
  async {


    String directionUrl="https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";
    // String directionUrl="https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood&key=AIzaSyCxN7pUL-K693odxu--QwvqL4vECsDfaeE";

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse(directionUrl));
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("Success obtainPlacesDirectionDetails");
        var jsonData = await response.stream.bytesToString();
        print("jsonData $jsonData");
        var res=jsonDecode(jsonData);

        DirectionDetails directionDetails=DirectionDetails();
        print("encodedddd ${res["routes"][0]["overview_polyline"]["points"]}");

        directionDetails.encodedPoints= res["routes"][0]["overview_polyline"]["points"];

        directionDetails.distanceText= res["routes"][0]["legs"][0]["distance"]["text"];
        directionDetails.distanceValue= res["routes"][0]["legs"][0]["distance"]["value"];

        directionDetails.durationText= res["routes"][0]["legs"][0]["duration"]["text"];
        directionDetails.durationValue= res["routes"][0]["legs"][0]["duration"]["value"];

        return directionDetails;

      } else {
        var jsonData = await response.stream.bytesToString();
        var Data = jsonDecode(jsonData);
        print("jsonData ${Data["message"]}");

        HelpFun.showErrorToast(context, "Error on obtainPlacesDirectionDetails");

        print("Error");
       throw 'error on connection to server';
      }
    } catch (error) {
      HelpFun.showErrorToast(context, "catch Error on obtainPlacesDirectionDetails ${error.toString()}");

      print("catch Error on obtainPlacesDirectionDetails ${error.toString()}");
    }

  }

}