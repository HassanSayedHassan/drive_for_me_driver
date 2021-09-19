import 'package:drive_for_me_user/helpers/api_handlar.dart';
import 'package:drive_for_me_user/models/request_model.dart';
import 'package:drive_for_me_user/providers/driver_provider.dart';
import 'package:drive_for_me_user/screens/show_trip_details.dart';
import 'package:drive_for_me_user/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../res.dart';
class ShowAllTripsList extends StatefulWidget {


  @override
  _ShowAllTripsListState createState() => _ShowAllTripsListState();
}

class _ShowAllTripsListState extends State<ShowAllTripsList> {

  @override
  Widget build(BuildContext context) {
    var driver = Provider.of<DriverProvider>(context).getCurrentDriver;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  MyTheme(context).buttonColor,
        title:  Text("All Trips",
            style: TextStyle(
            fontSize: 22.sp,
                color: MyTheme(context).buttonTextColor,
            fontWeight: FontWeight.bold),
            ),
        leading: SizedBox(),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: FireBaseApi(context).getAllDriverTrips(driver),
          builder: (context, AsyncSnapshot snapShot) {
            switch (snapShot.connectionState) {
              case ConnectionState.none:
                return connectionError();
                break;
              case ConnectionState.waiting:
                return loading(context);
                break;
              case ConnectionState.active:
                return loading(context);
                break;
              case ConnectionState.done:
                if (snapShot.hasError) {
                  return error(snapShot.error);
                } else {
                  if (snapShot.data == null) {
                    return Center(
                      child: Text(
                        "No Item Added",
                        style: TextStyle(
                          color: MyTheme(context).textColor,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    );
                  } else {
                    List<RequestModel> request = snapShot.data;

                    return ListView.builder(
                        itemCount: request.length,
                        itemBuilder: (context, index) {
                          return drowRequestCard(request[index]);
                        });
                  }
                }
                break;
            }
            return SizedBox();
          },
        ),
      )
    );
  }

  Widget drowRequestCard(RequestModel requestModel) {


    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ShowTripDetails(requestModel),));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Card(
          elevation: 1,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Image.asset(
                  Res.uber,
                  width: 60.w,
                  height: 80.h,
                  fit: BoxFit.cover,

                ),
                SizedBox(
                  width: 20.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      requestModel.pickUpLocation!.placeName!,
                      style: TextStyle(
                          fontSize: 22.sp,
                          color: MyTheme(context).textColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      requestModel.pickUpLocation!
                          .placeFormattedAddress!.length >
                          35
                          ? requestModel.pickUpLocation!
                          .placeFormattedAddress!
                          .substring(0, 35) +
                          "...."
                          : requestModel.pickUpLocation!
                          .placeFormattedAddress!,
                      textAlign: TextAlign.left,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Icon(Icons.timer,color: MyTheme(context).iconColor,size: 25.sp,),
                        SizedBox(width: 10.w,),
                        Text(
                          DateFormat('yyyy-MM-dd     kk:mm a').format(
                              DateTime.parse(
                                  requestModel.pickedDate!)),
                          textAlign: TextAlign.left,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: MyTheme(context).textColor,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ) ,
        ),
      ),
    );
  }
}
