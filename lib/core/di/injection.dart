import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/data_source/login_remote_data_source.dart';
import '../../features/auth/data/data_source/register_remote_data_source.dart';
import '../../features/auth/domain/repo/auth_repository.dart';
import '../../features/auth/domain/repo/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/login_cubit.dart';
import '../../features/auth/presentation/bloc/register_cubit.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  /// Supabase
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  /// Login Data Source
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(sl()),
  );

  /// Register Data Source
  sl.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSourceImpl(sl()),
  );

  /// Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<LoginRemoteDataSource>(),
      sl<RegisterRemoteDataSource>(),
    ),
  );

  /// Login UseCase
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  /// Register UseCase
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  /// Login Cubit
  sl.registerFactory(() => LoginCubit(sl()));

  /// Register Cubit
  sl.registerFactory(() => RegisterCubit(sl()));
}
