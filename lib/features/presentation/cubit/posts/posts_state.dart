part of 'posts_cubit.dart';

abstract class PostsState extends Equatable {
  const PostsState();
}

class PostsInitial extends PostsState {
  @override
  List<Object> get props => [];
}

class PostsLoading extends PostsState {
  @override
  List<Object> get props => [];
}
class PostsLoaded extends PostsState {
  List<PostEntity> posts;

  PostsLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}
class PostsFailure extends PostsState {
  @override
  List<Object> get props => [];
}