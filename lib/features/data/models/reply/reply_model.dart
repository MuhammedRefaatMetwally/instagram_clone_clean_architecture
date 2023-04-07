import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entity/reply/reply_entity.dart';

class ReplyModel extends ReplyEntity {

  @override
  final String? creatorUid;
  @override
  final String? replyId;
  @override
  final String? commentId;
  @override
  final String? postId;
  @override
  final String? description;
  @override
  final String? username;
  @override
  final String? userProfileUrl;
  @override
  final List<String>? likes;
  @override
  final Timestamp? createAt;

  const ReplyModel({
    this.creatorUid,
    this.replyId,
    this.commentId,
    this.postId,
    this.description,
    this.username,
    this.userProfileUrl,
    this.likes,
    this.createAt,
  }) : super(
      description: description,
      commentId: commentId,
      postId: postId,
      creatorUid: creatorUid,
      userProfileUrl: userProfileUrl,
      username: username,
      likes: likes,
      createAt: createAt,
      replyId: replyId
  );

  factory ReplyModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ReplyModel(
      postId: snapshot['postId'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      userProfileUrl: snapshot['userProfileUrl'],
      commentId: snapshot['commentId'],
      replyId: snapshot['replyId'],
      createAt: snapshot['createAt'],
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
    "replyId": replyId,
    "postId": postId,
    "likes": likes,
    "username": username,
  };
}