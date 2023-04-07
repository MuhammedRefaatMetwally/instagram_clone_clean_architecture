
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entity/comments/comment_entity.dart';


class CommentModel extends CommentEntity {
  @override
  final String? commentId;
  @override
  final String? postId;
  @override
  final String? creatorUid;
  @override
  final String? description;
  @override
  final String? username;
  @override
  final String? userProfileUrl;
  @override
  final Timestamp? createAt;
  @override
  final List<String>? likes;
  @override
  final num? totalReplays;

  const CommentModel({
    this.commentId,
    this.postId,
    this.creatorUid,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalReplays,
  }) : super(
      postId: postId,
      creatorUid: creatorUid,
      description: description,
      userProfileUrl: userProfileUrl,
      username: username,
      likes: likes,
      createAt: createAt,
      commentId: commentId,
      totalReplays: totalReplays
  );

  factory CommentModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CommentModel(
      postId: snapshot['postId'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      userProfileUrl: snapshot['userProfileUrl'],
      commentId: snapshot['commentId'],
      createAt: snapshot['createAt'],
      totalReplays: snapshot['totalReplays'],
      username: snapshot['username'],
      likes: List.from(snap.get("likes")),
    );
  }

  Map<String, dynamic> toJson() => {
    "creatorUid": creatorUid,
    "description": description,
    "userProfileUrl": userProfileUrl,
    "commentId": commentId,
    "createAt": createAt,
    "totalReplays": totalReplays,
    "postId": postId,
    "likes": likes,
    "username": username,
  };


}