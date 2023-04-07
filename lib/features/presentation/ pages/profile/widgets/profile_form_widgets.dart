import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/color.dart';
import '../../../../../core/constants/constans.dart';

class ProfileFormWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  const ProfileFormWidget({Key? key, this.title, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title", style:TextStyle(color: AppColors.primaryColor, fontSize: 16.sp),),
        sizeVer(8.h),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: AppColors.primaryColor),
          decoration: const InputDecoration(
              border: InputBorder.none,
              labelStyle: TextStyle(color: AppColors.primaryColor)
          ),
        ),
        const Divider(
          thickness: 1,
          color: AppColors.secondaryColor,
        ),
      ],
    );
  }
}