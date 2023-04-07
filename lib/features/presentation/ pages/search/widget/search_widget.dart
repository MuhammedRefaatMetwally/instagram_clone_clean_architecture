import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/color.dart';



class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  const SearchWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40.h,
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(.3),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: primaryColor),
        decoration:  InputDecoration(
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: primaryColor,),
            hintText: "Search",
            hintStyle: TextStyle(color: secondaryColor, fontSize: 18.sp)
        ),
      ),
    )
    ;
  }
}
