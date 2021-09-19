import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImageInScreen extends StatelessWidget {
  final String imageUrl;

  ShowImageInScreen(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
        )
    );
  }
}