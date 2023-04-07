import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/home/widgets/no_post_widget.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/home/widgets/single_post_card_widget.dart';
import '../../../../core/constants/color.dart';
import '../../../domain/entity/posts/post_entity.dart';
import '../../cubit/posts/posts_cubit.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: SvgPicture.asset("assets/ic_instagram.svg", color: primaryColor, height: 32,),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(MaterialCommunityIcons.facebook_messenger, color: primaryColor,),
          )
        ],
      ),
      body: BlocProvider<PostsCubit>(
        create: (context) =>
        di.sl<PostsCubit>()
          ..getPosts(post: const PostEntity()),
        child: BlocBuilder<PostsCubit, PostsState>(
          builder: (context, postState) {
            if (postState is PostsLoading) {
              return const Center(child: CircularProgressIndicator(),);
            }
            if (postState is PostsFailure) {
              toast("Some Failure occurred while creating the post");
            }
            if (postState is PostsLoaded) {
              return postState.posts.isEmpty? const NoPostWidget() : ListView.builder(
                itemCount: postState.posts.length,
                itemBuilder: (context, index) {
                  final post = postState.posts[index];
                  return BlocProvider(
                    create: (context) => di.sl<PostsCubit>(),
                    child: SinglePostCardWidget(post: post),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }


}