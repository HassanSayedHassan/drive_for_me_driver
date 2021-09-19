import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_for_me_user/constants/map_config.dart';
import 'package:drive_for_me_user/helpers/help_fun.dart';
import 'package:drive_for_me_user/models/current_user_model.dart';
import 'package:drive_for_me_user/models/driver_model.dart';
import 'package:drive_for_me_user/models/request_model.dart';
import 'package:drive_for_me_user/providers/driver_provider.dart';
import 'package:drive_for_me_user/screens/home_screen.dart';
import 'package:drive_for_me_user/screens/success_send_email.dart';
import 'package:drive_for_me_user/screens/taped_screens.dart';
import 'package:drive_for_me_user/widgets/end_trip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FireBaseApi {
  FirebaseAuth auth = FirebaseAuth.instance;
  BuildContext context;
  FireBaseApi(this.context);



  Future<void> driverLogIn({String? phone,String? pass}) async
  {
    HelpFun.showLoading(context);

    DriverModel driverModel=DriverModel();
    try{
      FirebaseFirestore.instance.collection('drivers').where("phone",isEqualTo:phone).where("password",isEqualTo:pass)
          .get().then((QuerySnapshot querySnapshot) async {


        if(querySnapshot.docs.isEmpty)
        {
          HelpFun.showErrorToast(context, 'Driver account not Found');
          HelpFun.closeLoading(context);

        }
        else
        {
          querySnapshot.docs.forEach((doc) {
             driverModel=DriverModel.fromJson(doc.data() as Map<String,dynamic>);
            print("driveridlogin  ${driverModel.id}");
          });

          HelpFun.showSuccessToast(context, 'LoginSuccessfully');
          HelpFun.closeLoading(context);

          await saveDriverToken(driverModel.id!);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('driverId', driverModel.id!);
          print("currentDriverUidsaved ${driverModel.id!}");
          Provider.of<DriverProvider>(context,listen: false).updateCurrentDriver(driverModel);

          HelpFun().saveSharedReferences(driverModel);

          Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HomeScreen(),));

        }
      });


    }
    catch(er)
    {
      HelpFun.showErrorToast(context, 'Catch Error ${er.toString()}');
      HelpFun.closeLoading(context);
    }
    
  }

  Future<void>  setCurrentDriveStatus(bool  status,String id) async
  {

    FirebaseFirestore.instance.collection('drivers').doc(id).update({
      "status":!status,
    });

  }
  
  
  

  Future<void> saveDriverToken(String id) async
  {
    String? token = await FirebaseMessaging.instance.getToken();

    FirebaseFirestore.instance.collection('drivers').doc(id).update({
      "token":token,
    });

  }

  Future<void> saveAdminToken() async
  {
    String? token = await FirebaseMessaging.instance.getToken();

    FirebaseFirestore.instance.collection('admin').doc('admin').update({
      "token":token,
    });

  }

  Future<void> signUpFun(String username, String email, String phone,String password) async
  {
    HelpFun.showLoading(context);
     late   UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );


    } on FirebaseAuthException catch (e) {
      HelpFun.closeLoading(context);
      if (e.code == 'weak-password') {
        HelpFun.showErrorToast(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        HelpFun.showErrorToast(context, 'The account already exists for that email.');
      }
      return ;
    } catch (e) {
      HelpFun.closeLoading(context);
      print(e);
      HelpFun.showErrorToast(context, e.toString());
      return ;
    }

    try {
      await userCredential.user?.sendEmailVerification();
      await writeNewUserData(userCredential.user!.uid,username,email,phone,password);
    } catch (e) {

      HelpFun.closeLoading(context);
      print("An error occured while trying to send email        verification");
      print(e.toString());
      HelpFun.showErrorToast(context, e.toString());
      return ;
    }

  }
  Future<void> writeNewUserData(String uid,String username, String email, String phone,String password) async

  {

    try {
      String? token = await FirebaseMessaging.instance.getToken();
      CurrentUserModel currentUserModel=CurrentUserModel(
          email: email, id: uid,name: username,phone: phone,pass: password,token: token
      );
   await   FirebaseFirestore.instance.collection('users').doc(uid).set(currentUserModel.toJson());

    }
    catch(e) {
      HelpFun.closeLoading(context);
      HelpFun.showErrorToast(context, e.toString());
      print("An error occured while  Write Data");
      print(e.toString());
      return;
    }

    HelpFun.showSuccessToast(context, 'Success Send Email Varification');
    HelpFun.closeLoading(context);

     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) {
               return new SuccessSendEmail();}), (route) => false);

  }


  Future<void> logInFun(String email,String pass) async
  {
   late UserCredential userCredential;
    HelpFun.showLoading(context);
    try {
       userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email:email,
          password: pass
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        HelpFun.closeLoading(context);
        HelpFun.showErrorToast(context,'No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        HelpFun.closeLoading(context);
        HelpFun.showErrorToast(context,'Wrong password provided for that user.');
        print('Wrong password provided for that user.');
      }
      return;
    }
    catch(e)
    {
      HelpFun.closeLoading(context);
      HelpFun.showErrorToast(context, e.toString());
      return;
    }

   if (userCredential.user!.emailVerified)
     {

       HelpFun.showSuccessToast(context, 'Log in Successfully');

       HelpFun.closeLoading(context);
        Navigator.push(context, MaterialPageRoute(
                builder: (context) => HomeScreen(),));
     }
   else
     {
       HelpFun.closeLoading(context);
       HelpFun.showErrorToast(context, 'Email not Verified yet');

     }



  }


  Future<void> addNewRider({String ?name,String ?password,String ?carNumber,String ?phone,String ?carColor,String ?carType}) async
  {
   // HelpFun.showLoading(context);
    HelpFun.showToast(context, 'Creating....');
    DriverModel driverModel =DriverModel();
    driverModel.name=name;
    driverModel.phone=phone;
    driverModel.password=password;
    driverModel.carColor=carColor;
    driverModel.carNumber=carNumber;
    driverModel.carType=carType;

    try{
      var path =FirebaseFirestore.instance.collection('drivers').doc();
      driverModel.id=path.id;
    await  FirebaseFirestore.instance.collection('drivers').doc(driverModel.id).set(driverModel.toJason());




      HelpFun.showSuccessToast(context, 'Driver Added Successfully');
    }
    catch(e){
      print("catch error on addNewRider ${e.toString()}");
      HelpFun.showErrorToast(context, "catch error on addNewRider ${e.toString()}");


    }




  }



  Future<void> driverArriveFun(RequestModel requestModel)async
  {
    HelpFun.showToast(context,'Picking User');

    try{
      await FirebaseFirestore.instance.collection('requests').doc(requestModel.id).
      update({
        'status':"onWay",
        "pickedDate":DateTime.now().toIso8601String().toString(),
      });

      /// Send Notification To User
      sendNotificationToUser(false,"Drive Arrive To PickUp Location , Hope Safe Trip",requestModel.currentUserModel!.token!,requestModel.driverModel!.name!);

    }
    catch(e)
    {
      HelpFun.showErrorToast(context, 'Catch Error on driverArriveFun ${e.toString()}');
      HelpFun.closeLoading(context);
    }

  }

  Future<void> driverEndFun(RequestModel requestModel)async
  {
    HelpFun.showToast(context,'Ending Trip');

    try{
      await FirebaseFirestore.instance.collection('requests').doc(requestModel.id).
      update({
        'status':"end",
        "dropOffData":DateTime.now().toIso8601String().toString(),
      });

      await FirebaseFirestore.instance.collection('drivers').doc(requestModel.driverModel!.id!).
      update({
        'hasOrder':false,
      });
      await FirebaseFirestore.instance.collection('users').doc(requestModel.currentUserModel!.id!).
      update({
        'hasOrder':false,
      });

      await FirebaseFirestore.instance.collection('drivers').doc(requestModel.driverModel!.id!).
      update({
        'ordersNumber':FieldValue.increment(1),
        "totalCash":FieldValue.increment(requestModel.cashPrice!)
      });
      await FirebaseFirestore.instance.collection('users').doc(requestModel.currentUserModel!.id!).
      update({
        'ordersNumber':FieldValue.increment(1),
      });
      sendNotificationToUser(false,"Drive Arrive To dropOff Location , Thanks For You",requestModel.currentUserModel!.token!,requestModel.driverModel!.name!);
      /// user and driver end orders
      /// Send Notification To User




    }
    catch(e)
    {
      HelpFun.showErrorToast(context, 'Catch Error on driverEndFun ${e.toString()}');
      HelpFun.closeLoading(context);
    }

  }
  Future<void> updateDriverImage(DriverModel driverModel,File imageFile)async
  {
    HelpFun.showLoading(context);


    try
    {

        FirebaseStorage  storage  = FirebaseStorage.instance;
        Reference ref = storage.ref().child('uploads/${driverModel.id}/${DateTime.now()}');
        UploadTask uploadTask = ref.putFile(imageFile);


        var res= await uploadTask;
        String imageUrl= await res.ref.getDownloadURL();

        driverModel.imageUrl=imageUrl;


      await FirebaseFirestore.instance.collection('drivers').doc(driverModel.id).update(driverModel.toJason()).whenComplete(() async {

        HelpFun().saveSharedReferences(driverModel);
        Provider.of<DriverProvider>(context,listen: false).updateCurrentDriver(driverModel);
        print(" after Url ${Provider.of<DriverProvider>(context,listen: false).getCurrentDriver.imageUrl}");
      });


      HelpFun.closeLoading(context);
      HelpFun.showSuccessToast(context, "Update");

    }
    catch(e)
    {
      HelpFun.closeLoading(context);
      HelpFun.showErrorToast(context, 'Catch error on  updateUser ${e.toString()}');
      print('Catch error on  updateUser ${e.toString()}');

    }



  }



  Future<void> sendNotificationToUser(bool isChat,String body ,String userToken,String driverName)async
  {
    var title=isChat?"Message":"Request";
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAAr5ZbWm4:APA91bH6IMCIASjSCrnnM_EOfgSATXGzzLchxT0ksno_9d7WTmWGPcXrR_dcJ5QXUDExo4RoPUNZOy13DbFS5_A96mcGVfOVd0BvTEiRirTZBgI9QmNapOrssl1tPkY-k66ThnSdBwBQ'
    };
    var request = http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": userToken,
      "notification": {
        "body": "$body",
        "OrganizationId": "2",
        "content_available": true,
        "priority": "high",
        "subtitle": "New Request ",
        "android_channel_id": "high_importance_channel",
        "playsound": "true",
        "sound": "taxi",
        "title": "New $title"
      },
      "data": {
        "priority": "high",
        "sound": "taxi",
        "content_available": true,
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<List<RequestModel>> getAllDriverTrips(DriverModel driverModel)async
  {
    // HelpFun.showLoading(context);

    List<RequestModel> requestList=[];

    try
    {
      await FirebaseFirestore.instance.collection('requests').where("driverModel.id",isEqualTo: driverModel.id)
          .where("status",isEqualTo: "end").get().then((QuerySnapshot querySnapshot) async {



        querySnapshot.docs.forEach((doc) {

          requestList.add(RequestModel.fromJson(doc.data() as Map<String,dynamic>));


        });

        print("RequestsList  ${requestList.length}");
        requestList.sort((a, b) => b.pickedDate!.compareTo(a.pickedDate!));
        return requestList;

      });


      // HelpFun.closeLoading(context);
      //HelpFun.showSuccessToast(context, "Update");

    }
    catch(e)
    {
      HelpFun.closeLoading(context);
      HelpFun.showErrorToast(context, 'Catch error on  getAllTrips ${e.toString()}');
      print('Catch error on  getAllTrips ${e.toString()}');

    }
    return requestList;


  }

}



