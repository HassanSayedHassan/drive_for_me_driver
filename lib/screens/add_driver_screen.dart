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
class AddDriverScreen extends StatefulWidget {


  @override
  _AddDriverScreenState createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController carColorController = TextEditingController();

  bool isSecret = true;
  String _selectedCar="";
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: MyTheme(context).backgroundColor,
          body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                          height: 20.h,
                        ),
                        drowTextField(
                            controller: carNumberController,
                            prefixIconPath: Res.car,
                            hintText: "Enter Car number",
                            validate: (value) {
                              return value!.length == 0
                                  ? 'Please Enter Car number'
                                  : null;
                            }
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        drowTextField(
                            controller: carColorController,
                            prefixIconPath: Res.car,
                            hintText: "Please Enter Car Color",
                            validate: (value) {
                              return value!.length == 0
                                  ?'Please Enter Valid Email'
                                  : null;
                            }
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            drowCarCart("uber",Res.uber),
                            drowCarCart("uber_X",Res.uber_x),
                            drowCarCart("uber_XL",Res.uber_xl),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        drowButton(
                            text: 'Create New Driver',
                            onTab: () {
                              print('pressed');
                              final form = formKey.currentState!;

                              if (form.validate())
                              {
                                form.save();

                                if(_selectedCar=="")
                                  {
                                    HelpFun.showToast(context, 'Please Choose Car type');
                                  }
                                else{
                                  FireBaseApi(context).addNewRider(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      password: passController.text,
                                      carColor: carColorController.text,
                                      carNumber: carNumberController.text,
                                      carType: _selectedCar,
                                  );
                                }

                              }
                            }
                        ),
                        SizedBox(
                          height: 20.h,
                        ),

                      ]
                  ),
                ),


              )
          ),
      ),
    );
  }

  Widget drowCarCart(String text,String iconPath)
  {
    return   InkWell(
      onTap: ()
      {
       setState(() {
         _selectedCar==text?_selectedCar="":_selectedCar=text;
       });
      },
      child: Container(
        height: 100.h,
        width: 110.w,
        decoration: BoxDecoration(
            color: _selectedCar==text?MyTheme(context).iconColor:Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color:MyTheme(context).iconColor)
        ),
        child: Column(
          children: [
            Image.asset(iconPath,width: 70.w,height: 70.h,),
            Text(
              text,
              style: TextStyle(
                  fontSize: 20.sp,
                  color: _selectedCar==text?MyTheme(context).buttonTextColor:MyTheme(context).textColor ,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
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
