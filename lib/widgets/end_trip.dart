import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:drive_for_me_user/screens/home_screen.dart';
import 'package:drive_for_me_user/widgets/drow_rating.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:drive_for_me_user/widgets/end_container.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

class EndTrip extends StatefulWidget {
  final RequestModel? requestModel;

  EndTrip(this.requestModel);

  @override
  _EndTripState createState() => _EndTripState();
}

class _EndTripState extends State<EndTrip> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyTheme(context).backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Thank you , ${widget.requestModel!.driverModel!.name!}",
                  style: TextStyle(
                      fontSize: 22.sp,
                      color: MyTheme(context).textColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            CircleAvatar(
              radius: 80.sp,
              backgroundColor: MyTheme(context).buttonColor,
              child: Image.asset(Res.user_man,fit: BoxFit.cover,),
            ),
            SizedBox(
              height: 30.h,
            ),
            DrowRating(2.5,40),
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Collect Cash , ${widget.requestModel!.cashPrice} LE\n And go to Home Screen",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22.sp,
                      color: MyTheme(context).textColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 100.h,
            ),
            drowButton(text: 'Home Screen',onTab: (){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) {
                return new HomeScreen();}), (route) => false);
            }),



            SizedBox(
              height: 40.h,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 200.w,
                        height: 50.h,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: MyTheme(context).textColor,width: 2)
                        ),
                        alignment: Alignment.center,
                        child:  Text("Total Trips 20 +1",
                          style: TextStyle(
                              fontSize: 20.sp,
                              color: MyTheme(context).textColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 200.w,
                        height: 50.h,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),

                            border: Border.all(color: MyTheme(context).textColor,width: 2)
                        ),
                        alignment: Alignment.center,
                        child:  Text("Total cash 520 LE +32",
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: MyTheme(context).textColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget drowButton({String? text, required Function? onTab()}) {
    return ElevatedButton(
      child: Container(
        width: 200.w,
        child: Text(
          text!,
          style: TextStyle(
              fontSize: 20.sp,
              color: MyTheme(context).buttonTextColor,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      onPressed:onTab ,
      style: ElevatedButton.styleFrom(
        primary: MyTheme(context).buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 11.h),
      ),
    );
  }
}
