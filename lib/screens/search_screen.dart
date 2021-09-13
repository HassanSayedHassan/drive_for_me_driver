import 'package:drive_for_me_user/helpers/api_handlar.dart';
import 'package:drive_for_me_user/models/place.dart';
import 'package:drive_for_me_user/providers/locations_data_providers.dart';
import 'package:drive_for_me_user/services/location_sevices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../res.dart';
class SearchScreen extends StatefulWidget {


  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchController = TextEditingController();
  List<PlacePredictions>? placePredictionsList=[];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyTheme(context).backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              drowTopContainer(),
              SizedBox(height: 10,),
              placePredictionsList!.length>1?ListView.separated(itemBuilder: (context,index){
                return PredictionTitle(placePredictionsList![index]);
              }, separatorBuilder:  (context,index){return Divider();}, itemCount: placePredictionsList!.length,shrinkWrap: true,physics: ClampingScrollPhysics(),):SizedBox()
            ],
          ),
        ),
      ),
    );
  }

Widget  drowTopContainer() {
    var locationsDataProviders  = Provider.of<LocationsDataProviders>(context,listen: false);
    return Container(
      height: 200,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:Radius.circular(20) ),
          color: Theme.of(context).brightness != Brightness.dark?Colors.white:Color(0xff787878),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ]
      ),
      child: Column(
        children: [
          SizedBox(height: 40.h,),
          Row(
            children: [
              CircleAvatar(backgroundColor: MyTheme(context).iconColor,radius: 15.sp,
              child: Icon(Icons.my_location,color:MyTheme(context).backgroundColor),
              ),
               SizedBox(width: 20.w,),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     "Current Location",
                       style: TextStyle(
                       fontSize: 22.sp,
                       color: MyTheme(context).textColor,
                       fontWeight: FontWeight.bold),
                       ),
                    Text(
                      locationsDataProviders.picKUpLocation!.placeName ??"",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    )
                 ],
               ),

            ],
          ),
          SizedBox(height: 40.h,),
          Row(
            children: [
              CircleAvatar(radius: 18.sp,backgroundColor: Colors.transparent,child:
              SvgPicture.asset(Res.location,width: 30.w,height: 30.h,color: MyTheme(context).iconColor,) ,),

              SizedBox(width: 20.w,),
              drowTextField(hintText: '',controller: searchController),
            ],
          )
        ],
      ),
    );
}
  Widget drowTextField({TextEditingController? controller, String? hintText,}) {
    return Container(
      width: 250.0,
      height: 55.0,
      child: TextFormField(
        onChanged: (text)
        {
          if(text.length>1)
            {
              LocationServices().findPlaceCompleter(text,context).then((newList){
                setState(() {
                  placePredictionsList!.clear();
                  placePredictionsList!.addAll(newList!);

                });
              });

            }else{
            setState(() {
              placePredictionsList!.clear();

            });
          }

        },
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          fillColor: Colors.grey,
            focusColor:  Colors.grey,
            contentPadding: EdgeInsets.symmetric(vertical: 3.h,horizontal: 10.w),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: MyTheme(context).borderEnabledColor, width: 2.w),
                borderRadius: BorderRadius.circular(5)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: MyTheme(context).borderFocusedColor, width: 2.w),
                borderRadius: BorderRadius.circular(5)),

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

}
class PredictionTitle extends StatelessWidget
{
  final PlacePredictions placePredictions;
  PredictionTitle(this.placePredictions);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        LocationServices().getPlaceAddressDetails(placePredictions.placeId!,context);
      },
      child: Container(
        padding: EdgeInsets.only(left: 15),
        child: Column(
          children: [
            SizedBox(width: 10,),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(placePredictions.mainText!,overflow :TextOverflow.ellipsis ,style: TextStyle(fontSize:  16),),
                      SizedBox(height: 4,),
                      Text(placePredictions.secondaryText!,overflow :TextOverflow.ellipsis,style: TextStyle(fontSize:  12,color: Colors.grey),),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(width: 10,),
          ],
        ),
      ),
    );
  }


}
