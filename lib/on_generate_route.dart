import 'package:flutter/material.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/app_entity.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/comments/comment_entity.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/posts/post_entity.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/reply/reply_entity.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/user/user_entity.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/credentials/sign_in_page.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/credentials/sign_up_page.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/main_screen/main_screen.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/post/comment/comment_page.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/post/comment/edit_comment_page.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/post/comment/edit_replay_page.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/post/post_detail_page.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/post/update_post_page.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/profile/edit_profile_page.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/profile/following_page.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/profile/single_user_profile_page.dart';
import 'core/constants/color.dart';
import 'features/presentation/ pages/profile/followers_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case PageConst.mainScreen:
        {
          if (args is String) {
            return routeBuilder(MainScreen(uid: args));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.editProfilePage:
        {
          if (args is UserEntity) {
            return routeBuilder(EditProfilePage(
              currentUser: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.updatePostPage:
        {
          if (args is PostEntity) {
            return routeBuilder(UpdatePostPage(
              post: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.commentPage:
        {
          if (args is AppEntity) {
            return routeBuilder(CommentPage(
              appEntity: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.updateCommentPage:
        {
          if (args is CommentEntity) {
            return routeBuilder(EditCommentPage(
              comment: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }

      case PageConst.updateReplayPage:
        {
          if (args is ReplyEntity) {
            return routeBuilder(EditReplyPage(reply: args));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.singleUserProfilePage:
        {
          if (args is String) {
            return routeBuilder(SingleUserProfilePage(otherUserId: args));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.followingPage:
        {
          if (args is UserEntity) {
            return routeBuilder(FollowingPage(user: args));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.followersPage:
        {
          if (args is UserEntity) {
            return routeBuilder(FollowersPage(user: args));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.postDetailPage:
        {
          if (args is String) {
            return routeBuilder(PostDetailPage(postId: args));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.signInPage:
        {
          return routeBuilder(const SignInPage());
        }
      case PageConst.signUpPage:
        {
          return routeBuilder(const SignUpPage());
        }
      default:
        {
          const NoPageFound();
        }
    }
    return null;
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("No Page Found"),
      ),
      body: const Center(
        child: Text("Page not found"),
      ),
    );
  }
}
