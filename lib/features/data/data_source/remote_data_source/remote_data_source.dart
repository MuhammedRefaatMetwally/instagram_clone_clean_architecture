import 'dart:io';

import '../../../domain/entity/comments/comment_entity.dart';
import '../../../domain/entity/posts/post_entity.dart';
import '../../../domain/entity/reply/reply_entity.dart';
import '../../../domain/entity/user/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  // Credential Features
  Future<void> signInUser(UserEntity user);

  Future<void> signUpUser(UserEntity user);

  Future<bool> isSignIn();

  Future<void> signOut();

  // User Features
  Stream<List<UserEntity>> getUsers(UserEntity user);

  Stream<List<UserEntity>> getSingleUser(String uid);

  Stream<List<UserEntity>> getSingleOtherUser(String otherUid);

  Future<String> getCurrentUid();

  Future<void> createUser(UserEntity user);

  Future<void> updateUser(UserEntity user);

  Future<void> followUnFollowUser(UserEntity user);

// cloud storage
  Future<String> uploadImageToStorage(File? file, bool isPost, String childName);

  Future<void> createUserWithImage(UserEntity user,String profileUrl);


  // Post Features
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPosts(PostEntity post);
  Stream<List<PostEntity>> readSinglePost(String postId);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);

  // Comment Features
  Future<void> createComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComments(String postId);
  Future<void> updateComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);

  //Replay Features
  Future<void> createReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> readReplies(ReplyEntity reply);
  Future<void> updateReply(  ReplyEntity reply);
  Future<void> deleteReply(ReplyEntity reply);
  Future<void> likeReply(ReplyEntity reply);

}
