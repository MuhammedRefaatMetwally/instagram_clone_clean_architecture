import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/profile/widgets/profile_main_widget.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;
import '../../../domain/entity/user/user_entity.dart';
import '../../cubit/posts/posts_cubit.dart';
class ProfilePage extends StatelessWidget {
  final UserEntity currentUser;

  const ProfilePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PostsCubit>(),
      child: ProfileMainWidget(currentUser: currentUser,),
    );
  }
}
