

import 'package:insta_clone_clean_arc/features/domain/repository/firebase_repository.dart';

class GetCurrentUidUserCase{
  final FirebaseRepository repository;

  GetCurrentUidUserCase({required this.repository});

  Future<String> call() {
    return repository.getCurrentUid();
  }
}