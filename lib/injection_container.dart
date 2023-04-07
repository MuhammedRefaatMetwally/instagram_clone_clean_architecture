import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:insta_clone_clean_arc/features/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:insta_clone_clean_arc/features/data/data_source/remote_data_source/remote_data_source_impl.dart';
import 'package:insta_clone_clean_arc/features/data/repository/firebase_repository_impl.dart';
import 'package:insta_clone_clean_arc/features/domain/repository/firebase_repository.dart';
import 'package:insta_clone_clean_arc/features/domain/usecases/firebase_usecases/storage/uplode_image_to_usecase.dart';
import 'package:insta_clone_clean_arc/features/domain/usecases/firebase_usecases/user/create_user_usecase.dart';
import 'package:insta_clone_clean_arc/features/domain/usecases/firebase_usecases/user/follow_unfollow_user_usecase.dart';
import 'package:insta_clone_clean_arc/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:insta_clone_clean_arc/features/domain/usecases/firebase_usecases/user/sign_out_usecase.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/credentials/credentials_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/posts/get_single_post/get_single_post_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/posts/posts_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:insta_clone_clean_arc/features/presentation/cubit/user/user_cubit.dart';
import 'features/domain/usecases/firebase_usecases/comment/create_comment_usecase.dart';
import 'features/domain/usecases/firebase_usecases/comment/delete_comment_usecase.dart';
import 'features/domain/usecases/firebase_usecases/comment/like_comment_usecase.dart';
import 'features/domain/usecases/firebase_usecases/comment/read_comment_usecase.dart';
import 'features/domain/usecases/firebase_usecases/comment/update_comment_usecase.dart';
import 'features/domain/usecases/firebase_usecases/posts/create_post_usecase.dart';
import 'features/domain/usecases/firebase_usecases/posts/delete_post_usecase.dart';
import 'features/domain/usecases/firebase_usecases/posts/like_post_usecase.dart';
import 'features/domain/usecases/firebase_usecases/posts/read_posts_usecase.dart';
import 'features/domain/usecases/firebase_usecases/posts/read_single_post_usecase.dart';
import 'features/domain/usecases/firebase_usecases/posts/update_post_usecase.dart';
import 'features/domain/usecases/firebase_usecases/reply/create_reply_usecase.dart';
import 'features/domain/usecases/firebase_usecases/reply/delete_reply_usecase.dart';
import 'features/domain/usecases/firebase_usecases/reply/like_reply_usecase.dart';
import 'features/domain/usecases/firebase_usecases/reply/read_replies_usecase.dart';
import 'features/domain/usecases/firebase_usecases/reply/update_reply_usecase.dart';
import 'features/domain/usecases/firebase_usecases/user/get_single_other_user_usecase.dart';
import 'features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'features/domain/usecases/firebase_usecases/user/get_users_usecase.dart';
import 'features/domain/usecases/firebase_usecases/user/is_sign_in_usecase.dart';
import 'features/domain/usecases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'features/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'features/domain/usecases/firebase_usecases/user/update_user_usecase.dart';
import 'features/presentation/cubit/reply/reply_cubit.dart';
import 'features/presentation/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //cubit
  sl.registerFactory(() => AuthCubit(
      isSignInUsecase: sl.call(),
      signOutUsecase: sl.call(),
      getCurrentUidUseCase: sl.call()));

  sl.registerFactory(() =>
      CredentialCubit(signInUseCase: sl.call(), signUpUseCase: sl.call()));

  sl.registerFactory(
      () => UserCubit(updateUserUseCase: sl.call(), getUserUseCase: sl.call(), followUnFollowUseCase: sl.call()));

  sl.registerFactory(() => GetSingleUserCubit(getSingleUserUseCase: sl.call()));
  sl.registerFactory(() => GetSingleOtherUserCubit(getSingleOtherUserUseCase: sl.call()));

  //post
  sl.registerFactory(() => PostsCubit(
      createPostUseCase: sl.call(),
      deletePostUseCase: sl.call(),
      likePostUseCase: sl.call(),
      readPostUseCase: sl.call(),
      updatePostUseCase: sl.call()));

  sl.registerFactory(() => CommentCubit(
      createCommentUseCase: sl.call(),
      deleteCommentUseCase: sl.call(),
      likeCommentUseCase: sl.call(),
      readCommentsUseCase: sl.call(),
      updateCommentUseCase: sl.call()));

  // Replay Cubit Injection
  sl.registerFactory(
    () => ReplyCubit(
      createReplyUseCase: sl.call(),
      updateReplyUseCase: sl.call(),
      readRepliesUseCase: sl.call(),
      likeReplyUseCase: sl.call(),
      deleteReplyUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
      () => GetSinglePostCubit(readSinglePostUseCase: sl.call()));

  //Use case
  //user
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUidUserCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignInUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateUserUsercase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleOtherUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => FollowUnFollowUseCase(repository: sl.call()));

  //Cloud Storage
  sl.registerLazySingleton(
      () => UploadImageToStorageUseCase(repository: sl.call()));

  // Post
  sl.registerLazySingleton(() => CreatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadPostsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadSinglePostUseCase(repository: sl.call()));

  // Comment
  sl.registerLazySingleton(() => CreateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadCommentsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(repository: sl.call()));

  // Replay
  sl.registerLazySingleton(() => CreateReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadRepliesUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateReplyUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteReplyUseCase(repository: sl.call()));

  //Repository
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  //Remote DataSource
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));

  //Externals
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
