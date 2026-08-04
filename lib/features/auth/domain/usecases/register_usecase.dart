import 'package:memora/features/auth/domain/repo/auth_repository.dart';

import '../entities/register_entity.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call(RegisterEntity entity) {
    return repository.register(entity);
  }
}
