import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/post/widgets/post_detail_main_widget.dart';

import 'package:insta_clone_clean_arc/injection_container.dart' as di;

import '../../cubit/posts/get_single_post/get_single_post_cubit.dart';
import '../../cubit/posts/posts_cubit.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;

  const PostDetailPage({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetSinglePostCubit>(
          create: (context) => di.sl<GetSinglePostCubit>(),
        ),
        BlocProvider<PostsCubit>(
          create: (context) => di.sl<PostsCubit>(),
        ),
      ],
      child: PostDetailMainWidget(postId: postId),
    );
  }
}
