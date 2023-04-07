import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entity/posts/post_entity.dart';
import '../../../domain/usecases/firebase_usecases/posts/create_post_usecase.dart';
import '../../../domain/usecases/firebase_usecases/posts/delete_post_usecase.dart';
import '../../../domain/usecases/firebase_usecases/posts/like_post_usecase.dart';
import '../../../domain/usecases/firebase_usecases/posts/read_posts_usecase.dart';
import '../../../domain/usecases/firebase_usecases/posts/update_post_usecase.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
 final CreatePostUseCase createPostUseCase;
 final DeletePostUseCase deletePostUseCase;
 final LikePostUseCase likePostUseCase;
 final ReadPostsUseCase readPostUseCase;
 final UpdatePostUseCase updatePostUseCase;
  PostsCubit(
      {
    required this.createPostUseCase,
    required this.deletePostUseCase,
    required this.likePostUseCase,
    required this.readPostUseCase,
    required this.updatePostUseCase,
  }) : super(PostsInitial());

  Future<void>  getPosts({required PostEntity post}) async{
    emit(PostsLoading());
    try {
     final streamResponse = readPostUseCase.call(post);
     streamResponse.listen((posts) {
      emit(PostsLoaded(posts: posts));
     });
    }on SocketException catch(_) {
     emit(PostsFailure());
    }catch(_){
     emit(PostsFailure());
    }
  }


  Future<void> likePosts({required PostEntity post}) async{

   try{
    likePostUseCase.call(post);
   }on SocketException catch(_){
    emit(PostsFailure());
   }catch(_){
    emit(PostsFailure());
   }
  }

  Future<void> deletePosts({required PostEntity post}) async {
   try{
    await deletePostUseCase.call(post);
   }on SocketException catch(_){
    emit(PostsFailure());
   }catch(_){
    emit(PostsFailure());
   }


  }

 Future<void> createPost({required PostEntity post}) async{
    try {
      await createPostUseCase.call(post);
    } on SocketException catch(_) {
      emit(PostsFailure());
    } catch (_) {
      emit(PostsFailure());
    }
  }
  Future<void> updatePosts({required PostEntity post}) async{
    try{
      await updatePostUseCase.call(post);
    }on SocketException catch(_){
      emit(PostsFailure());
    }catch(_){
      emit(PostsFailure());
    }
  }
}
