import 'dart:convert';

import 'package:drive_for_me_user/constants/color.dart';
import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:drive_for_me_user/models/driver_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HelpFun {
  static void showLoadingOrgin(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            color: Colors.transparent,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(
                  strokeWidth: 5.sp,
                  backgroundColor: MyTheme(context).textColor,
                ),
                new Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }
  static void showAlertMessage(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                 Text(
                   "Please Click On Top Right Icon ",
                     style: TextStyle(
                     fontSize: 22.sp,
                     color: MyTheme(context).textColor,
                     fontWeight: FontWeight.bold),
                     ),
                SizedBox(height: 15.h,),
                Icon(Icons.my_location,size: 30.sp,color: MyTheme(context).iconColor,),
                SizedBox(height: 15.h,),
                Text(
                  "To get Your Current location",
                  style: TextStyle(
                      fontSize: 22.sp,
                      color: MyTheme(context).textColor,
                      fontWeight: FontWeight.bold),
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  static void showLoading(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SpinKitFoldingCube(
          color: MyTheme(context).textColor,
          size: 50.sp,
        );
      },
    );
  }

  static void closeLoading(context) {
    Navigator.pop(context); //pop dialog
  }

  static void showToast(context, mess) {
    Fluttertoast.showToast(
        msg: mess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: MyColors.primaryDekLight);
  }

  static void showErrorToast(context, mess) {
    Fluttertoast.showToast(
        msg: mess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red);
  }

  static void showSuccessToast(context, mess) {
    Fluttertoast.showToast(
        msg: mess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green);
  }
  Future<void> saveSharedReferences(DriverModel driverModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DriverModel driver=driverModel;
    String driverStr=  jsonEncode(driver.toJason());

    await prefs.setString('driver', driverStr);

  }
  Future<DriverModel> getSharedReferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DriverModel driver=DriverModel();

    String driverStr= prefs.getString('driver')??'NULL';

    if(driverStr!='NULL')
    {
      driver=DriverModel.fromJson(jsonDecode(driverStr));
    }

    return driver;
  }

Future<void> removeSharedReferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('driver', 'NULL');

}

}
