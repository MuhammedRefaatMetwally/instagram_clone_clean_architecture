import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/color.dart';
import '../../../../../core/constants/constans.dart';
import '../../../../../core/constants/page_constants.dart';
import '../../../../domain/entity/user/user_entity.dart';
import '../../../cubit/posts/posts_cubit.dart';
import '../../../widgets/profile_widget.dart';

class ProfileMainBodyWidget extends StatelessWidget {
  const ProfileMainBodyWidget({Key? key, required this.currentUser}) : super(key: key);
  final UserEntity currentUser;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
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
                    child: profileWidget(imageUrl: currentUser.profileUrl),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "${currentUser.totalPosts}",
                          style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                        ),
                        sizeVer(8.h),
                        const Text(
                          "Posts",
                          style: TextStyle(color: AppColors.primaryColor),
                        )
                      ],
                    ),
                    sizeHor(24.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.followersPage, arguments: currentUser);
                      },
                      child: Column(
                        children: [
                          Text(
                            "${currentUser.totalFollowers}",
                            style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                          ),
                          sizeVer(8.h),
                          const Text(
                            "Followers",
                            style: TextStyle(color: AppColors.primaryColor),
                          )
                        ],
                      ),
                    ),
                    sizeHor(24.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.followingPage, arguments: currentUser);
                      },
                      child: Column(
                        children: [
                          Text(
                            "${currentUser.totalFollowing}",
                            style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                          ),
                          sizeVer(8.h),
                          const Text(
                            "Following",
                            style: TextStyle(color: AppColors.primaryColor),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            sizeVer(8.h),
            Text(
              "${currentUser.name == "" ?currentUser.username : currentUser.name}",
              style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
            ),
            sizeVer(8.h),
            Text(
              "${currentUser.bio}",
              style: const TextStyle(color: AppColors.primaryColor),
            ),
            sizeVer(8.h),
            BlocBuilder<PostsCubit, PostsState>(
              builder: (context, postState) {
                if (postState is PostsLoaded) {
                  final posts = postState.posts.where((post) => post.creatorUid == currentUser.uid).toList();
                  return GridView.builder(
                      itemCount: posts.length,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, PageConst.postDetailPage, arguments: posts[index].postId);
                          },
                          child: SizedBox(
                            width: 96.w,
                            height: 96.h,
                            child: profileWidget(imageUrl: posts[index].postImageUrl),
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
    );
  }
}
