
import 'package:weather_app/features/auth/domain/repository/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository authRepository;

  SignOutUseCase(this.authRepository);

  Future<void> call(){
    return authRepository.singOut();
  }
}