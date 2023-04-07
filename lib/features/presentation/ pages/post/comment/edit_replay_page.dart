import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/reply/reply_entity.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/post/comment/widgets/edit_reply_main_widget.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/reply/reply_cubit.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;

class EditReplyPage extends StatelessWidget {
  final ReplyEntity reply;

  const EditReplyPage({Key? key, required this.reply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReplyCubit>(
      create: (context) => di.sl<ReplyCubit>(),
      child: EditReplyMainWidget(reply: reply,),
    );
  }
}