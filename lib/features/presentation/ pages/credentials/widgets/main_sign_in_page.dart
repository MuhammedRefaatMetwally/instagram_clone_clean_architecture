
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/color.dart';
import '../../../cubit/credentials/credentials_cubit.dart';
import '../../../widgets/button_container_widget.dart';
import '../../../widgets/form_container_widget.dart';

class MainSignInPage extends StatefulWidget {
  const MainSignInPage({Key? key}) : super(key: key);

  @override
  State<MainSignInPage> createState() => _MainSignInPageState();

}

class _MainSignInPageState extends State<MainSignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

   bool _isSigningIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Flexible(
            flex: 2,
            child: sizeVer(24.h),
          ),
          Center(
              child: SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
              )),
          sizeVer(32.h),
          FormContainerWidget(
            controller: _emailController,
            hintText: "Email",
          ),
          sizeVer(16.h),
          FormContainerWidget(
            controller: _passwordController,
            hintText: "Password",
            isPasswordField: true,
          ),
          sizeVer(24.h),
          ButtonContainerWidget(
            color: blueColor,
            text: "Sign In",
            onTapListener: () {
              _signInUser(context);
            },
          ),
          sizeVer(8.h),
          _isSigningIn
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                "Please wait",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400),
              ),
              sizeHor(8.w),
              const CircularProgressIndicator(),
            ],
          )
              : const SizedBox(),
           Flexible(
            flex: 2,
            child: sizeVer(24.h),
          ),
          const Divider(
            color: secondaryColor,
          ),
          sizeVer(32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account? ",
                style: TextStyle(color: primaryColor),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageConst.signUpPage, (route) => false);
                },
                child: const Text(
                  "Sign up",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  void _signInUser(BuildContext context) {
    setState(() {
      _isSigningIn = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signInUser(
        email: _emailController.text, password: _passwordController.text)
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _isSigningIn = false;
    });
  }
}



