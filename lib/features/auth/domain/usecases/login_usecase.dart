import 'package:memora/features/auth/domain/repo/auth_repository.dart';

import '../entities/login_entity.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<void> call(LoginEntity entity) {
    return repository.login(entity);
  }
}
