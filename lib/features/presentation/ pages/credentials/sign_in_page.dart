import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/credentials/widgets/main_sign_in_page.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/credentials/credentials_cubit.dart';
import '../../../../core/constants/color.dart';
import '../../../../core/constants/constans.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../main_screen/main_screen.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit=AuthCubit.i(context);
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            cubit.loggedIn();
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
                  return const MainSignInPage();
                }
              },
            );
          }
          return const MainSignInPage();
        },
      ),
    );
  }

}
