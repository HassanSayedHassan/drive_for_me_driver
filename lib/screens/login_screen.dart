import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:drive_for_me_user/screens/taped_screens.dart';
import 'package:drive_for_me_user/services/firebase_api.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../res.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool isSecret = true;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {

    phoneController.text="01145229131";
    passController.text="123456789";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: MyTheme(context).backgroundColor,
          body: Stack(
            children: [
              Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 70.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 200.h,
                            width: 200.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MyTheme(context).appLogo,
                              ),
                            ),
                          ),
                        ],
                      ),
                      drowTextField(
                          controller: phoneController,
                          prefixIconPath: Res.phone,
                          hintText: "Enter Your phone",
                         validate: (value) {
                          return value!.length == 0
                              ? 'Please Enter Your phone'
                              : null;
                        }
                     ),
                      SizedBox(
                        height: 5.h,
                      ),
                      drowTextField(
                          controller: passController,
                          prefixIconPath: Res.lock,
                          hintText: "Enter Your pass",
                          validate: (value) {
                            return value!.length == 0
                                ? 'Please Enter Your pass' :value.length < 6?'Please Enter Strong pass'
                                : null;
                          }),
                      SizedBox(
                        height: 5.h,
                      ),
                      drowButton(
                          text: 'LogIn',
                          onTab: () {
                            print('pressed');
                            final form = formKey.currentState!;

                            if (form.validate())
                            {
                              form.save();

                              FireBaseApi(context).driverLogIn(phone: phoneController.text,pass: passController.text);


                            }
                          }
                          ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: InkWell(
                    onTap: () {
                      if (Theme.of(context).brightness != Brightness.dark) {
                        EasyDynamicTheme.of(context).changeTheme();
                        EasyDynamicTheme.of(context).changeTheme();
                      } else {
                        EasyDynamicTheme.of(context).changeTheme();
                      }
                    },
                    child: Icon(
                      Icons.mood,
                      color: Colors.amber,
                      size: 40,
                    )),
              )
            ],
          )),
    );
  }

  Widget drowTextField(
      {TextEditingController? controller,
      String? prefixIconPath,
      String? hintText,
        required String? Function(String? val)? validate,}) {
    return Container(
      width: 300.0,
      height: 55.0,
      child: TextFormField(
        validator: validate,
        obscureText: (isSecret && prefixIconPath == Res.lock),
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 3.h),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: MyTheme(context).borderEnabledColor, width: 2.w),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: MyTheme(context).borderFocusedColor, width: 2.w),
                borderRadius: BorderRadius.circular(20)),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(13),
              child: SvgPicture.asset(
                prefixIconPath!,
                color: MyTheme(context).iconColor,
              ),
            ),
            suffixIcon: prefixIconPath == Res.lock
                ? InkWell(
                    onTap: () {
                      setState(() {
                        isSecret = !isSecret;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: SvgPicture.asset(
                        isSecret ? Res.hide_eye : Res.eye,
                        color: MyTheme(context).iconColor,
                      ),
                    ),
                  )
                : SizedBox(),
            hintText: hintText,
            suffixStyle: TextStyle(color: MyTheme(context).textColor),
            hintStyle:
                TextStyle(color: MyTheme(context).hintColor, fontSize: 16.sp),
            labelStyle: TextStyle(color: MyTheme(context).textColor)),
        style: TextStyle(
          color: MyTheme(context).textColor,
          fontSize: 22.sp,
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
