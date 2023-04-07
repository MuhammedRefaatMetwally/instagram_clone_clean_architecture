import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/posts/post_entity.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/credentials/sign_in_page.dart';
import 'package:insta_clone_clean_arc/features/presentation/%20pages/main_screen/main_screen.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/credentials/credentials_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/posts/posts_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/user/user_cubit.dart';
import 'features/presentation/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'injection_container.dart' as di;
import 'on_generate_route.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider(create: (_) => di.sl<UserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleOtherUserCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child)=>MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(useMaterial3: true),
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: "/",
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(
                    uid: authState.uid,
                  );
                } else {
                  return const SignInPage();
                }
              },
            );
          }
        },
      ),

      ),
    );
  }
}
