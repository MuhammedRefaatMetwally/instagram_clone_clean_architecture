import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone_clean_arc/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;
import 'package:intl/intl.dart';
import '../../../../../../core/constants/color.dart';
import '../../../../../../core/constants/constans.dart';
import '../../../../../domain/entity/reply/reply_entity.dart';
import '../../../../widgets/profile_widget.dart';

class SingleReplyWidget extends StatefulWidget {
  final ReplyEntity reply;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  const SingleReplyWidget({Key? key, required this.reply, this.onLongPressListener, this.onLikeClickListener}) : super(key: key);

  @override
  State<SingleReplyWidget> createState() => _SingleReplyWidgetState();
}

class _SingleReplyWidgetState extends State<SingleReplyWidget> {

  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUserCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.reply.creatorUid == _currentUid? widget.onLongPressListener : null,
      child: Container(
        margin:  EdgeInsets.only(left: 8.0.w, top: 8.0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: profileWidget(imageUrl: widget.reply.userProfileUrl),
              ),
            ),
            sizeHor(8.0.w),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${widget.reply.username}", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.primaryColor),),
                        GestureDetector(
                            onTap: widget.onLikeClickListener,
                            child: Icon(
                              widget.reply.likes!.contains(_currentUid)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              size: 20,
                              color: widget.reply.likes!.contains(_currentUid)
                                  ? Colors.red
                                  : AppColors.darkGreyColor,
                            ))                      ],
                    ),
                    sizeVer(4.sp),
                    Text("${widget.reply.description}", style: const TextStyle(color: AppColors.primaryColor),),
                    sizeVer(4.sp),
                    Text(
                      DateFormat("dd/MMM/yyy").format(widget.reply.createAt!.toDate()),
                      style: const TextStyle(color: AppColors.darkGreyColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
