
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/profile/widgets/no_followers_widget.dart';
import 'package:insta_clone_clean_arc/injection_container.dart' as di;
import '../../../../core/constants/color.dart';
import '../../../../core/constants/constans.dart';
import '../../../../core/constants/page_constants.dart';
import '../../../domain/entity/user/user_entity.dart';
import '../../../domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import '../../widgets/profile_widget.dart';

class FollowersPage extends StatelessWidget {
  final UserEntity user;
  const FollowersPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        title: const Text("Followers"),
        backgroundColor: AppColors.backGroundColor,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
        child: Column(
          children: [
            Expanded(
              child: user.followers!.isEmpty? const NoFollowersWidget() : ListView.builder(
                  itemCount: user.followers!.length,
                  itemBuilder: (context, index) {
                return StreamBuilder<List<UserEntity>>(
                    stream: di.sl<GetSingleUserUseCase>().call(user.followers![index]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data!.isEmpty) {
                        return Container();
                      }
                      final singleUserData = snapshot.data!.first;
                      return  GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageConst.singleUserProfilePage, arguments: singleUserData.uid);

                        },
                        child: Row(
                          children: [
                            Container(
                              margin:  EdgeInsets.symmetric(vertical: 8.0.h),
                              width: 40.w,
                              height: 40.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24.r),
                                child: profileWidget(imageUrl: singleUserData.profileUrl),
                              ),
                            ),
                            sizeHor(8.w),
                            Text("${singleUserData.username}", style: const TextStyle(color: AppColors.primaryColor, fontSize: 15, fontWeight: FontWeight.w600),)
                          ],
                        ),
                      );
                    }
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
