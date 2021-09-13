import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_for_me_user/helpers/help_fun.dart';
import 'package:drive_for_me_user/models/request_model.dart';
import 'package:drive_for_me_user/providers/driver_provider.dart';
import 'package:drive_for_me_user/widgets/end_trip.dart';
import 'package:drive_for_me_user/widgets/going_to_dropoff.dart';
import 'package:drive_for_me_user/widgets/going_to_pickup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:drive_for_me_user/helpers/location_help_func.dart';
import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CurrentRequestScreen extends StatefulWidget {


  @override
  _CurrentRequestScreenState createState() => _CurrentRequestScreenState();
}

class _CurrentRequestScreenState extends State<CurrentRequestScreen> {

  String? requestId;
  RequestModel? requestModel;
  bool isLoading=true;

  @override
  Future<void> didChangeDependencies() async {
   var driver= Provider.of<DriverProvider>(context,listen: false).getCurrentDriver;
    await  FirebaseFirestore.instance.collection('drivers').doc(driver.id).get().then((value) {

      requestId=value["hasOrderId"];
    });

    await FirebaseFirestore.instance.collection('requests').doc(requestId).get().then((value) {
      //  HelpFun.showToast(context, value["hasOrderId"]);
      requestModel=RequestModel.fromJson(value.data()!);
      //  HelpFun.showToast(context, requestModel!.currentUserModel!.id!);
        setState(() {
          isLoading=false;
        });
    });


    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return isLoading? Center(
      child: SpinKitFoldingCube(
        color: MyTheme(context).textColor,
        size: 50.sp,
      ),
    ):StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('requests').where("id",isEqualTo:requestId).snapshots(),
         builder: (context, snapshot) {
          return Scaffold(
            body: snapshot.hasData?drowBody(snapshot.data!.docs[0]["status"]):Center(
              child: SpinKitFoldingCube(
                color: MyTheme(context).textColor,
                size: 50.sp,
              ),
            ) ,
          );
    });
  }

Widget ? drowBody(String status)
{
  if(status=="send")
    {
      return GoingToPickup(requestModel);
    }
  else if(status=="onWay")
    {
      return GoingToDropoff(requestModel);
    }
  else if(status=="end")
  {
    return EndTrip(requestModel);
  }
  else
  {
    return Center(
      child:  Text("You don't Have any Order Now",
        style: TextStyle(
            fontSize: 22,
            color: Colors.red,
            fontWeight: FontWeight.bold),
      ),
    );
  }

}

}
