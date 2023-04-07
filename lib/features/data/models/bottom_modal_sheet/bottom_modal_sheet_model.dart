import 'package:flutter/cupertino.dart';

import '../../../domain/entity/comments/comment_entity.dart';
import '../../../domain/entity/posts/post_entity.dart';
import '../../../domain/entity/reply/reply_entity.dart';
import '../../../domain/entity/user/user_entity.dart';

class BottomModalSheetModel {
  BuildContext context;
  String firstOption;
  String secondOption;
  PostEntity? post;
  UserEntity? currentUser;
  CommentEntity? comment;
  ReplyEntity? reply;
  void Function()? onDeleteTap;

  BottomModalSheetModel(
      {required this.firstOption,
      required this.secondOption,
      required this.context,
      this.onDeleteTap,
      this.post,
      this.currentUser,
      this.comment,this.reply});
}
