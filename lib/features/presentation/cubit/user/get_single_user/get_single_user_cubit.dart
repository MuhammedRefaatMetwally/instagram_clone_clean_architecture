import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/user/user_entity.dart';

import '../../../../domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUseCase getSingleUserUseCase;
  GetSingleUserCubit({required this.getSingleUserUseCase})
      : super(GetSingleUserInitial());

  Future<void> getSingleUsers({required String uid}) async {
    try {
      final streamResponse = getSingleUserUseCase.call(uid);
      streamResponse.listen((users) {
        emit(GetSingleUserLoaded(user: users.first));
      });
    } on SocketException catch (_) {
      emit(GetSingleUserFailure());
    } catch (_) {
      emit(GetSingleUserFailure());
    }
  }
}
