import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:weather_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:weather_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_state.dart';

import '../../../../config/routes/app_router.dart';
import '../../domain/usecases/sign_up_usecase.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
        required this.signInUseCase,
        required this.signUpUseCase,
        required this.signOutUseCase,
        required this.getCurrentUserUseCase
      }):super(AuthInitial()){
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  //----------- Sign in Method
  Future<void> _onSignIn(SignInEvent event,Emitter<AuthState> emit)async{
    emit(AuthLoading());
    try{
      final user = await signInUseCase.call(event.email, event.password);
      if(user != null){
        emit(Authenticated(user));
      }else{
        emit(AuthError("Sign in failed"));
      }
    }catch(e){
      emit(AuthError(e.toString()));
    }
  }

  //------------ Sign up method
  Future<void> _onSignUp(SignUpEvent event,Emitter<AuthState> emit)async{
    emit(AuthLoading());

    try{
      final user = await signUpUseCase.call(event.email, event.password);
      if(user != null){
        emit(Authenticated(user));
      }else{
        emit(AuthError("Sign up failed"));
      }
    }catch(e){
      emit(AuthError(e.toString()));
    }
  }

  //---------- Sign out method
  Future<void> _onSignOut(SignOutEvent event,Emitter<AuthState> emit)async{
    emit(AuthLoading());
    try{
      await signOutUseCase.call();
      // Clear Hive data after sign out
      await Hive.deleteFromDisk();
      emit(Unauthenticated());
      // Redirect to the login screen
      event.context.router.replace(SignInRoute());
    }catch(e){
      emit(AuthError(e.toString()));
    }
  }

  //--------- Method for checking user is logged in or not
  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event,Emitter<AuthState> emit)async{
    emit(AuthLoading());
    try{
      final user = await  getCurrentUserUseCase.call();
      if(user != null){
        emit(Authenticated(user));
      }else{
        emit(Unauthenticated());
      }
    }catch(e){
      emit(AuthError(e.toString()));
    }
  }
}