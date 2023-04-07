import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/app_entity.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../core/constants/color.dart';
import '../../../../../../core/constants/constans.dart';
import '../../../../../domain/entity/comments/comment_entity.dart';
import '../../../../../domain/entity/user/user_entity.dart';
import '../../../../cubit/comment/comment_cubit.dart';
import '../../../../widgets/profile_widget.dart';

class CommentSectionWidget extends StatefulWidget {
   const CommentSectionWidget({Key? key, required this.currentUser, required this.appEntity,required this.descriptionController}) : super(key: key);
  final UserEntity currentUser;
  final AppEntity appEntity;
  final TextEditingController descriptionController;
  @override
  State<CommentSectionWidget> createState() => _CommentSectionWidgetState();
}

class _CommentSectionWidgetState extends State<CommentSectionWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 56.h,
        color: Colors.grey[800],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          child: Row(
            children: [
              SizedBox(
                width: 40.w,
                height: 40.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: profileWidget(imageUrl:widget.currentUser.profileUrl),
                ),
              ),
              sizeHor(10),
              Expanded(
                  child: TextFormField(
                    controller: widget.descriptionController,
                    style: const TextStyle(color: AppColors.primaryColor),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Post your comment...",
                        hintStyle: TextStyle(color: AppColors.secondaryColor)),
                  )),
              GestureDetector(
                  onTap: () {
                    _createComment(widget.currentUser,context);
                  },
                  child: Text(
                    "Post",
                    style: TextStyle(fontSize: 16.sp, color: AppColors.blueColor),
                  ))
            ],
          ),
        ),
      );
  }

  _createComment(UserEntity currentUser,BuildContext context) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
        comment: CommentEntity(
          totalReplays: 0,
          commentId: const Uuid().v1(),
          createAt: Timestamp.now(),
          likes: const [],
          username: currentUser.username,
          userProfileUrl: currentUser.profileUrl,
          description: widget.descriptionController.text,
          creatorUid: currentUser.uid,
          postId: widget.appEntity.postId,
        ))
        .then((value) {
      setState(() {
        widget.descriptionController.clear();
      });
    });
  }
}
