

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/posts/post_entity.dart';

class PostModel extends PostEntity{


  @override
  final String? postId;
  @override
  final String? creatorUid;
  @override
  final String? username;
  @override
  final String? description;
  @override
  final String? postImageUrl;
  @override
  final List<String>? likes;
  @override
  final num? totalLikes;
  @override
  final num? totalComments;
  @override
  final Timestamp? createAt;
  @override
  final String? userProfileUrl;

  const PostModel(
      {this.postId,
      this.creatorUid,
      this.username,
      this.description,
      this.postImageUrl,
      this.likes,
      this.totalLikes,
      this.totalComments,
      this.createAt,
      this.userProfileUrl})
      :super(
    createAt: createAt,
    creatorUid: creatorUid,
    description: description,
    likes: likes,
    postId: postId,
    postImageUrl: postImageUrl,
    totalComments: totalComments,
    totalLikes: totalLikes,
    username: username,
    userProfileUrl: userProfileUrl,
  );

  factory PostModel.fromSnapShot(DocumentSnapshot snap){
    var snapshot= snap.data() as Map<String,dynamic>;
    return PostModel(
      createAt: snapshot['createAt'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      userProfileUrl: snapshot['userProfileUrl'],
      totalLikes: snapshot['totalLikes'],
      totalComments: snapshot['totalComments'],
      postImageUrl: snapshot['postImageUrl'],
      postId: snapshot['postId'],
      username: snapshot['username'],
      likes: List.from(snap.get("likes")),
    );
  }

  Map<String,dynamic> toJson() =>{
    "createAt": createAt,
    "creatorUid": creatorUid,
    "description": description,
    "userProfileUrl": userProfileUrl,
    "totalLikes": totalLikes,
    "totalComments": totalComments,
    "postImageUrl": postImageUrl,
    "postId": postId,
    "likes": likes,
    "username": username,
  };

}