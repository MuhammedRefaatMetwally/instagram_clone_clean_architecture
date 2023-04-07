
import '../../../entity/comments/comment_entity.dart';
import '../../../repository/firebase_repository.dart';


class DeleteCommentUseCase {
  final FirebaseRepository repository;

  DeleteCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.deleteComment(comment);
  }
}