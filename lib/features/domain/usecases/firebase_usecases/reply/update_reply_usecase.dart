import '../../../entity/reply/reply_entity.dart';
import '../../../repository/firebase_repository.dart';

class UpdateReplyUseCase {
  final FirebaseRepository repository;

  UpdateReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.updateReply(reply);
  }
}