
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'color.dart';
Widget sizeVer(double height) {
  return SizedBox(height: height,);
}

Widget sizeHor(double width) {
  return SizedBox(width: width);
}





void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.blueColor,
      textColor: Colors.white,
      fontSize: 16.0);
}