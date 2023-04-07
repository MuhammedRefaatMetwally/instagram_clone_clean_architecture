
import '../../../entity/comments/comment_entity.dart';
import '../../../repository/firebase_repository.dart';


class ReadCommentsUseCase {
  final FirebaseRepository repository;

  ReadCommentsUseCase({required this.repository});

  Stream<List<CommentEntity>> call(String postId) {
    return repository.readComments(postId);
  }
}