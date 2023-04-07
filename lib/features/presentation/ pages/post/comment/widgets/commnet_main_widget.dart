import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/reply/reply_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/widgets/open_bottom_modal_sheet.dart';
import 'package:uuid/uuid.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;
import '../../../../../../core/constants/color.dart';
import '../../../../../data/models/bottom_modal_sheet/bottom_modal_sheet_model.dart';
import '../../../../../domain/entity/app_entity.dart';
import '../../../../../domain/entity/comments/comment_entity.dart';
import '../../../../../domain/entity/user/user_entity.dart';
import '../../../../cubit/comment/comment_cubit.dart';
import '../../../../cubit/posts/get_single_post/get_single_post_cubit.dart';
import '../../../../cubit/user/get_single_user/get_single_user_cubit.dart';
import '../../../../widgets/profile_widget.dart';
import 'comment_section_widget.dart';
import 'singe_comment_widget.dart';

class CommentMainWidget extends StatefulWidget {
  final AppEntity appEntity;

  const CommentMainWidget({Key? key, required this.appEntity})
      : super(key: key);

  @override
  State<CommentMainWidget> createState() => _CommentMainWidgetState();
}

class _CommentMainWidgetState extends State<CommentMainWidget> {
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUsers(uid: widget.appEntity.uid!);

    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.appEntity.postId!);

    BlocProvider.of<CommentCubit>(context)
        .getComments(postId: widget.appEntity.postId!);

    super.initState();
  }

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Comments"),
      ),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, singleUserState) {
          if (singleUserState is GetSingleUserLoaded) {
            final singleUser = singleUserState.user;
            return BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
              builder: (context, singlePostState) {
                if (singlePostState is GetSinglePostLoaded) {
                  final singlePost = singlePostState.post;
                  return BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, commentState) {
                      if (commentState is CommentLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0.w, vertical: 8.0.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 40.w,
                                        height: 40.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: profileWidget(
                                              imageUrl:
                                                  singlePost.userProfileUrl),
                                        ),
                                      ),
                                      sizeHor(8.h),
                                      Text(
                                        "${singlePost.username}",
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor),
                                      ),
                                    ],
                                  ),
                                  sizeVer(8.h),
                                  Text(
                                    "${singlePost.description}",
                                    style: const TextStyle(color: primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            sizeVer(8.h),
                            const Divider(
                              color: secondaryColor,
                            ),
                            sizeVer(8.h),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: commentState.comments.length,
                                  itemBuilder: (context, index) {
                                    final singleComment =
                                        commentState.comments[index];
                                    return BlocProvider(
                                      create: (BuildContext context) =>
                                          di.sl<ReplyCubit>(),
                                      child: SingleCommentWidget(
                                        currentUser: singleUser,
                                        comment: singleComment,
                                        onLongPressListener: () =>
                                            OpenBottomModalSheet.show(
                                          options: BottomModalSheetModel(
                                            comment:
                                                commentState.comments[index],
                                            firstOption: 'Delete Comment',
                                            secondOption: 'Update Comment',
                                            context: context,
                                            onDeleteTap: () {
                                              Navigator.pop(context);
                                              _deleteComment(
                                                  commentId: commentState
                                                      .comments[index]
                                                      .commentId!,
                                                  postId: commentState
                                                      .comments[index].postId!);
                                            },
                                          ),
                                        ),
                                        onLikeClickListener: () {
                                          _likeComment(
                                              comment:
                                                  commentState.comments[index]);
                                        },
                                      ),
                                    );
                                  }),
                            ),
                            CommentSectionWidget(
                              currentUser: singleUser,
                              appEntity: widget.appEntity,
                              descriptionController: _descriptionController,
                            )
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _deleteComment({required String commentId, required String postId}) {
    BlocProvider.of<CommentCubit>(context).deleteComment(
        comment: CommentEntity(commentId: commentId, postId: postId));
  }

  _likeComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context).likeComment(
        comment: CommentEntity(
            commentId: comment.commentId, postId: comment.postId));
  }
}
