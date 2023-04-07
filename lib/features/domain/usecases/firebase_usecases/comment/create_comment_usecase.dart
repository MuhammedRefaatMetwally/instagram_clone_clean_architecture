
import '../../../entity/comments/comment_entity.dart';
import '../../../repository/firebase_repository.dart';


class CreateCommentUseCase {
  final FirebaseRepository repository;

  CreateCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.createComment(comment);
  }
}