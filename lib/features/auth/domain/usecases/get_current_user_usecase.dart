
import 'package:weather_app/features/auth/domain/repository/auth_repository.dart';

import '../entities/user_entity.dart';

class GetCurrentUserUseCase {
  final AuthRepository authRepository;

  GetCurrentUserUseCase(this.authRepository);

  Future<UserEntity?> call(){
    return authRepository.getCurrentUser();
  }
}