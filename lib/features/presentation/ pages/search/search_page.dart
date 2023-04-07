import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/search/widget/search_main_widget.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;

import '../../cubit/posts/posts_cubit.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostsCubit>(
          create: (context) => di.sl<PostsCubit>(),
        ),
      ],
      child: const SearchMainWidget(),
    );
  }
}
