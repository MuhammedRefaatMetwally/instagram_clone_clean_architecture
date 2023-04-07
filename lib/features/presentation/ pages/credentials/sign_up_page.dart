import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/user/user_entity.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/credentials/widgets/main_sing_up_page.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/main_screen/main_screen.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/credentials/credentials_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/widgets/form_container_widget.dart';
import 'package:insta_clone_clean_arc/features/presentation/widgets/profile_widget.dart';

import '../../../../core/constants/color.dart';
import '../../widgets/button_container_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (credentialState is CredentialFailure) {
            toast("Invalid Email and Password");
          }
        },
        builder: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(uid: authState.uid);
                } else {
                  return const MainSignUpPage();
                }
              },
            );
          }
          return const MainSignUpPage();
        },
      ),
    );
  }
}
