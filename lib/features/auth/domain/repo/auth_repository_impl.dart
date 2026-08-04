import 'package:memora/features/auth/data/data_source/login_remote_data_source.dart';
import 'package:memora/features/auth/data/data_source/register_remote_data_source.dart';
import 'package:memora/features/auth/data/models/login_model.dart';
import 'package:memora/features/auth/data/models/register_model.dart';
import 'package:memora/features/auth/domain/entities/login_entity.dart';
import 'package:memora/features/auth/domain/entities/register_entity.dart';
import 'package:memora/features/auth/domain/repo/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LoginRemoteDataSource loginRemoteDataSource;
  final RegisterRemoteDataSource registerRemoteDataSource;

  AuthRepositoryImpl(this.loginRemoteDataSource, this.registerRemoteDataSource);

  @override
  Future<void> login(LoginEntity entity) async {
    final model = LoginModel.fromEntity(entity);

    await loginRemoteDataSource.login(model);
  }

  @override
  Future<void> register(RegisterEntity entity) async {
    final model = RegisterModel.fromEntity(entity);

    await registerRemoteDataSource.register(model);
  }
}
