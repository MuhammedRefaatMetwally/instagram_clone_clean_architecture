import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/color.dart';
import '../../../../../core/constants/constans.dart';
import '../../../../../core/constants/page_constants.dart';
import '../../../../domain/entity/user/user_entity.dart';
import '../../../cubit/credentials/credentials_cubit.dart';
import '../../../widgets/button_container_widget.dart';
import '../../../widgets/form_container_widget.dart';
import '../../../widgets/profile_widget.dart';

class MainSignUpPage extends StatefulWidget {
  const MainSignUpPage({Key? key}) : super(key: key);

  @override
  State<MainSignUpPage> createState() => _MainSignUpPageState();
}

class _MainSignUpPageState extends State<MainSignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isSigningUP = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  File? _image;

  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });

    } catch(e) {
      toast("some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.h),
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
                color: AppColors.primaryColor,
              )),
          sizeVer(16.h),
          Center(
            child: Stack(
              children: [
                SizedBox(
                  width: 80.w,
                  height: 80.h,

                  child: ClipRRect(borderRadius: BorderRadius.circular(32.r),
                    child: profileWidget(image: _image),),
                ),
                Positioned(
                    right: -12,
                    bottom: -15,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: AppColors.blueColor,
                      ),
                    ))
              ],
            ),
          ),
          sizeVer(32.h),
          FormContainerWidget(
            controller: _usernameController,
            hintText: "Username",
          ),
          sizeVer(16.h),
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
          sizeVer(16.h),
          FormContainerWidget(
            controller: _bioController,
            hintText: "Bio",
          ),
          sizeVer(24.h),
          ButtonContainerWidget(
            color: AppColors.blueColor,
            text: "Sign up",
            onTapListener: () {
              _signUpUser();
            },
          ),
          sizeVer(8.h),
          _isSigningUP
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                "Please wait",
                style: TextStyle(
                    color:AppColors. primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400),
              ),
              sizeHor(8.h),
              const CircularProgressIndicator(),
            ],
          )
              : const SizedBox(),
          Flexible(
            flex: 2,
            child: sizeVer(24.h),
          ),
          const Divider(
            color: AppColors.secondaryColor,
          ),
          sizeVer(40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(color: AppColors.primaryColor),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageConst.signInPage, (route) => false);
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void _signUpUser() {
    setState(() {
      _isSigningUP = true;
    });

    BlocProvider.of<CredentialCubit>(context)
        .signUpUser(
        user: UserEntity(
          email: _emailController.text,
          password: _passwordController.text,
          bio: _bioController.text,
          username: _usernameController.text,
          totalPosts: 0,
          totalFollowing: 0,
          followers: const [],
          totalFollowers: 0,
          profileUrl: "",
          website: "",
          following: const [],
          name: "",
          imageFile: _image,
        ))
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _usernameController.clear();
      _passwordController.clear();
      _bioController.clear();
      _emailController.clear();
      _isSigningUP = false;
    });
  }
}

