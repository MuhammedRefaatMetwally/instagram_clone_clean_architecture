
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/user/user_entity.dart';

class UserModel extends UserEntity{
  @override
  final String? uid;
  @override
  final String? username;
  @override
  final String? name;
  @override
  final String? bio;
  @override
  final String? website;
  @override
  final String? email;
  @override
  final String? profileUrl;
  @override
  final List? followers;
  @override
  final List? following;
  @override
  final num? totalFollowers;
  @override
  final num? totalFollowing;
  @override
  final num? totalPosts;

  const UserModel({
    this.uid,
    this.username,
    this.name,
    this.bio,
    this.website,
    this.email,
    this.profileUrl,
    this.followers,
    this.following,
    this.totalFollowers,
    this.totalFollowing,
    this.totalPosts,
  }):super(
    uid: uid,
    username: username,
    name: name,
    bio: bio,
    website: website,
    email: email,
    profileUrl: profileUrl,
    followers: followers,
    following: following,
    totalFollowers: totalFollowers,
    totalFollowing: totalFollowing,
    totalPosts: totalPosts,
  );

  factory UserModel.fromSnapshot(DocumentSnapshot snap){
    var snapshot= snap.data() as Map<String,dynamic>;
    return UserModel(
      email: snapshot["email"],
      name: snapshot["name"],
      username: snapshot["username"],
      bio: snapshot["bio"],
      website: snapshot["website"],
      profileUrl: snapshot["profileUrl"],
      uid: snapshot["uid"],
      followers: List.from(snap.get("followers")),
      following: List.from(snap.get("following")),
      totalFollowers: snapshot["totalFollowers"],
      totalFollowing: snapshot["totalFollowing"],
      totalPosts: snapshot["totalPosts"],
    );
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "email": email,
    "name": name,
    "username": username,
    "totalFollowers": totalFollowers,
    "totalFollowing": totalFollowing,
    "totalPosts": totalPosts,
    "website": website,
    "bio": bio,
    "profileUrl": profileUrl,
    "followers": followers,
    "following": following,
  };
}