
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/color.dart';
import '../../../../../domain/entity/comments/comment_entity.dart';
import '../../../../cubit/comment/comment_cubit.dart';
import '../../../../widgets/button_container_widget.dart';
import '../../../profile/widgets/profile_form_widgets.dart';


class EditCommentMainWidget extends StatefulWidget {
  final CommentEntity comment;
  const EditCommentMainWidget({Key? key, required this.comment}) : super(key: key);

  @override
  State<EditCommentMainWidget> createState() => _EditCommentMainWidgetState();
}

class _EditCommentMainWidgetState extends State<EditCommentMainWidget> {

  TextEditingController? _descriptionController;

  bool _isCommentUpdating = false;

  @override
  void initState() {
    _descriptionController = TextEditingController(text: widget.comment.description);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Edit Comment"),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
        child: Column(
          children: [
            ProfileFormWidget(
              title: "description",
              controller: _descriptionController,
            ),
            sizeVer(8.h),
            ButtonContainerWidget(
              color: blueColor,
              text: "Save Changes",
              onTapListener: () {
                _editComment();
                Navigator.pop(context);
              },
            ),
            sizeVer(8.h),
            _isCommentUpdating == true?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Updating...", style: TextStyle(color: Colors.white),),
                sizeHor(8.h),
                const CircularProgressIndicator(),
              ],
            ) : const SizedBox()
          ],
        ),
      ),
    );
  }

  _editComment() {
    setState(() {
      _isCommentUpdating = true;
    });
    BlocProvider.of<CommentCubit>(context).updateComment(comment: CommentEntity(
        postId: widget.comment.postId,
        commentId: widget.comment.commentId,
        description: _descriptionController!.text
    )).then((value) {
      setState(() {
        _isCommentUpdating = false;
        _descriptionController!.clear();
      });
      Navigator.pop(context);
    });
  }
}