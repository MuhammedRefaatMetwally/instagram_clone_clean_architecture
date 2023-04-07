 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/comments/comment_entity.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/user/user_entity.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/post/comment/widgets/single_replay_widget.dart';
import 'package:insta_clone_clean_arc/features/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;
import 'package:uuid/uuid.dart';
import '../../../../../../core/constants/color.dart';
import '../../../../../domain/entity/reply/reply_entity.dart';
import '../../../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../../cubit/reply/reply_cubit.dart';
import '../../../../widgets/form_container_widget.dart';

class SingleCommentWidget extends StatefulWidget {
final  CommentEntity comment;
final VoidCallback? onLongPressListener;
final VoidCallback? onLikeClickListener;
final UserEntity? currentUser;
   const SingleCommentWidget({Key? key, required this.comment, this.onLongPressListener, this.onLikeClickListener,  this. currentUser,}) : super(key: key);

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
   final TextEditingController _replayDescriptionController = TextEditingController();
  bool _isUserReplying=false;
  String _currentUid="";
  @override
  void initState() {
    di.sl<GetCurrentUidUserCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
      BlocProvider.of<ReplyCubit>(context).getReplies(reply: ReplyEntity(
        postId: widget.comment.postId,
        commentId: widget.comment.commentId,
      ));
    });
    super.initState();
  }

  @override
   Widget build(BuildContext context) {
     return InkWell(
       onLongPress: widget.comment.creatorUid==_currentUid?widget.onLongPressListener:null ,
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(
             width: 40.w,
             height: 40.h,
             margin:  EdgeInsets.symmetric(horizontal: 8.w),
             decoration: const BoxDecoration(
               shape: BoxShape.circle,
             ),
             child: profileWidget(imageUrl: widget.comment.userProfileUrl),
           ),
           sizeHor(8.h),
           Expanded(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children:  [
                       Text(
                         "${widget.comment.username}",
                         style:  TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 16.sp,
                             color: primaryColor),
                       ),
                       GestureDetector(
                         onTap: widget.onLikeClickListener,
                         child: Icon(
                           widget.comment.likes!.contains(_currentUid)? Icons.favorite:Icons.favorite_outline,
                           size: 20,
                           color: widget.comment.likes!.contains(_currentUid)? Colors.red : darkGreyColor,
                         ),
                       )
                     ],
                   ),
                   sizeVer(4.h),
                    Text(
                     "${widget.comment.description}",
                        style: const TextStyle(color: primaryColor),
                   ),
                   sizeVer(4.h),
                   Row(
                     children: [
                       Text(
                         DateFormat("dd/MMM/yyy").format(widget.comment.createAt!.toDate()),
                         style: const TextStyle(color: darkGreyColor),
                       ),
                       sizeHor(16.w),
                       GestureDetector(
                         onTap: (){
                           setState(() {
                             _isUserReplying= !_isUserReplying;
                           });
                         },
                         child:  Text(
                           "Replay",
                           style: TextStyle(color: darkGreyColor,fontSize: 12.sp),
                         ),
                       ),
                       sizeHor(16.w),
                        GestureDetector(
                          onTap: (){
                            widget.comment.totalReplays==0? toast("No Replies"):
                            BlocProvider.of<ReplyCubit>(context).getReplies(reply: ReplyEntity(
                              postId: widget.comment.postId,
                              commentId: widget.comment.commentId,
                            ));
                          },
                          child: Text(
                           "View Replays",
                           style: TextStyle(color: darkGreyColor,fontSize: 12.sp),
                       ),
                        ),
                     ],
                   ),
                   BlocBuilder<ReplyCubit, ReplyState>(
                     builder: (context, replyState) {
                       if (replyState is RepliesLoaded) {
                         final replies = replyState.replies.where((element) => element.commentId == widget.comment.commentId).toList(); //3shan mykrrsh el reply le kol el comments;
                         return ListView.builder(shrinkWrap: true, physics: const ScrollPhysics(), itemCount: replies.length, itemBuilder: (context, index) {
                           return SingleReplyWidget(reply: replies[index],
                             onLongPressListener: () {
                               _openBottomModalSheet(context: context, replay: replies[index]);
                             },
                             onLikeClickListener: () {
                               _likeReply(reply: replies[index]);
                             },
                           );

                         });

                       }
                       return const Center(child: CircularProgressIndicator(),);
                     },
                   ),
                   _isUserReplying==true?sizeVer(8.h):sizeVer(8.h),
                   _isUserReplying==true?Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                        FormContainerWidget(hintText: "Post your reply....", controller: _replayDescriptionController,),
                       sizeVer(8.h),
                        GestureDetector(onTap: (){
                          _createReplay();
                        },child: const Text("Post",style: TextStyle(color: blueColor),)),
                     ],
                   ):const SizedBox(),
                 ],
               ),
             ),
           ),
         ],
       ),
     );

   }
  _createReplay() {
    BlocProvider.of<ReplyCubit>(context)
        .createReply(
        reply: ReplyEntity(
          replyId: const Uuid().v1(),
          createAt: Timestamp.now(),
          likes: const [],
          username: widget.currentUser!.username,
          userProfileUrl: widget.currentUser!.profileUrl,
          creatorUid: widget.currentUser!.uid,
          postId: widget.comment.postId,
          commentId: widget.comment.commentId,
          description: _replayDescriptionController.text,
        ))
        .then((value) {
      setState(() {
        _replayDescriptionController.clear();
        _isUserReplying = false;
      });
    });
  }

   _openBottomModalSheet({required BuildContext context, required ReplyEntity replay}) {
     return showModalBottomSheet(
         context: context,
         builder: (context) {
           return Container(
             height: 150.h,
             decoration: BoxDecoration(color: backGroundColor.withOpacity(.8)),
             child: SingleChildScrollView(
               child: Container(
                 margin:  EdgeInsets.symmetric(vertical: 10.h),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      Padding(
                       padding: EdgeInsets.only(left: 8.0.w),
                       child:  Text(
                         "More Options",
                         style: TextStyle(
                             fontWeight: FontWeight.bold, fontSize: 18.sp, color: primaryColor),
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
                       height: 8.h,
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: GestureDetector(
                         onTap: () {
                           _deleteReply(reply: replay);
                         },
                         child:  Text(
                           "Delete Replay",
                           style: TextStyle(
                               fontWeight: FontWeight.w500, fontSize: 16.sp, color: primaryColor),
                         ),
                       ),
                     ),
                     sizeVer(8.h),
                     const Divider(
                       thickness: 1,
                       color: secondaryColor,
                     ),
                     sizeVer(8.h),
                     Padding(
                       padding:  EdgeInsets.only(left: 8.0.w),
                       child: GestureDetector(
                         onTap: () {
                           Navigator.pushNamed(context, PageConst.updateReplayPage, arguments: replay);
                         },
                         child:Text(
                           "Update Replay",
                           style: TextStyle(
                               fontWeight: FontWeight.w500, fontSize: 16.sp, color: primaryColor),
                         ),
                       ),
                     ),
                     sizeVer(8.h),
                   ],
                 ),
               ),
             ),
           );
         });
   }

  _likeReply({required ReplyEntity reply}) {
    BlocProvider.of<ReplyCubit>(context).likeReply(reply: ReplyEntity(
        postId: reply.postId,
        commentId: reply.commentId,
        replyId: reply.replyId
    ));
  }

   _deleteReply({required ReplyEntity reply}) {
    BlocProvider.of<ReplyCubit>(context).deleteReply(reply: ReplyEntity(
        postId: reply.postId,
        commentId: reply.commentId,
        replyId: reply.replyId
    ));
  }
}
