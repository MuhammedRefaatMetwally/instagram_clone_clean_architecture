import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone_clean_arc/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/post/widgets/like_animation_widgets.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/posts/posts_cubit.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;
import 'package:intl/intl.dart';
import '../../../../../core/constants/color.dart';
import '../../../../data/models/bottom_modal_sheet/bottom_modal_sheet_model.dart';
import '../../../../domain/entity/app_entity.dart';
import '../../../../domain/entity/posts/post_entity.dart';
import '../../../widgets/open_bottom_modal_sheet.dart';
import '../../../widgets/profile_widget.dart';

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;

  const SinglePostCardWidget({Key? key, required this.post,}) : super(key: key);

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUserCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  bool _isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PageConst.singleUserProfilePage,
                      arguments: widget.post.creatorUid);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 32.w,
                      height: 32.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: profileWidget(
                            imageUrl: "${widget.post.userProfileUrl}"),
                      ),
                    ),
                    sizeHor(8.w),
                    Text(
                      "${widget.post.username}",
                      style: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              widget.post.creatorUid == _currentUid
                  ? GestureDetector(
                      onTap: () {
                        OpenBottomModalSheet.show(options: BottomModalSheetModel(
                            firstOption: "Delete Post",
                            secondOption: "Update Post",
                            context: context,
                            onDeleteTap:(){
                              if (kDebugMode) {
                                print("deleted");
                              }
                              Navigator.pop(context);
                              _deletePost();
                            }, post: widget.post,),);
                      },
                      child: const Icon(
                        Icons.more_vert,
                        color: primaryColor,
                      ))
                  : const SizedBox()
            ],
          ),
          sizeVer(8.h),
          GestureDetector(
            onDoubleTap: () {
              _likePost();
              setState(() {
                _isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: profileWidget(imageUrl: "${widget.post.postImageUrl}"),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isLikeAnimating?1:0,
                  child: LikeAnimationWidget(
                    duration: const Duration(milliseconds: 300),
                    isLikeAnimating: _isLikeAnimating,
                    onLikeFinish: (){
                      setState(() {
                        _isLikeAnimating=false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          sizeVer(8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        _likePost();
                      },
                      child: Icon(
                        widget.post.likes!.contains(_currentUid) ? Icons.favorite : Icons.favorite_outline,
                        color: widget.post.likes!.contains(_currentUid) ? Colors.red : primaryColor,
                      )),
                  sizeHor(8.h),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.commentPage, arguments: AppEntity(uid: _currentUid, postId: widget.post.postId));                      },
                      child: const Icon(
                        Feather.message_circle,
                        color: primaryColor,
                      )),
                  sizeHor(8.h),
                  const Icon(
                    Feather.send,
                    color: primaryColor,
                  ),
                ],
              ),
              const Icon(
                Icons.bookmark_border,
                color: primaryColor,
              )
            ],
          ),
          sizeVer(8.h),
          Text(
            "${widget.post.totalLikes} likes",
            style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          sizeVer(8.h),
          Row(
            children: [
              Text(
                "${widget.post.username}",
                style:
                    const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
              sizeHor(8.h),
              Text(
                "${widget.post.description}",
                style: const TextStyle(color: primaryColor),
              ),
            ],
          ),
          sizeVer(8.h),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  PageConst.commentPage,
                );
              },
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, PageConst.commentPage, arguments: AppEntity(uid: _currentUid, postId: widget.post.postId));
                },
                child: Text(
                  "View all ${widget.post.totalComments} comments",
                  style: const TextStyle(color: darkGreyColor),
                ),
              )),
          sizeVer(8.h),
          Text(
            DateFormat("dd/MMM/yyy").format(widget.post.createAt!.toDate()),
            style: const TextStyle(color: darkGreyColor),
          ),
        ],
      ),
    );
  }
  _deletePost() {
    BlocProvider.of<PostsCubit>(context)
        .deletePosts(post: PostEntity(postId: widget.post.postId));
  }

   _likePost() {
    BlocProvider.of<PostsCubit>(context).likePosts(post: PostEntity(
      postId: widget.post.postId
    ));
   }
}
