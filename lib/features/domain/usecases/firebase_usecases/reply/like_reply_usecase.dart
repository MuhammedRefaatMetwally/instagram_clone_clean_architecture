
import '../../../entity/reply/reply_entity.dart';
import '../../../repository/firebase_repository.dart';

class LikeReplyUseCase {
  final FirebaseRepository repository;

  LikeReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.likeReply(reply);
  }
}