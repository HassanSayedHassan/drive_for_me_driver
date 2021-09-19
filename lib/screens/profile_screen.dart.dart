import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:drive_for_me_user/providers/driver_provider.dart';
import 'package:drive_for_me_user/services/firebase_api.dart';
import 'package:drive_for_me_user/widgets/drow_rating.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../res.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final ImagePicker _picker = ImagePicker();
  XFile? image = XFile("");
  String imageURL = "";
  bool anyChange = false;
  bool hasImage = false;

  String subtitle = '';
  String content = '';
  String data = '';
  String id = '';

  double mySumRates=0.0;
  int myRatesNum=0;
  int myTotalOrder=0;
  double myTotalCash=0.0;

  @override
  Future<void> didChangeDependencies() async {
    var driver = Provider.of<DriverProvider>(context,listen: false).getCurrentDriver;
   var doc= await FirebaseFirestore.instance.collection("drivers").doc(driver.id).get();
   setState(() {
     mySumRates=doc.data()!["sumRates"];
     myRatesNum=doc.data()!["ratesNum"];
     myTotalOrder=doc.data()!["ordersNumber"];
     myTotalCash=doc.data()!["totalCash"];
   });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var driver = Provider.of<DriverProvider>(context).getCurrentDriver;
    return SafeArea(
        child: Scaffold(
            backgroundColor: MyTheme(context).backgroundColor,
            body: Stack(alignment: Alignment.center, children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),

                    Stack(alignment: Alignment.center, children: [
                      Consumer<DriverProvider>(
                          builder: (context, driverProvider, child) => Container(
                            width: 170.w,
                            height: 140.h,
                            decoration: BoxDecoration(
                              //color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: (image!.path != "")
                                  ? Image.file(
                                File(image!.path),
                                fit: BoxFit.cover,
                              ):Image.network(
                                driverProvider.getCurrentDriver.imageUrl??"",
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
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade50,
                          child: IconButton(
                              icon: Icon(
                                Icons.add_a_photo,
                                color: const Color(0xFF03144c),
                              ),
                              onPressed: () async {
                                await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      image = value;
                                      hasImage = true;
                                    });
                                  }
                                });
                              }
                              ),
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: 20.h,
                    ),
                    DrowRating(myRatesNum==0?0:(mySumRates/myRatesNum), 30.r),
                    SizedBox(
                      height: 20.h,
                    ),
                    drowText(text: driver.name!,isSVG: true,svgPath: Res.man ),
                    drowText(text: driver.phone!,isSVG: true,svgPath: Res.phone ),
                    drowText(text: "car Color: ${driver.carColor!}",isSVG: true,svgPath: Res.car ),
                    drowText(text: "car Type: ${driver.carType!}",isSVG: true,svgPath: Res.car ),
                    drowText(text: "car Number; ${driver.carNumber!}",isSVG: true,svgPath: Res.car ),
                    drowText(text: "Total Order:  $myTotalOrder",iconNam:Icons.format_list_numbered ),
                    drowText(text: "Total Cash:  $myTotalCash",iconNam:Icons.monetization_on_sharp ),
                    SizedBox(
                      height: 20.h,
                    ),

                  ],
                ),
              ),
              hasImage?Positioned(
                top: 20,
                right: 20,
                child: InkWell(
                    onTap: (){
                        
                      FireBaseApi(context).updateDriverImage(driver, File(image!.path));

                    },
                    child: Icon(Icons.save_outlined,color: MyTheme(context).iconColor,)),
              ):SizedBox(),
            ])));
  }

  Widget drowText({required String text,String? svgPath,bool isSVG=false,IconData? iconNam}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(width: 2.0, color: const Color(0xff518f82)),
      ),
      height: 55,
      child: Row(
        children: [
          isSVG ?SvgPicture.asset(
            svgPath!,
            color: MyTheme(context).textColor,
          ):Icon(
             iconNam,
            color: MyTheme(context).textColor,
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.elMessiri(
                textStyle: TextStyle(
                    color: MyTheme(context).textColor, letterSpacing: 0.5),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ],
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
      onPressed: onTab,
      style: ElevatedButton.styleFrom(
        primary: MyTheme(context).buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 11.h),
      ),
    );
  }
}
