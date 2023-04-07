
import '../../../entity/reply/reply_entity.dart';
import '../../../repository/firebase_repository.dart';

class DeleteReplyUseCase {
  final FirebaseRepository repository;

  DeleteReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.deleteReply(reply);
  }
}