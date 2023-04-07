

import 'package:insta_clone_clean_arc/features/domain/entity/posts/post_entity.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/user/user_entity.dart';

class AppEntity{

  final UserEntity? currentUser;
  final PostEntity? postEntity;

  final String? uid;
  final String? postId;

  AppEntity({this.currentUser, this.postEntity, this.uid, this.postId});
}