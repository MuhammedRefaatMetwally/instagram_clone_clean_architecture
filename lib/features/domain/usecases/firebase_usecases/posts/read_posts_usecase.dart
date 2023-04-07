
import '../../../entity/posts/post_entity.dart';
import '../../../repository/firebase_repository.dart';

class ReadPostsUseCase {
  final FirebaseRepository repository;

  ReadPostsUseCase({required this.repository});

  Stream<List<PostEntity>> call(PostEntity post) {
    return repository.readPosts(post);
  }
}