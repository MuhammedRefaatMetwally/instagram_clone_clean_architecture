
import '../../../entity/reply/reply_entity.dart';
import '../../../repository/firebase_repository.dart';

class CreateReplyUseCase {
  final FirebaseRepository repository;

  CreateReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.createReply(reply);
  }
}
