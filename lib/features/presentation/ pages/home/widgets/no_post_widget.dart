import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoPostWidget extends StatelessWidget {
  const NoPostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text(
        "No Posts Yet",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp),
      ),
    );
  }
}
