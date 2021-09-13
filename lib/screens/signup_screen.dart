import 'package:drive_for_me_user/helpers/help_fun.dart';
import 'package:drive_for_me_user/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../res.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
class SignupScreen extends StatefulWidget {


  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool isSecret = true;
  final formKey = GlobalKey<FormState>();

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
                        height: 10.h,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                             Text("Create  New  account and ,\n Start Your Trips",
                                 style: TextStyle(
                                 fontSize: 22,
                                 color: MyTheme(context).textColor,
                                 fontWeight: FontWeight.bold),
                                 ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      drowTextField(
                          controller: nameController,
                          prefixIconPath: Res.man,
                          hintText: "Enter Your Name",
                          validate: (value) {
                            return value!.length == 0
                                ? 'Please Enter Your Name'
                                : null;
                          }
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      drowTextField(
                          controller: emailController,
                          prefixIconPath: Res.email,
                          hintText: "Enter Your Email",
                          validate: (value) {
                            return value!.length == 0
                                ? 'Please Enter Your Email':!(value.contains('@'))
                                ? 'Please Enter Valid Email'
                                : null;
                          }
                      ),
                      SizedBox(
                        height: 20.h,
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
                        height: 20.h,
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
                        height: 30.h,
                      ),
                      drowButton(
                          text: 'Create Account',
                          onTab: () {
                            print('pressed');
                            final form = formKey.currentState!;

                            if (form.validate())
                            {
                              form.save();
                              FireBaseApi(context).signUpFun(nameController.text, emailController.text, phoneController.text, passController.text);

                            }
                          }
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "OR",
                        style: TextStyle(
                            fontSize: 22,
                            color: MyTheme(context).textColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Create account with",
                        style: TextStyle(
                          fontSize: 22,
                          color: MyTheme(context).textColor,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            Res.facebook,
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          ),
                          SvgPicture.asset(
                            Res.google_icon,
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have account?",
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          InkWell(
                            onTap: ()
                            {
                               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) {
                                         return new LoginScreen();}), (route) => false);
                            },
                            child: Text(
                              "LogIn",
                              style: TextStyle(
                                  fontSize: 22.sp,
                                  color: MyTheme(context).textColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),


              ]
                  ),


          )
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
              ),
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
        keyboardType: controller==phoneController?TextInputType.phone:TextInputType.text,
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
