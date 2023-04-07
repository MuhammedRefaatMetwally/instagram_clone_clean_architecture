import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/comments/comment_entity.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/posts/post_entity.dart';
import '../../../core/constants/color.dart';
import '../../data/models/bottom_modal_sheet/bottom_modal_sheet_model.dart';
import '../../domain/entity/user/user_entity.dart';
import '../cubit/auth/auth_cubit.dart';

class OpenBottomModalSheet extends StatelessWidget {
  const OpenBottomModalSheet({Key? key, required this.options, required this.post, this.onDeleteTap, required this.currentUser,required this.comment,}) : super(key: key);
 final PostEntity post;
 final UserEntity currentUser;
 final CommentEntity comment;
 final BottomModalSheetModel options;
 final void Function()? onDeleteTap;
  static void show({required BottomModalSheetModel options}){
    showModalBottomSheet(context: options.context,
    builder: (ctx)=>  OpenBottomModalSheet( options: options, post: options.post??const PostEntity(),onDeleteTap: options.onDeleteTap, currentUser:options.currentUser??const UserEntity(), comment: options.comment??const CommentEntity() ,));
  }
  
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 132.h,
      decoration: BoxDecoration(color: backGroundColor.withOpacity(.8)),
      child: SingleChildScrollView(
        child: Container(
          margin:  EdgeInsets.symmetric(vertical: 8.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "More Options",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: primaryColor),
                ),
              ),
               SizedBox(
                height: 8.h,
              ),
              const Divider(
                thickness: 1,
                color: secondaryColor,
              ),
               SizedBox(
                height:8.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: GestureDetector(
                  onTap: options.firstOption=="Delete Post"||options.firstOption=="Delete Comment"?onDeleteTap:(){
                    Navigator.pushNamed(context, PageConst.editProfilePage, arguments: currentUser);
                  },
                  child: Text(
                    options.firstOption,
                    style:  TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp, color: primaryColor),
                  ),
                ),
              ),
              sizeVer(7),
              const Divider(
                thickness: 1,
                color: secondaryColor,
              ),
              sizeVer(7),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: InkWell(
                  onTap: options.secondOption=="Logout"?(){
                    BlocProvider.of<AuthCubit>(context).loggedOut();
                    Navigator.pushNamedAndRemoveUntil(context, PageConst.signInPage, (route) => false);
                  }:options.secondOption=="Update Post"?(){
                    Navigator.pushNamed(context, PageConst.updatePostPage, arguments: post);
                  }:(){
                    Navigator.pushNamed(
                        context, PageConst.updateCommentPage,
                        arguments: comment);
                  },
                  child: Text(
                    options.secondOption,
                    style:  TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp, color: primaryColor),
                  ),
                ),
              ),
              sizeVer(7),
            ],
          ),
        ),
      ),
    );
  }
}
