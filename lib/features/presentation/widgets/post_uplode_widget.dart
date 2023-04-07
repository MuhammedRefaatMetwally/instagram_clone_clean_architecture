import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/color.dart';

class PostUploadWidget extends StatelessWidget {
  const PostUploadWidget({Key? key, required this.onSelectedImage}) : super(key: key);
  final Future<void> Function()? onSelectedImage;

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: GestureDetector(
          onTap: onSelectedImage,
          child: Container(
            width: 156.w,
            height: 156.h,
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(.3),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.upload,
                color: primaryColor,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
