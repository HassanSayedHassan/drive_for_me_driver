import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DrowRating extends StatelessWidget {
 final double? size;
 final double? rate;
 DrowRating(this.rate,this.size);
  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rate!,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: size!.sp,
      direction: Axis.horizontal,
    );
  }
}
