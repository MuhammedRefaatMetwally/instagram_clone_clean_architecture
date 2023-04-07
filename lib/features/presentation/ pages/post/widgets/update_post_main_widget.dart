import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;
import '../../../../../core/constants/color.dart';
import '../../../../../core/constants/constans.dart';
import '../../../../domain/entity/posts/post_entity.dart';
import '../../../../domain/usecases/firebase_usecases/storage/uplode_image_to_usecase.dart';
import '../../../cubit/posts/posts_cubit.dart';
import '../../../widgets/profile_widget.dart';
import '../../profile/widgets/profile_form_widgets.dart';

class UpdatePostMainWidget extends StatefulWidget {
  final PostEntity post;

  const UpdatePostMainWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<UpdatePostMainWidget> createState() => _UpdatePostMainWidgetState();
}

class _UpdatePostMainWidgetState extends State<UpdatePostMainWidget> {
  TextEditingController? _descriptionController;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.post.description);
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController!.dispose();
    super.dispose();
  }

  File? _image;
  bool? _uploading = false;

  Future selectImage() async {
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
      toast("some error occurred $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        title: const Text("Edit Post"),
        actions: [
          Padding(
            padding:  EdgeInsets.only(right: 8.0.w),
            child: GestureDetector(
                onTap: (){
                  if (kDebugMode) {
                    print("update");
                  }
                  Navigator.pop(context);
                  _updatePost();
                },
                child: const Icon(
                  Icons.done,
                  color: AppColors.blueColor,
                  size: 28,
                )),
          )
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 100.w,
                height: 100.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(56.r),
                  child: profileWidget(imageUrl: widget.post.userProfileUrl),
                ),
              ),
              sizeVer(8.h),
              Text(
                "${widget.post.username}",
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold),
              ),
              sizeVer(8.h),
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200.h,
                    child: profileWidget(
                        imageUrl: widget.post.postImageUrl, image: _image),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: selectImage,
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r)),
                        child: const Icon(
                          Icons.edit,
                          color: AppColors.blueColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              sizeVer(8.h),
              ProfileFormWidget(
                controller: _descriptionController,
                title: "Description",
              ),
              sizeVer(8.h),
              _uploading == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Updating...",
                          style: TextStyle(color: Colors.white),
                        ),
                        sizeHor(8.w),
                        const CircularProgressIndicator()
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  _updatePost() {
    setState(() {
      _uploading = true;
    });
    if (_image == null) {
      _submitUpdatePost(image: widget.post.postImageUrl!);
    } else {
      di
          .sl<UploadImageToStorageUseCase>()
          .call(_image!, true, "posts")
          .then((imageUrl) {
        _submitUpdatePost(image: imageUrl);
      });
    }
  }

  _submitUpdatePost({required String image}) {
    BlocProvider.of<PostsCubit>(context).updatePosts(
            post: PostEntity(
                creatorUid: widget.post.creatorUid,
                postId: widget.post.postId,
                postImageUrl: image,
                description: _descriptionController!.text))
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _descriptionController!.clear();
      Navigator.pop(context);
      _uploading = false;
    });
  }
}
