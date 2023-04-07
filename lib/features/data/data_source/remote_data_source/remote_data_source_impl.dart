import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta_clone_clean_arc/features/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:insta_clone_clean_arc/features/data/models/user/user_model.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/comments/comment_entity.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/posts/post_entity.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/reply/reply_entity.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/user/user_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/color.dart';
import '../../models/comment/commnet_model.dart';
import '../../models/posts/post_model.dart';
import '../../models/reply/reply_model.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  FirebaseRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.firebaseStorage,
  });

  @override
  Future<void> createUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    final uid = await getCurrentUid();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        name: user.name,
        email: user.email,
        bio: user.bio,
        following: user.following,
        website: user.website,
        profileUrl: user.profileUrl,
        username: user.username,
        totalFollowers: user.totalFollowers,
        followers: user.followers,
        totalFollowing: user.totalFollowers,
        totalPosts: user.totalPosts,
      ).toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast("Some error occur");
    });
  }

  @override
  Future<void> createUserWithImage(UserEntity user, String profileUrl) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    final uid = await getCurrentUid();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        name: user.name,
        email: user.email,
        bio: user.bio,
        following: user.following,
        website: user.website,
        profileUrl: profileUrl,
        //
        username: user.username,
        totalFollowers: user.totalFollowers,
        followers: user.followers,
        totalFollowing: user.totalFollowers,
        totalPosts: user.totalPosts,
      ).toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast("Some error occur");
    });
  }

  @override
  Future<void> followUnFollowUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    final myDocRef = await userCollection.doc(user.uid).get();
    final otherUserDocRef = await userCollection.doc(user.otherUid).get();

    if (myDocRef.exists && otherUserDocRef.exists) {
      List myFollowingList = myDocRef.get("following");
      List otherUserFollowersList = otherUserDocRef.get("followers");

      // My Following List
      if (myFollowingList.contains(user.otherUid)) {
        userCollection.doc(user.uid).update({
          "following": FieldValue.arrayRemove([user.otherUid])
        }).then((value) {
          final userCollection =
              firebaseFirestore.collection(FirebaseConst.users).doc(user.uid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowing = value.get('totalFollowing');
              userCollection.update({"totalFollowing": totalFollowing - 1});
              return;
            }
          });
        });
      } else {
        userCollection.doc(user.uid).update({
          "following": FieldValue.arrayUnion([user.otherUid])
        }).then((value) {
          final userCollection =
              firebaseFirestore.collection(FirebaseConst.users).doc(user.uid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowing = value.get('totalFollowing');
              userCollection.update({"totalFollowing": totalFollowing + 1});
              return;
            }
          });
        });
      }

      // Other User Following List
      if (otherUserFollowersList.contains(user.uid)) {
        userCollection.doc(user.otherUid).update({
          "followers": FieldValue.arrayRemove([user.uid])
        }).then((value) {
          final userCollection = firebaseFirestore
              .collection(FirebaseConst.users)
              .doc(user.otherUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowers = value.get('totalFollowers');
              userCollection.update({"totalFollowers": totalFollowers - 1});
              return;
            }
          });
        });
      } else {
        userCollection.doc(user.otherUid).update({
          "followers": FieldValue.arrayUnion([user.uid])
        }).then((value) {
          final userCollection = firebaseFirestore
              .collection(FirebaseConst.users)
              .doc(user.otherUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowers = value.get('totalFollowers');
              userCollection.update({"totalFollowers": totalFollowers + 1});
              return;
            }
          });
        });
      }
    }
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where("uid", isEqualTo: otherUid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }


  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where("uid", isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
      } else {
        print("fields can't be empty");
      }
    } on FirebaseException catch (e) {
      if (e.code == "user-not-found") {
        toast("user not found ");
      } else if (e.code == "wrong-password") {
        toast("Invalid email or password");
      }
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!)
          .then((value) async {
        if (value.user?.uid != null) {
          if (user.imageFile != null) {
            uploadImageToStorage(user.imageFile, false, "profileImages")
                .then((profileUrl) => {createUserWithImage(user, profileUrl)});
          } else {
            await createUserWithImage(user, "");
          }
        }
      });
      return;
    } on FirebaseException catch (e) {
      if (e.code == "email-already-in-use") {
        toast("email is already taken");
      } else {
        toast("something went wrong");
      }
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    Map<String, dynamic> userInformation = {};

    if (user.username != "" && user.username != null) {
      userInformation['username'] = user.username;
    }

    if (user.website != "" && user.website != null) {
      userInformation['website'] = user.website;
    }

    if (user.profileUrl != "" && user.profileUrl != null) {
      userInformation['profileUrl'] = user.profileUrl;
    }

    if (user.bio != "" && user.bio != null) userInformation['bio'] = user.bio;

    if (user.name != "" && user.name != null) {
      userInformation['name'] = user.name;
    }

    if (user.totalFollowing != null) {
      userInformation['totalFollowing'] = user.totalFollowing;
    }

    if (user.totalFollowers != null) {
      userInformation['totalFollowers'] = user.totalFollowers;
    }

    if (user.totalPosts != null) {
      userInformation['totalPosts'] = user.totalPosts;
    }

    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<String> uploadImageToStorage(File? file, bool isPost, String childName) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    final uploadTask = ref.putFile(file!);

    final imageUrl =
        (await uploadTask.whenComplete(() => {})).ref.getDownloadURL();

    return await imageUrl;
  }

  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    final newPost = PostModel(
            userProfileUrl: post.userProfileUrl,
            username: post.username,
            totalLikes: 0,
            totalComments: 0,
            postImageUrl: post.postImageUrl,
            postId: post.postId,
            likes: const [],
            description: post.description,
            creatorUid: post.creatorUid,
            createAt: post.createAt)
        .toJson();

    try {
      final postDocRef = await postCollection.doc(post.postId).get();

      if (!postDocRef.exists) {
        postCollection.doc(post.postId).set(newPost).then((value) {
          final userCollection = firebaseFirestore
              .collection(FirebaseConst.users)
              .doc(post.creatorUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalPosts = value.get('totalPosts');
              userCollection.update({"totalPosts": totalPosts + 1});
              return;
            }
          });
        });
      } else {
        postCollection.doc(post.postId).update(newPost);
      }
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    try {
      postCollection.doc(post.postId).delete().then((value) {
        final userCollection = firebaseFirestore
            .collection(FirebaseConst.users)
            .doc(post.creatorUid);

        userCollection.get().then((value) {
          if (value.exists) {
            final totalPosts = value.get('totalPosts');
            userCollection.update({"totalPosts": totalPosts - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some error occurred $e");
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    final currentUid = await getCurrentUid();
    final postRef = await postCollection.doc(post.postId).get();

    if (postRef.exists) {
      List likes = postRef.get("likes");
      final totalLikes = postRef.get("totalLikes");
      if (likes.contains(currentUid)) {
        // you have not  like the post
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1
        });
      } else {
        // you have liked the post
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .orderBy("createAt", descending: true);

    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapShot(e)).toList());
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .orderBy("createAt",
            descending:
                true) // descending  the post that has been created first will be shown first in the column
        .where("postId", isEqualTo: postId);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapShot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
    Map<String, dynamic> postInfo = {};

    if (post.description != "" && post.description != null) postInfo['description'] = post.description;
    if (post.postImageUrl != "" && post.postImageUrl != null) postInfo['postImageUrl'] = post.postImageUrl;

    postCollection.doc(post.postId).update(postInfo);
  }


    @override
  Future<void> createComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);

    final newComment = CommentModel(
            userProfileUrl: comment.userProfileUrl,
            username: comment.username,
            totalReplays: comment.totalReplays,
            commentId: comment.commentId,
            postId: comment.postId,
            likes: const [],
            description: comment.description,
            creatorUid: comment.creatorUid,
            createAt: comment.createAt)
        .toJson();

    try {
      final commentDocRef =
          await commentCollection.doc(comment.commentId).get();

      if (!commentDocRef.exists) {
        commentCollection.doc(comment.commentId).set(newComment).then((value) {
          final postCollection = firebaseFirestore
              .collection(FirebaseConst.posts)
              .doc(comment.postId);

          postCollection.get().then((value) {
            if (value.exists) {
              final totalComments = value.get('totalComments');
              postCollection.update({"totalComments": totalComments + 1});
              return;
            }
          });
        });
      } else {
        commentCollection.doc(comment.commentId).update(newComment);
      }
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);

    try {
      commentCollection.doc(comment.commentId).delete().then((value) {
        final postCollection = firebaseFirestore
            .collection(FirebaseConst.posts)
            .doc(comment.postId);

        postCollection.get().then((value) {
          if (value.exists) {
            final totalComments = value.get('totalComments');
            postCollection.update({"totalComments": totalComments - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);
    final currentUid = await getCurrentUid();

    final commentRef = await commentCollection.doc(comment.commentId).get();

    if (commentRef.exists) {
      List likes = commentRef.get("likes");
      if (likes.contains(currentUid)) {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(postId)
        .collection(FirebaseConst.comment)
        .orderBy("createAt", descending: true);
    return commentCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => CommentModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);

    Map<String, dynamic> commentInfo = {};

    if (comment.description != "" && comment.description != null) {
      commentInfo["description"] = comment.description;
    }

    commentCollection.doc(comment.commentId).update(commentInfo);
  }

  @override
  Future<void> createReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comment)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);

    final newReplay = ReplyModel(
            userProfileUrl: reply.userProfileUrl,
            username: reply.username,
            replyId: reply.replyId,
            commentId: reply.commentId,
            postId: reply.postId,
            likes: const [],
            description: reply.description,
            creatorUid: reply.creatorUid,
            createAt: reply.createAt)
        .toJson();

    try {
      final replyDocRef = await replyCollection.doc(reply.replyId).get();

      if (!replyDocRef.exists) {
        replyCollection.doc(reply.replyId).set(newReplay).then((value) {
          final commentCollection = firebaseFirestore
              .collection(FirebaseConst.posts)
              .doc(reply.postId)
              .collection(FirebaseConst.comment)
              .doc(reply.commentId);

          commentCollection.get().then((value) {
            if (value.exists) {
              final totalReplays = value.get('totalReplays');
              commentCollection.update({"totalReplays": totalReplays + 1});
              return;
            }
          });
        });
      } else {
        replyCollection.doc(reply.replyId).update(newReplay);
      }
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deleteReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comment)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);

    try {
      replyCollection.doc(reply.replyId).delete().then((value) {
        final commentCollection = firebaseFirestore
            .collection(FirebaseConst.posts)
            .doc(reply.postId)
            .collection(FirebaseConst.comment)
            .doc(reply.commentId);

        commentCollection.get().then((value) {
          if (value.exists) {
            final totalReplays = value.get('totalReplays');
            commentCollection.update({"totalReplays": totalReplays - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> likeReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comment)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);

    final currentUid = await getCurrentUid();

    final replayRef = await replyCollection.doc(reply.replyId).get();

    if (replayRef.exists) {
      List likes = replayRef.get("likes");
      if (likes.contains(currentUid)) {
        replyCollection.doc(reply.replyId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        replyCollection.doc(reply.replyId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<ReplyEntity>> readReplies(ReplyEntity reply) {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comment)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);
    return replyCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ReplyModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comment)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);

    Map<String, dynamic> replyInfo = {};

    if (reply.description != "" && reply.description != null) {
      replyInfo['description'] = reply.description;
    }

    replyCollection.doc(reply.replyId).update(replyInfo);
  }
}
