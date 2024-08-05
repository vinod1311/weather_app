
import 'package:weather_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthState{}

class AuthInitial extends AuthState{}

class AuthLoading extends AuthState{}

class AuthError extends AuthState{
  final String message;

  AuthError(this.message);
}

class Authenticated extends AuthState {
  final UserEntity user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}