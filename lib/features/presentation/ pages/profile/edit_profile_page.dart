import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/user/user_entity.dart';
import 'package:insta_clone_clean_arc/features/domain/usecases/firebase_usecases/storage/uplode_image_to_usecase.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/profile/widgets/profile_form_widgets.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/user/user_cubit.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;
import '../../../../core/constants/color.dart';
import '../../../../core/constants/constans.dart';
import '../../widgets/profile_widget.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;
  const EditProfilePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController? _nameController;
  TextEditingController? _usernameController;
  TextEditingController? _websiteController;
  TextEditingController? _bioController;

  bool _isUpdating = false;

  File? _image;
  Future selectedImage() async {
    try{
      final pickedFile = await ImagePicker.platform.getImage(source: ImageSource.gallery);
      setState(() {
        if(pickedFile!=null){
          _image= File(pickedFile.path);
        }else{
          print("no image has been selected");
        }
      });
    } catch(e){
      toast("some error occurred $e");
    }
  }

  @override
  void initState() {
_nameController = TextEditingController(text: widget.currentUser.name);
_usernameController = TextEditingController(text: widget.currentUser.username);
_websiteController = TextEditingController(text: widget.currentUser.website);
_bioController = TextEditingController(text: widget.currentUser.bio);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.close,
              size: 32,
            )),
        title: const Text("Edit Profile"),
        actions:  [
          Padding(
            padding:  EdgeInsets.only(right: 8.0.w),
            child: GestureDetector(
              onTap: _updateUserProfileData,
              child: const Icon(
                Icons.done,
                color: AppColors.blueColor,
                size: 32,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding:  const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Center(
              child:SizedBox(
                width: 96.w,
                height: 96.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(56.r),
                  child: profileWidget(imageUrl: widget.currentUser.profileUrl,image: _image),
                ),
              ),
            ),
            sizeVer(15),
             Center(
              child: GestureDetector(
                onTap: selectedImage,
                child:  Text(
                  "Change Profile Picture",
                  style: TextStyle(
                      color: AppColors.blueColor, fontSize: 24.sp, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            sizeVer(16.h),
             ProfileFormWidget(
              title: "Name",
              controller: _nameController,
            ),
            sizeVer(16.h),
             ProfileFormWidget(
              title: "Username",
              controller: _usernameController,

            ),
            sizeVer(16.h),
             ProfileFormWidget(
              title: "Website",
              controller: _websiteController,
            ),
            sizeVer(16.h),
             ProfileFormWidget(
              title: "Bio",
               controller: _bioController,
             ),
            sizeVer(8.h),
            _isUpdating?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Please Wait... Updating",style: TextStyle(color: Colors.white),),
                    sizeHor(8.h),
                    const CircularProgressIndicator()
                  ],
                )
                :const SizedBox()
          ],
        ),
      ),
    );
  }

  _updateUserProfileData(){
    if(_image==null){
      _updateUserProfile("");
    }else{
      di.sl<UploadImageToStorageUseCase>().call(_image!,false,"profileImages").then((profileUrl) => {
        _updateUserProfile(profileUrl),
      });
    }
  }
  
  _updateUserProfile(String profileUrl){
    setState(() {
      _isUpdating=true;
    });
    BlocProvider.of<UserCubit>(context).updateUser(
        user: UserEntity(
          uid: widget.currentUser.uid,
          username: _usernameController!.text,
          website: _websiteController!.text,
          bio: _bioController!.text,
          name: _nameController!.text,
          profileUrl: profileUrl,
        ),
    ).then((value) => _clear());
  }

  _clear() {
    _nameController!.clear();
    _websiteController!.clear();
    _bioController!.clear();
    _usernameController!.clear();
    setState(() {
      _isUpdating=false;
    });

    Navigator.pop(context);
  }
}
