
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/features/auth/domain/repository/auth_repository.dart';
import '../entities/user_entity.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase(this.authRepository);

  Future<UserEntity?> call(String email,String password){
    return authRepository.signInWithEmailAndPassword(email, password);
  }

}