import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/search/widget/search_widget.dart';
import '../../../../../core/constants/color.dart';
import '../../../../../core/constants/constans.dart';
import '../../../../../core/constants/page_constants.dart';
import '../../../../domain/entity/posts/post_entity.dart';
import '../../../../domain/entity/user/user_entity.dart';
import '../../../cubit/posts/posts_cubit.dart';
import '../../../cubit/user/user_cubit.dart';
import '../../../widgets/profile_widget.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({Key? key}) : super(key: key);

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getUsers(user: const UserEntity());
    BlocProvider.of<PostsCubit>(context).getPosts(post: const PostEntity());
    super.initState();

    _searchController.addListener(() {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backGroundColor,
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            if (userState is UserLoaded) {
              final filterAllUsers = userState.users.where((user) =>
                  user.username!.startsWith(_searchController.text) ||
                  user.username!.toLowerCase().startsWith(_searchController.text.toLowerCase()) ||
                  user.username!.contains(_searchController.text) ||
                  user.username!.toLowerCase().contains(_searchController.text.toLowerCase())
              ).toList();
              return Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchWidget(
                      controller: _searchController,
                    ),
                    sizeVer(8.h),
                    _searchController.text.isNotEmpty ? Expanded(
                      child: ListView.builder(itemCount: filterAllUsers.length,itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, PageConst.singleUserProfilePage, arguments: filterAllUsers[index].uid);

                          },
                          child: Row(
                            children: [
                              Container(
                                margin:EdgeInsets.symmetric(vertical: 8.h),
                                width: 40.w,
                                height: 40.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.r),
                                  child: profileWidget(imageUrl: filterAllUsers[index].profileUrl),
                                ),
                              ),
                              sizeHor(8.w),
                              Text("${filterAllUsers[index].username}", style:  TextStyle(color: AppColors.primaryColor, fontSize: 16.sp, fontWeight: FontWeight.w600),)
                            ],
                          ),
                        );
                      }),
                    ) :BlocBuilder<PostsCubit, PostsState>(
                      builder: (context, postState) {
                        if (postState is PostsLoaded) {
                          final posts = postState.posts;
                          return Expanded(
                            child: GridView.builder(
                                itemCount: posts.length,
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, PageConst.postDetailPage,
                                          arguments: posts[index].postId);
                                    },
                                    child: SizedBox(
                                      width: 96.w,
                                      height: 96.h,
                                      child: profileWidget(
                                          imageUrl: posts[index].postImageUrl
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }
                        return const Center(child: CircularProgressIndicator(),);
                      },
                    )
                  ],
                ),
              );

            }
            return const Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}
