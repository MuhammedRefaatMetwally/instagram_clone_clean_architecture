import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../domain/usecases/firebase_usecases/user/is_sign_in_usecase.dart';
import '../../../domain/usecases/firebase_usecases/user/sign_out_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsSignInUseCase isSignInUsecase;
  final SignOutUseCase  signOutUsecase;
  final GetCurrentUidUserCase getCurrentUidUseCase;


  AuthCubit(
      {required this.isSignInUsecase, required this.signOutUsecase, required this.getCurrentUidUseCase}) : super(AuthInitial());

  static AuthCubit i(BuildContext context)=>BlocProvider.of(context) ;
  Future<void> appStarted(BuildContext context) async{
    try{
    bool isSignIn = await  isSignInUsecase.call();
     if(isSignIn == true){
     final uid = await getCurrentUidUseCase.call();
     emit(Authenticated(uid: uid));
     }else{
       emit(UnAuthenticated());
     }
    } catch(_){
      emit(UnAuthenticated());

    }
  }

  Future<void> loggedIn() async{
    try{
      final uid=await getCurrentUidUseCase.call();
      emit(Authenticated(uid: uid));
    }catch(_){
       emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async{
    try{
      await signOutUsecase.call();
      emit(UnAuthenticated());
    }catch(_){
      emit(UnAuthenticated());
    }
  }

}
