import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/posts/post_entity.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/post/widgets/update_post_main_widget.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/posts/posts_cubit.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;
class UpdatePostPage extends StatelessWidget {
  final PostEntity post;

  const UpdatePostPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostsCubit>(
      create: (context) => di.sl<PostsCubit>(),
      child: UpdatePostMainWidget(post: post,),
    );
  }
}
