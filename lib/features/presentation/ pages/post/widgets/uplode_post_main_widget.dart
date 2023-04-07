import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/posts/post_entity.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/user/user_entity.dart';
import 'package:insta_clone_clean_arc/features/domain/usecases/firebase_usecases/storage/uplode_image_to_usecase.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/posts/posts_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/widgets/post_uplode_widget.dart';
import 'package:insta_clone_clean_arc/features/presentation/widgets/profile_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;
import '../../../../../core/constants/color.dart';
import '../../profile/widgets/profile_form_widgets.dart';

class UploadPostMainWidget extends StatefulWidget {
  final UserEntity currentUser;

  const UploadPostMainWidget({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {
  File? _image;
  final TextEditingController _descriptionController = TextEditingController();
  bool _uploading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future selectedImage() async {
    try {
      final pickedFile =
      await ImagePicker.platform.getImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);

        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? PostUploadWidget(onSelectedImage: selectedImage,)
        : Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        leading: GestureDetector(
          onTap: () => setState(() {
            _image = null;
          }),
          child: const Icon(
            Icons.close,
            size: 28,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  _submitPost();
                }, child: const Icon(Icons.arrow_forward)),
          )
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
        child: Column(
          children: [
            SizedBox(
              width: 80.w,
              height: 80.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.r),
                child: profileWidget(
                    imageUrl: widget.currentUser.profileUrl),
              ),
            ),
            sizeVer(8.h),
            Text(
              "${widget.currentUser.username}",
              style: const TextStyle(color: Colors.white),
            ),
            sizeVer(8.h),
            SizedBox(
              width: double.infinity,
              height: 200.h,
              child: profileWidget(image: _image),
            ),
            sizeVer(32.h),
            ProfileFormWidget(
              title: "Description",
              controller: _descriptionController,
            ),
            sizeVer(8.h),
            _uploading==true?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Uploading....",style: TextStyle(color: Colors.white),),
                sizeHor(8.w),
                const CircularProgressIndicator(),
              ],
            ):const SizedBox()
          ],
        ),
      ),
    );
  }

  _submitPost() {

    setState(() {
      _uploading=true;
    });

    di.sl<UploadImageToStorageUseCase>()
        .call(_image, true, "posts")
        .then((imageUrl) {
      _createSubmitPost(image: imageUrl);
      Navigator.pushNamed(context, PageConst.mainScreen,arguments: widget.currentUser.uid);
    });
  }

  _createSubmitPost({required String image}) {
    BlocProvider.of<PostsCubit>(context).createPost(
        post: PostEntity(
          description: _descriptionController.text,
          createAt: Timestamp.now(),
          creatorUid: widget.currentUser.uid,
          likes: const [],
          postId: const Uuid().v1(),
          postImageUrl: image,
          totalComments: 0,
          totalLikes: 0,
          username: widget.currentUser.username,
          userProfileUrl: widget.currentUser.profileUrl,
        )).then((value) =>_clear());
  }
  _clear() {
    setState(() {
      _uploading=false;
    });
    _descriptionController.clear();
    _image=null;

  }

}
