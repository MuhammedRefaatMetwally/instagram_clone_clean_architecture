import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone_clean_arc/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import "package:insta_clone_clean_arc/injection_container.dart" as di;
import 'package:intl/intl.dart';
import '../../../../../core/constants/color.dart';
import '../../../../data/models/bottom_modal_sheet/bottom_modal_sheet_model.dart';
import '../../../../domain/entity/app_entity.dart';
import '../../../../domain/entity/posts/post_entity.dart';
import '../../../cubit/posts/get_single_post/get_single_post_cubit.dart';
import '../../../cubit/posts/posts_cubit.dart';
import '../../../widgets/open_bottom_modal_sheet.dart';
import '../../../widgets/profile_widget.dart';
import 'like_animation_widgets.dart';

class PostDetailMainWidget extends StatefulWidget {
  final String postId;

  const PostDetailMainWidget({Key? key, required this.postId})
      : super(key: key);

  @override
  State<PostDetailMainWidget> createState() => _PostDetailMainWidgetState();
}

class _PostDetailMainWidgetState extends State<PostDetailMainWidget> {
  String _currentUid = "";

  @override
  void initState() {
    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.postId);

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Post Detail"),
      ),
      backgroundColor: backGroundColor,
      body: BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
        builder: (context, getSinglePostState) {
          if (getSinglePostState is GetSinglePostLoaded) {
            final singlePost = getSinglePostState.post;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 32.w,
                            height: 32.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: profileWidget(
                                  imageUrl: "${singlePost.userProfileUrl}"),
                            ),
                          ),
                          sizeHor(8.w),
                          Text(
                            "${singlePost.username}",
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      singlePost.creatorUid == _currentUid
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
                                  }, post: singlePost,),);
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
                          child: profileWidget(
                              imageUrl: "${singlePost.postImageUrl}"),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _isLikeAnimating ? 1 : 0,
                          child: LikeAnimationWidget(
                              duration: const Duration(milliseconds: 200),
                              isLikeAnimating: _isLikeAnimating,
                              onLikeFinish: () {
                                setState(() {
                                  _isLikeAnimating = false;
                                });
                              },
                              child: const Icon(
                                Icons.favorite,
                                size: 100,
                                color: Colors.white,
                              )),
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
                              onTap: _likePost,
                              child: Icon(
                                singlePost.likes!.contains(_currentUid)
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                color: singlePost.likes!.contains(_currentUid)
                                    ? Colors.red
                                    : primaryColor,
                              )),
                          sizeHor(8.w),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageConst.commentPage,
                                    arguments: AppEntity(
                                        uid: _currentUid,
                                        postId: singlePost.postId));
                              },
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
                    "${singlePost.totalLikes} likes",
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  sizeVer(8.h),
                  Row(
                    children: [
                      Text(
                        "${singlePost.username}",
                        style: const TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                      sizeHor(8.w),
                      Text(
                        "${singlePost.description}",
                        style: const TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                  sizeVer(8.h),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.commentPage,
                            arguments: AppEntity(
                                uid: _currentUid, postId: singlePost.postId));
                      },
                      child: Text(
                        "View all ${singlePost.totalComments} comments",
                        style: const TextStyle(color: darkGreyColor),
                      )),
                  sizeVer(8.h),
                  Text(
                    DateFormat("dd/MMM/yyy")
                        .format(singlePost.createAt!.toDate()),
                    style: const TextStyle(color: darkGreyColor),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }



  _likePost() {
    BlocProvider.of<PostsCubit>(context)
        .likePosts(post: PostEntity(postId: widget.postId));
  }

   _deletePost() {
      BlocProvider.of<PostsCubit>(context).deletePosts(post: PostEntity(postId: widget.postId));
  }
}
