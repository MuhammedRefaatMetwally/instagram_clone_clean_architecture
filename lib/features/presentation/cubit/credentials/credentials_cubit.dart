import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone_clean_arc/features/domain/entity/user/user_entity.dart';

import '../../../domain/usecases/firebase_usecases/user/sign_in_user_usecase.dart';
import '../../../domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';

part 'credentials_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInUserUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;

  CredentialCubit({required this.signInUseCase, required this.signUpUseCase}) : super(CredentialInitial());
   bool isSigningIn = false;

  static CredentialCubit i(BuildContext context) => BlocProvider.of(context);

  void signedInUser(){
    isSigningIn=true;
    emit(SignedInState());
  }

  Future<void> signInUser({required String email, required String password}) async{
    emit(CredentialLoading());
    try{
      await signInUseCase.call(UserEntity(email: email,password:password ));
      emit(CredentialSuccess());
    }on SocketException catch(_){
    emit(CredentialFailure());
    }catch(_){
    emit(CredentialFailure());
    }
  }


  Future<void> signUpUser({required UserEntity user}) async{
    emit(CredentialLoading());
    try{
      await signUpUseCase.call(user);
      emit(CredentialSuccess());
    }on SocketException catch(_){
      emit(CredentialFailure());
    }catch(_){
      emit(CredentialFailure());
    }
  }


}



