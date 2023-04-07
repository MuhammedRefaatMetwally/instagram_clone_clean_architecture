

import 'package:insta_clone_clean_arc/features/domain/entity/user/user_entity.dart';

import '../../../repository/firebase_repository.dart';

class CreateUserUsercase{
  final  FirebaseRepository repository;

  CreateUserUsercase({required this.repository});

  Future<void> call(UserEntity user){
    return repository.createUser(user);
  }

}