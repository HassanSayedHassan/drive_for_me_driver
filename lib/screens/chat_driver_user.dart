import 'dart:convert';
import 'dart:io';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_for_me_user/helpers/api_handlar.dart';
import 'package:drive_for_me_user/helpers/help_fun.dart';
import 'package:drive_for_me_user/models/current_user_model.dart';
import 'package:drive_for_me_user/models/driver_model.dart';
import 'package:drive_for_me_user/models/request_model.dart';
import 'package:drive_for_me_user/providers/driver_provider.dart';
import 'package:drive_for_me_user/screens/show_image_in_screen.dart';
import 'package:drive_for_me_user/services/firebase_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:drive_for_me_user/helpers/location_help_func.dart';
import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class ChatDriverUser extends StatefulWidget {
  final  RequestModel? requestModel;
  ChatDriverUser(this.requestModel);
  @override
  _ChatDriverUserState createState() => _ChatDriverUserState();
}

class _ChatDriverUserState extends State<ChatDriverUser> {

  final ImagePicker _picker = ImagePicker();
  XFile? image = XFile("");
  File imageFile = File("");

  TextEditingController messageController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    DriverModel user =  Provider.of<DriverProvider>(context).getCurrentDriver;
    return Scaffold(
        backgroundColor: MyTheme(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: MyTheme(context).buttonColor,
          title: Text("Chat With User ${widget.requestModel!.currentUserModel!.name!}"),
        ),
        body: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .doc(widget.requestModel!.id)
                  .collection('messages')
                  .orderBy('data', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loading(context) ;
                }
                if(snapshot.data==null)
                {
                  return Center(
                    child:  Text("No Message Yet ",
                      style: TextStyle(
                          fontSize: 22.sp,
                          color: MyTheme(context).textColor,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return   Column(
                  children: [
                    Expanded(
                      child: new ListView(
                        reverse: true,
                        children: snapshot.data?.docs.map((DocumentSnapshot document) {
                          allMessagesReaded();
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          print("heere ${data}");
                          return data['type']=='text'? drowMessage(
                            data['message'],
                            data['senderId'],
                            data['data'],
                            user,
                          ): drowImage(
                            data['message'],
                            data['senderId'],
                            data['data'],
                            user,
                          );
                        }).toList() as List<Widget>,

                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                icon: Icon(Icons.add_a_photo),
                                color: MyTheme(context).iconColor,
                                iconSize: 32.sp,
                                onPressed: () {
                                  sendImageMessage(user);
                                }),
                            Expanded(
                              child: Container(
                                child: TextField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme(context).buttonColor,
                                          width: 2.w),
                                      borderRadius: BorderRadius.circular(
                                          25),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme(context).buttonColor,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(
                                          25),
                                    ),
                                    hintText: 'Type a message here..',
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.send),
                                color:MyTheme(context).iconColor,
                                iconSize:40.sp,
                                onPressed: () {
                                  if(messageController.text.isEmpty)
                                  {
                                    HelpFun.showToast(context, "Please Enter Any Message");
                                  }
                                  else
                                  {
                                      String newMessage=messageController.text;
                                      messageController.clear();
                                    sendTextMessage(user,newMessage);

                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                );


              },
            ),


          ],
        )
    );
  }

  Widget drowMessage(message, senderId, data,DriverModel user) {
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: senderId == user.id?Alignment.topRight:Alignment.topLeft,
      nip: senderId == user.id?BubbleNip.rightTop:BubbleNip.leftTop,
      color: senderId == user.id ? MyTheme(context).chatContainerRightColor : MyTheme(context).chatContainerLeftColor,
      padding: BubbleEdges.only(top: 7.h, right:  5.w,left: 5.w),
      child: Column(
        children: [
          Text(
            message,
            style: TextStyle(
              color: senderId == user.id
                  ? MyTheme(context).chatTextRightColor
                  : MyTheme(context).chatTextLeftColor,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 5.h,),
          Text(
            //  timeago.format(DateTime.parse(data)),
            getdata(data),

            style: TextStyle(
                color: senderId == user.id
                    ? MyTheme(context).chatTextRightColor
                    : MyTheme(context).chatTextLeftColor,
                fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
  Widget drowImage(message, senderId, data,DriverModel user) {
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: senderId == user.id?Alignment.topRight:Alignment.topLeft,
      nip: senderId == user.id?BubbleNip.rightTop:BubbleNip.leftTop,
      color: senderId == user.id ? MyTheme(context).chatContainerRightColor : MyTheme(context).chatContainerLeftColor,
      // padding: BubbleEdges.only(top: 7.h),
      child: Column(
        children: [
          InkWell(
              onTap: ()
              {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ShowImageInScreen(message),));
              },
              child: Image.network(message,height: 250.h,width: 280.w,fit: BoxFit.cover,)),
          SizedBox(height: 5.h,),
          Text(
            //  timeago.format(DateTime.parse(data)),
            getdata(data),

            style: TextStyle(
                color: senderId == user.id
                    ? MyTheme(context).chatTextRightColor
                    : MyTheme(context).chatTextLeftColor,
                fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  String getdata(data) {
    DateTime todayDate = DateTime.parse(data);
    return DateFormat("yyyy/MM/dd    hh:mm").format(todayDate);
  }

  Future<void> sendTextMessage(DriverModel user,String newMessage) async {



    await  FirebaseFirestore.instance.collection('requests')
        .doc(widget.requestModel!.id)
        .collection("messages").add({
      'message': newMessage,
      'type': 'text',
      'data': DateTime.now()
          .toIso8601String()
          .toString(),
      'senderId': user.id,
    });
    print("token Here ${widget.requestModel!.currentUserModel!.token!}");
    FireBaseApi(context).sendNotificationToUser(true,"New Message from  ${widget.requestModel!.driverModel!.name!}",widget.requestModel!.currentUserModel!.token!, widget.requestModel!.driverModel!.name!);

    /// TODO fore Unread Messages

    FirebaseFirestore.instance.collection('requests')
        .doc(widget.requestModel!.id)
        .collection("messages").doc("metaData")
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        await  FirebaseFirestore.instance.collection('requests')
            .doc(widget.requestModel!.id)
            .collection("messages").doc("metaData").update({
          "unreadUser":FieldValue.increment(1)
        });
        print('Document exists on the database');
      }
      else
      {
        await  FirebaseFirestore.instance.collection('requests')
            .doc(widget.requestModel!.id)
            .collection("messages").doc("metaData").set({
          "unreadUser":1
        });
      }
    });






  }

  Future<void> sendImageMessage(DriverModel user)
  async {

    await _picker.pickImage(source: ImageSource.gallery,imageQuality:20 ).then((value) {
      if (value != null)
      {
        setState(() {
          image = value;
          imageFile =File(image!.path);
        });
        showImageConfirmDialog( imageFile,user);

      }
    });

    FireBaseApi(context).sendNotificationToUser(true,"New Message from  ${widget.requestModel!.driverModel!.name!}",widget.requestModel!.currentUserModel!.token!, widget.requestModel!.driverModel!.name!);

    FirebaseFirestore.instance.collection('requests')
        .doc(widget.requestModel!.id)
        .collection("messages").doc("metaData")
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        await  FirebaseFirestore.instance.collection('requests')
            .doc(widget.requestModel!.id)
            .collection("messages").doc("metaData").update({
          "unreadUser":FieldValue.increment(1)
        });
        print('Document exists on the database');
      }
      else
      {
        await  FirebaseFirestore.instance.collection('requests')
            .doc(widget.requestModel!.id)
            .collection("messages").doc("metaData").set({
          "unreadUser":1
        });
      }
    });


  }

  void showImageConfirmDialog(File imageFile,DriverModel user) {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(imageFile,height: 350.h,width: 350.w,fit: BoxFit.cover,),
              SizedBox(height: 10,),
              drowButton(text: "Send Image",onTab: ()   {

                uploadImage(imageFile,user);

              }),
            ],
          ),
        );
      },
    );
  }

  Widget drowButton({String? text, required Function? onTab()  }) {
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
      onPressed: onTab,
      style: ElevatedButton.styleFrom(
        primary: MyTheme(context).buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 11.h),
      ),
    );
  }

  void uploadImage(File imageFile,DriverModel user)async {

    Navigator.pop(context);

    HelpFun.showLoading(context);

    try{
      FirebaseStorage  storage  = FirebaseStorage.instance;
      Reference ref = storage.ref().child('uploads/${user.id}/${DateTime.now()}');
      UploadTask uploadTask = ref.putFile(imageFile);


      var res= await uploadTask;

      String imageUrl= await res.ref.getDownloadURL();


      await FirebaseFirestore.instance.collection('requests')
          .doc(widget.requestModel!.id)
          .collection("messages").add({
        'message': imageUrl,
        'type': 'image',
        'data': DateTime.now()
            .toIso8601String()
            .toString(),
        'senderId': user.id,
      });

      HelpFun.closeLoading(context);

    }

    catch(e)
    {
      HelpFun.closeLoading(context);
      HelpFun.showErrorToast(context, "Catch error on uploadImage ${e.toString()}");
    }





  }
  void allMessagesReaded()
  {
    FirebaseFirestore.instance.collection('requests')
        .doc(widget.requestModel!.id)
        .collection("messages").doc("metaData")
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        await  FirebaseFirestore.instance.collection('requests')
            .doc(widget.requestModel!.id)
            .collection("messages").doc("metaData").update({
          "unreadDriver":0
        });
        print('Document exists on the database');
      }
      else
      {
        await  FirebaseFirestore.instance.collection('requests')
            .doc(widget.requestModel!.id)
            .collection("messages").doc("metaData").set({
          "unreadDriver":0
        });
      }
    });
  }
}
