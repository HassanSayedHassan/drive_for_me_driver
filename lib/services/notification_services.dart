
import 'package:drive_for_me_user/helpers/help_fun.dart';
import 'package:drive_for_me_user/main.dart';
import 'package:drive_for_me_user/screens/current_request_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationServices
{
  var context;
  PushNotificationServices(this.context);

  Future inialize()async
  {
    FirebaseMessaging.onMessage.listen((message) {
      print('on message');
      print(message.data.toString());
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
             //   color: Colors.blue,
                playSound: true,

                icon: '@mipmap/ic_launcher',
                sound: RawResourceAndroidNotificationSound('taxi'),
              ),
            ));
      }

  //     Navigator.push(context, MaterialPageRoute(
    //           builder: (context) => CurrentRequestScreen(),));


   //   HelpFun.showToast(context, 'on message');
    });

    // when click on notification to open app
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('on message opened app');
      print(message.data.toString());

  //    Navigator.push(context, MaterialPageRoute(
  //      builder: (context) => CurrentRequestScreen(),));


  //    HelpFun.showToast(context, 'on message opened app');
    });


    // background fcm
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
  {
    print('on background message');
    print(message.data.toString());
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
             // color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
              sound: RawResourceAndroidNotificationSound('taxi'),
            ),
          ));
    }
 //   Navigator.push(context, MaterialPageRoute(
 //     builder: (context) => CurrentRequestScreen(),));

  //  HelpFun.showToast(context, 'on background message');

  }




}