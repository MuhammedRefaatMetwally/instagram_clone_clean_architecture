import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone_clean_arc/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;
import '../../../../../core/constants/color.dart';
import '../../../../domain/entity/posts/post_entity.dart';
import '../../../../domain/entity/user/user_entity.dart';
import '../../../cubit/posts/posts_cubit.dart';
import '../../../cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import '../../../cubit/user/user_cubit.dart';
import '../../../widgets/button_container_widget.dart';
import '../../../widgets/profile_widget.dart';

class SingleUserProfileMainWidget extends StatefulWidget {
  final String otherUserId;
  const SingleUserProfileMainWidget({Key? key, required this.otherUserId}) : super(key: key);

  @override
  State<SingleUserProfileMainWidget> createState() => _SingleUserProfileMainWidgetState();
}

class _SingleUserProfileMainWidgetState extends State<SingleUserProfileMainWidget> {
  String _currentUid = "";

  @override
  void initState() {
    BlocProvider.of<GetSingleOtherUserCubit>(context).getSingleOtherUser(
      otherUid: widget.otherUserId,);
    BlocProvider.of<PostsCubit>(context).getPosts(post: const PostEntity());
    super.initState();

    di.sl<GetCurrentUidUserCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleOtherUserCubit, GetSingleOtherUserState>(
      builder: (context, userState) {
        if (userState is GetSingleOtherUserLoaded) {
          final singleUser = userState.otherUser;
          return Scaffold(
              backgroundColor: backGroundColor,
              appBar: AppBar(
                backgroundColor: backGroundColor,
                title: Text("${singleUser.username}",
                  style: const TextStyle(color: primaryColor),),
                actions: [
                  _currentUid == singleUser.uid ? Padding(
                    padding:  EdgeInsets.only(right: 8.0.w),
                    child: InkWell(
                        onTap: () {
                          /*OpenBottomModalSheet.show(BottomModalSheetModel(
                            firstOption: "Delete Post",
                            secondOption: "Update Post",
                            context: context,), currentUser: singleUser, post: PostEntity(),);*/
                        }, child: const Icon(Icons.menu, color: primaryColor,)),
                  ) : Container()
                ],
              ),
              body: Padding(
                padding:  EdgeInsets.symmetric(
                    horizontal: 8.0.w, vertical: 8.0.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 80.w,
                            height: 80.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.r),
                              child: profileWidget(
                                  imageUrl: singleUser.profileUrl),
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text("${singleUser.totalPosts}",
                                    style: const TextStyle(color: primaryColor,
                                        fontWeight: FontWeight.bold),),
                                  sizeVer(8.h),
                                  const Text("Posts",
                                    style: TextStyle(color: primaryColor),)
                                ],
                              ),
                              sizeHor(24.w),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, PageConst.followersPage,
                                      arguments: singleUser);
                                },
                                child: Column(
                                  children: [
                                    Text("${singleUser.totalFollowers}",
                                      style: const TextStyle(color: primaryColor,
                                          fontWeight: FontWeight.bold),),
                                    sizeVer(8.h),
                                    const Text("Followers",
                                      style: TextStyle(color: primaryColor),)
                                  ],
                                ),
                              ),
                              sizeHor(24.w),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, PageConst.followingPage,
                                      arguments: singleUser);
                                },
                                child: Column(
                                  children: [
                                    Text("${singleUser.totalFollowing}",
                                      style: const TextStyle(color: primaryColor,
                                          fontWeight: FontWeight.bold),),
                                    sizeVer(8.h),
                                    const Text("Following",
                                      style: TextStyle(color: primaryColor),)
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      sizeVer(8.h),
                      Text("${singleUser.name == ""
                          ? singleUser.username
                          : singleUser.name}", style: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),),
                      sizeVer(8.h),
                      Text("${singleUser.bio}",
                        style: const TextStyle(color: primaryColor),),
                      sizeVer(8.h),
                      _currentUid == singleUser.uid
                          ? Container()
                          : ButtonContainerWidget(
                        text: singleUser.followers!.contains(_currentUid)
                            ? "UnFollow"
                            : "Follow",
                        color: singleUser.followers!.contains(_currentUid)
                            ? secondaryColor.withOpacity(.4)
                            : blueColor,
                        onTapListener: () {
                          BlocProvider.of<UserCubit>(context)
                              .followUnFollowUser(
                              user: UserEntity(
                                  uid: _currentUid,
                                  otherUid: widget.otherUserId
                              )
                          );
                        },
                      ),
                      sizeVer(8.h),
                      BlocBuilder<PostsCubit, PostsState>(
                        builder: (context, postState) {
                          if (postState is PostsLoaded) {
                            final posts = postState.posts.where((post) =>
                            post.creatorUid == widget.otherUserId).toList();
                            return GridView.builder(
                                itemCount: posts.length,
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, PageConst.postDetailPage,
                                          arguments: posts[index].postId);
                                    },
                                    child: SizedBox(
                                      width: 96.w,
                                      height: 96.h,
                                      child: profileWidget(
                                          imageUrl: posts[index].postImageUrl),
                                    ),
                                  );
                                });
                          }
                          return const Center(child: CircularProgressIndicator(),);
                        },
                      )
                    ],
                  ),
                ),
              )
          );
        }
        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }
}