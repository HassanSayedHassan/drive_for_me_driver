import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:drive_for_me_user/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../res.dart';

class SuccessSendEmail extends StatefulWidget {
  @override
  _SuccessSendEmailState createState() => _SuccessSendEmailState();
}

class _SuccessSendEmailState extends State<SuccessSendEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.center ,
        children: [
          SvgPicture.asset(
            Res.success_circle,
            width: 100.w,
            height: 100.h,
            color: MyTheme(context).iconColor,
          ),
          SizedBox(height: 20.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Congratulation !",
                style: TextStyle(
                  fontSize: 18.sp,
                  color: MyTheme(context).textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "We Send Varification Email ,\nPlease Check Your Email ",
                style: TextStyle(
                  fontSize: 18.sp,
                  color: MyTheme(context).textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h,),
          drowButton(text: 'Log IN Now',onTab: ()
          {
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) {
                       return new LoginScreen();}), (route) => false);
          }),
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
      onPressed:onTab ,
      style: ElevatedButton.styleFrom(
        primary: MyTheme(context).buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 11.h),
      ),
    );
  }
}
