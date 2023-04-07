part of 'reply_cubit.dart';

abstract class ReplyState extends Equatable {
  const ReplyState();
}

class ReplyInitial extends ReplyState {
  @override
  List<Object> get props => [];
}

class ReplyLoading extends ReplyState {
  @override
  List<Object> get props => [];
}
class RepliesLoaded extends ReplyState {
  final List<ReplyEntity> replies;

  const RepliesLoaded({required this.replies});

  @override
  List<Object> get props => [replies];
}
class ReplyFailure extends ReplyState {
  @override
  List<Object> get props => [];
}
