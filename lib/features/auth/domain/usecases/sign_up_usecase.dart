
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/features/auth/domain/entities/user_entity.dart';
import 'package:weather_app/features/auth/domain/repository/auth_repository.dart';

class SignUpUseCase{

  final AuthRepository authRepository;

  SignUpUseCase(this.authRepository);

  Future<UserEntity?> call(String email,String password){
    return authRepository.signUpWithEmailAndPassword(email, password);
  }

}