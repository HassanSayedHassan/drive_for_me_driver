import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_for_me_user/constants/color.dart';
import 'package:drive_for_me_user/models/adress.dart';
import 'package:drive_for_me_user/models/request_model.dart';
import 'package:drive_for_me_user/screens/chat_driver_user.dart';
import 'package:drive_for_me_user/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/svg.dart';
import '../res.dart';
import 'package:url_launcher/url_launcher.dart';
class ArriveContainer extends StatefulWidget {
  final Address ? picKUpLocation,dropOffLocation;
  final String arriveDuration;
  final  RequestModel? requestModel;
  ArriveContainer(this.picKUpLocation,this.dropOffLocation,this.arriveDuration,this.requestModel);

  @override
  _ArriveContainerState createState() => _ArriveContainerState();
}

class _ArriveContainerState extends State<ArriveContainer> {

  double rightMargin=0;
  double leftMargin=0.0;
  double rightMargin2=0;
  double leftMargin2=0;

  int unreadMessages=0;

  @override
  Future<void> didChangeDependencies() async {
    FirebaseFirestore.instance.collection('requests')
        .doc(widget.requestModel!.id)
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
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(

        height: 280,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness != Brightness.dark
                ? Colors.white
                : Color(0xff787878),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Column(
          children: [
            SizedBox(height: 10.h,),
             Text("Arrive to pick location in ${widget.arriveDuration}",
                 style: TextStyle(
                 fontSize: 18.sp,
                 color: MyTheme(context).textColor,
                 fontWeight: FontWeight.bold),
                 ),
            SizedBox(height: 10.h,),
            Divider(
              color: MyTheme(context).textColor,
              thickness: 2,
            ),
            Row(
              children: [
                CircleAvatar(backgroundColor: MyTheme(context).iconColor,radius: 15.sp,
                  child: Icon(Icons.my_location,color:MyTheme(context).backgroundColor),
                ),
                SizedBox(width: 20.w,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.picKUpLocation!.placeName!,
                      style: TextStyle(
                          fontSize: 22.sp,
                          color: MyTheme(context).textColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.picKUpLocation!.placeFormattedAddress!.length>35?
                      widget.picKUpLocation!.placeFormattedAddress!.substring(0,35)+"....":
                      widget.picKUpLocation!.placeFormattedAddress!,
                      textAlign: TextAlign.left,
                      softWrap: true,
                      overflow:TextOverflow.visible,
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),

              ],
            ),
            SizedBox(height: 20.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30.sp,
                  backgroundColor: MyTheme(context).buttonTextColor,
                  child: Image.asset(Res.user_man,),
                ),
                SizedBox(width: 20.h,),
                Column(
                  children: [
                     Text(widget.requestModel!.currentUserModel!.name!,
                         style: TextStyle(
                         fontSize: 20.sp,
                         color: MyTheme(context).textColor,
                         fontWeight: FontWeight.bold),
                         ),
                    SizedBox(height: 5.h,),
                    Text(widget.requestModel!.currentUserModel!.phone!,
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
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
                          launch("tel:${widget.requestModel!.currentUserModel!.phone!}");
                        },
                        child: CircleAvatar(child: Icon(Icons.call,size: 30.sp,color: MyTheme(context).buttonTextColor,),
                          backgroundColor: MyTheme(context).buttonColor,),
                      ),

                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.w,),
            drowButton(text: 'Arrive',onTab: (){

              FireBaseApi(context).driverArriveFun(widget.requestModel!);
            }),

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
