// @dart=2.9
import 'package:drive_for_me_user/constants/color.dart';
import 'package:drive_for_me_user/models/driver_model.dart';
import 'package:drive_for_me_user/providers/driver_provider.dart';
import 'package:drive_for_me_user/providers/locations_data_providers.dart';
import 'package:drive_for_me_user/res.dart';
import 'package:drive_for_me_user/screens/home_screen.dart';
import 'package:drive_for_me_user/services/firebase_api.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'constants/color.dart';
import 'constants/color.dart';
import 'helpers/help_fun.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('taxi'),
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
//flutter run --no-sound-null-safety

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  alert: true,
  badge: true,
  sound: true,
  );
  DriverModel driver=await HelpFun().getSharedReferences();
  print("driver in main ${driver.name}");

  runApp(  EasyDynamicThemeWidget(child: MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return DriverProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return LocationsDataProviders();
          },
        ),
      ],
      child: MyApp(driver))));
}

class MyApp extends StatelessWidget {
  final DriverModel driver;
  MyApp(this.driver);
  var lightThemeData = new ThemeData(
    primaryColor: MyColors.primaryLight,
    fontFamily: Res.Roboto_Medium,
    brightness: Brightness.light,
  );

  var darkThemeData = ThemeData(
    primaryColor: MyColors.primaryDarkBlue,
    fontFamily: Res.Roboto_Medium,
    brightness: Brightness.dark,
  );


  @override
  Widget build(BuildContext context) {
    if(driver.name!='NULL')
    {
      Provider.of<DriverProvider>(context,listen: false).updateCurrentDriver(driver);
    }
    print("user in MyApp ${driver.id}");
    return ScreenUtilInit(
        designSize: Size(411, 731),
    builder: () =>MaterialApp(
      debugShowCheckedModeBanner: false,
              title: 'DriveForMe_Driver',
              theme: lightThemeData,
              darkTheme: darkThemeData,
             themeMode: EasyDynamicTheme.of(context).themeMode,
              home: driver.name=='NULL'? LoginScreen():HomeScreen(),
            ));
  }
}
