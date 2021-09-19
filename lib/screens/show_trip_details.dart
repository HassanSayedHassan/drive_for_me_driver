import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_for_me_user/helpers/api_handlar.dart';
import 'package:drive_for_me_user/models/request_model.dart';
import 'package:drive_for_me_user/services/firebase_api.dart';
import 'package:drive_for_me_user/widgets/drow_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../res.dart';
import 'chat_driver_user.dart';

class ShowTripDetails extends StatefulWidget {
 final RequestModel requestModel;
 ShowTripDetails(this.requestModel);
  @override
  _ShowTripDetailsState createState() => _ShowTripDetailsState();
}

class _ShowTripDetailsState extends State<ShowTripDetails> {

  int unreadMessages=0;

  @override
  Future<void> didChangeDependencies() async {
    FirebaseFirestore.instance.collection('requests')
        .doc(widget.requestModel.id)
        .collection("messages").doc("metaData").snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          unreadMessages = documentSnapshot.get('unreadDriver');
        });
      }
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("totaaaal ${widget.requestModel.driverModel!.ordersNumber}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  MyTheme(context).buttonColor,
        title:  Text("Trip Details",
          style: TextStyle(
              fontSize: 22.sp,
              color: MyTheme(context).buttonTextColor,
              fontWeight: FontWeight.bold),
        ),
        leading: SizedBox(),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 80.w,
                    height: 65.h,
                    decoration: BoxDecoration(
                      //color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        widget.requestModel.currentUserModel!.imageUrl ?? "",
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                          // You can use LinearProgressIndicator or CircularProgressIndicator instead
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(Res.uber),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.h,),
                  Column(
                    children: [
                      Text(widget.requestModel.currentUserModel!.name!,
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: MyTheme(context).textColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.h,),
                      Text(widget.requestModel.currentUserModel!.phone!,
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.h,),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ChatDriverUser(widget.requestModel),));
                          },
                          child: Stack(
                            children: [
                              CircleAvatar(
                                child: Icon(Icons.message_outlined,size: 30.sp,color: MyTheme(context).buttonTextColor,),
                                backgroundColor: MyTheme(context).buttonColor,),

                              unreadMessages!=0?  Positioned(
                                top: 0,
                                right: 0,
                                child:CircleAvatar(
                                  radius: 10.sp,
                                  backgroundColor: Colors.red,
                                  child:  Text(unreadMessages.toString(),
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ) ,
                              ):SizedBox()
                            ],
                          ),
                        ),
                        SizedBox(width: 25,),
                        InkWell(
                          onTap: ()
                          {
                            launch("tel:${widget.requestModel.currentUserModel!.phone!}");
                          },
                          child: CircleAvatar(child: Icon(Icons.call,size: 30.sp,color: MyTheme(context).buttonTextColor,),
                            backgroundColor: MyTheme(context).buttonColor,),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60.h,),

              Text(
                "Trip Details",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 22.sp,
                    color: MyTheme(context).textColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: MyTheme(context).iconColor,
                    radius: 15.sp,
                    child: Icon(Icons.my_location,
                        color: MyTheme(context).backgroundColor),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.requestModel.pickUpLocation!.placeName!,
                        style: TextStyle(
                            fontSize: 22.sp,
                            color: MyTheme(context).textColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.requestModel.pickUpLocation!
                            .placeFormattedAddress!.length >
                            35
                            ? widget.requestModel.pickUpLocation!
                            .placeFormattedAddress!
                            .substring(0, 35) +
                            "...."
                            : widget.requestModel.pickUpLocation!
                            .placeFormattedAddress!,
                        textAlign: TextAlign.left,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd     kk:mm a').format(
                            DateTime.parse(
                                widget.requestModel.pickedDate!)),
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
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 18.sp,
                    backgroundColor: Colors.transparent,
                    child: SvgPicture.asset(
                      Res.location,
                      width: 30.w,
                      height: 30.h,
                      color: MyTheme(context).iconColor,
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.requestModel.dropOffLocation!.placeName!,
                        style: TextStyle(
                            fontSize: 22.sp,
                            color: MyTheme(context).textColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.requestModel.dropOffLocation!
                            .placeFormattedAddress!.length >
                            35
                            ? widget.requestModel.dropOffLocation!
                            .placeFormattedAddress!
                            .substring(0, 35) +
                            "...."
                            : widget.requestModel.dropOffLocation!
                            .placeFormattedAddress!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd     kk:mm a').format(
                            DateTime.parse(
                                widget.requestModel.dropOffData!)),
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

              SizedBox(height: 60.h,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: MyTheme(context).buttonColor,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                height: 120,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      " Rate our Driver",
                      style: TextStyle(
                          fontSize: 22.sp,
                          color: MyTheme(context).buttonTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.h,),
                    DrowRating(widget.requestModel.rateDriver,45.sp),
                  ],
                ),
              ),
              SizedBox(height: 5.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
/*                  RotationTransition(
                    turns: new AlwaysStoppedAnimation(270 / 360),
                    child: Image.asset(
                      Res.uber,
                      width: 200.w,
                      height: 100.h,
                      fit: BoxFit.cover,

                    ),
                  ),*/
                ],
              ),



            ],
          ),
        ),
      ),
    );
  }
}
