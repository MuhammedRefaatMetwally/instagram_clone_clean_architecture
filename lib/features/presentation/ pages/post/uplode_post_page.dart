import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/user/user_entity.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/post/widgets/uplode_post_main_widget.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/posts/posts_cubit.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;

class UploadPostPage extends StatelessWidget {
  final UserEntity currentUser;

  const UploadPostPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostsCubit>(
      create: (context) => di.sl<PostsCubit>(),
      child: UploadPostMainWidget(currentUser: currentUser),
    );
  }
}
