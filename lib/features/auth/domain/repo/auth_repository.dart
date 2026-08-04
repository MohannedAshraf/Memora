import 'package:memora/features/auth/domain/entities/login_entity.dart';
import 'package:memora/features/auth/domain/entities/register_entity.dart';

abstract class AuthRepository {
  Future<void> login(LoginEntity entity);

  Future<void> register(RegisterEntity entity);
}
