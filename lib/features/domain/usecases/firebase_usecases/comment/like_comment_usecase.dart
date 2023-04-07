
import '../../../entity/comments/comment_entity.dart';
import '../../../repository/firebase_repository.dart';


class LikeCommentUseCase {
  final FirebaseRepository repository;

  LikeCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.likeComment(comment);
  }
}