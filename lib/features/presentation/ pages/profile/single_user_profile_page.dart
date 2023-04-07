import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/profile/widgets/single_user_profile_main_widget.dart';

import 'package:insta_clone_clean_arc/injection_container.dart' as di;

import '../../cubit/posts/posts_cubit.dart';

class SingleUserProfilePage extends StatelessWidget {
  final String otherUserId;

  const SingleUserProfilePage({Key? key, required this.otherUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostsCubit>(
          create: (context) => di.sl<PostsCubit>(),
        ),
      ],
      child: SingleUserProfileMainWidget(otherUserId: otherUserId),
    );
  }
}
