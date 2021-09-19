import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_for_me_user/helpers/help_fun.dart';
import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:drive_for_me_user/providers/driver_provider.dart';
import 'package:drive_for_me_user/screens/current_request_screen.dart';
import 'package:drive_for_me_user/screens/login_screen.dart';
import 'package:drive_for_me_user/screens/profile_screen.dart.dart';
import 'package:drive_for_me_user/screens/show_all_trips_list.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../res.dart';

class NavDrawer extends StatefulWidget {

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {


  @override
  Widget build(BuildContext context) {
    var driver = Provider.of<DriverProvider>(context).getCurrentDriver;
    return Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: Text(
              driver.name!,
              style: TextStyle(
                  fontSize: 19.sp,
                  color: MyTheme(context).textColor,
                  fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              driver.phone!,
              style: TextStyle(
                  fontSize: 17.sp,
                  color: MyTheme(context).textColor,
                  fontWeight: FontWeight.bold),
            ),
            decoration: new BoxDecoration(
              color: MyTheme(context).backgroundColor,
              image: new DecorationImage(
                image: new MyTheme(context).appLogo,
                alignment: Alignment.topRight,
                // fit: BoxFit.cover,
              ),
            ),
            currentAccountPicture: Consumer<DriverProvider>(
              builder: (context, driverProvider, child) => Container(
                width: 100.w,
                height: 90.h,
                decoration: BoxDecoration(
                  //color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    driverProvider.getCurrentDriver.imageUrl ?? "",
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
            ),
          ),
          new ListTile(
              leading: Icon(Icons.account_box_outlined),
              title: new Text("profile"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ));
              }),
          new ListTile(
              leading: Icon(Icons.my_location),
              title: new Text("Current Trip"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CurrentRequestScreen(),
                    ));
              }),
          new ListTile(
              leading: Icon(Icons.directions_car),
              title: new Text("All Trips"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowAllTripsList(),
                    ));
              }),
          new ListTile(
              leading: Theme.of(context).brightness != Brightness.dark
                  ? Icon(Icons.dark_mode_outlined)
                  : Icon(Icons.light_mode),
              title: new Text("Change Theme"),
              onTap: () {
                if (Theme.of(context).brightness != Brightness.dark) {
                  EasyDynamicTheme.of(context).changeTheme();
                  EasyDynamicTheme.of(context).changeTheme();
                } else {
                  EasyDynamicTheme.of(context).changeTheme();
                }
              }),
          new Divider(),
          new ListTile(
              leading: Icon(Icons.info),
              title: new Text("About"),
              onTap: () {
                Navigator.pop(context);
              }),
          new ListTile(
              leading: Icon(Icons.power_settings_new),
              title: new Text("Logout"),
              onTap: () async {
                await HelpFun().removeSharedReferences();
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (c) {
                  return new LoginScreen();
                }), (route) => false);
              }),
        ],
      ),
    );
  }
}
