import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone_clean_arc/features/data/models/bottom_modal_sheet/bottom_modal_sheet_model.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/profile/widgets/profile_main_body_widget.dart';
import 'package:insta_clone_clean_arc/features/presentation/widgets/open_bottom_modal_sheet.dart';
import '../../../../../core/constants/color.dart';
import '../../../../domain/entity/posts/post_entity.dart';
import '../../../../domain/entity/user/user_entity.dart';
import '../../../cubit/posts/posts_cubit.dart';
import '../../../widgets/profile_widget.dart';


class ProfileMainWidget extends StatefulWidget {
  final UserEntity currentUser;

  const ProfileMainWidget({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<ProfileMainWidget> createState() => _ProfileMainWidgetState();
}

class _ProfileMainWidgetState extends State<ProfileMainWidget> {

  @override
  void initState() {
    BlocProvider.of<PostsCubit>(context).getPosts(post: const PostEntity());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          backgroundColor: backGroundColor,
          title: Text(
            "${widget.currentUser.username}",
            style: const TextStyle(color: primaryColor),
          ),
          actions: [
            Padding(
              padding:  EdgeInsets.only(right: 10.0.w),
              child: InkWell(
                  onTap: () {
                    OpenBottomModalSheet.show(options: BottomModalSheetModel(firstOption: 'Edit Profile',
                      secondOption: "Logout", context: context ,
                      currentUser: widget.currentUser
                    ));
                  },
                  child: const Icon(
                    Icons.menu,
                    color: primaryColor,
                  )),
            )
          ],
        ),
        body:  ProfileMainBodyWidget(currentUser: widget.currentUser,));
  }

}
