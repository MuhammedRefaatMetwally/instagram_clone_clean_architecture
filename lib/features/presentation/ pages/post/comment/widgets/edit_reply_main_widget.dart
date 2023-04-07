import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/reply/reply_entity.dart';
import '../../../../../../core/constants/color.dart';
import '../../../../cubit/reply/reply_cubit.dart';
import '../../../../widgets/button_container_widget.dart';
import '../../../profile/widgets/profile_form_widgets.dart';


class EditReplyMainWidget extends StatefulWidget {
  final ReplyEntity reply;
  const EditReplyMainWidget({Key? key, required this.reply}) : super(key: key);

  @override
  State<EditReplyMainWidget> createState() => _EditReplyMainWidgetState();
}

class _EditReplyMainWidgetState extends State<EditReplyMainWidget> {

  TextEditingController? _descriptionController;

  bool _isReplyUpdating = false;

  @override
  void initState() {
    _descriptionController = TextEditingController(text: widget.reply.description);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Edit Reply"),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 8.0.w, vertical:8.0.h),
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
                _editReply();
                Navigator.pop(context);
              },
            ),
            sizeVer(8.h),
            _isReplyUpdating == true?Row(
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

  _editReply() {
    setState(() {
      _isReplyUpdating = true;
    });
    BlocProvider.of<ReplyCubit>(context).updateReply(reply: ReplyEntity(
        postId: widget.reply.postId,
        commentId: widget.reply.commentId,
        replyId: widget.reply.replyId,
        description: _descriptionController!.text
    )).then((value) {
      setState(() {
        _isReplyUpdating = false;
        _descriptionController!.clear();
      });
      Navigator.pop(context);
    });
  }
}