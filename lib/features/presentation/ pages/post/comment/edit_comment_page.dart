import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/post/comment/widgets/edit_comment_main_widget.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;
import '../../../../domain/entity/comments/comment_entity.dart';
import '../../../cubit/comment/comment_cubit.dart';

class EditCommentPage extends StatelessWidget {
  final CommentEntity comment;

  const EditCommentPage({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentCubit>(
      create: (context) => di.sl<CommentCubit>(),
      child: EditCommentMainWidget(comment: comment),
    );
  }
}