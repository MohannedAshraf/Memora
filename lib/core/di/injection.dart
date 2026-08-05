import 'package:get_it/get_it.dart';
import 'package:memora/features/albums/data/data_sources/albums_remote_data_source.dart';
import 'package:memora/features/albums/data/data_sources/invited_album_remote_data_source.dart';
import 'package:memora/features/albums/domain/repo/albums_repository.dart';
import 'package:memora/features/albums/domain/repo/albums_repository_impl.dart';
import 'package:memora/features/albums/domain/repo/invited_album_repo.dart';
import 'package:memora/features/albums/domain/repo/invited_album_repo_impl.dart';
import 'package:memora/features/albums/domain/usecase/get_invited_album_usecase.dart';
import 'package:memora/features/albums/domain/usecase/get_my_albums_usecase.dart';
import 'package:memora/features/albums/presentation/bloc/albums_cubit.dart';
import 'package:memora/features/albums/presentation/bloc/invited_album_cubit.dart';
import 'package:memora/features/create_album/data/data_sources/create_album_remote_data_source.dart';
import 'package:memora/features/create_album/domain/repo/create_album_repo.dart';
import 'package:memora/features/create_album/domain/repo/create_album_repo_impl.dart';
import 'package:memora/features/create_album/domain/usecases/create_album_usecase.dart';
import 'package:memora/features/create_album/presentation/bloc/create_album_cubit.dart';
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

  sl.registerLazySingleton<AlbumsRemoteDataSource>(
    () => AlbumsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AlbumsRepository>(() => AlbumsRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetMyAlbumsUseCase(sl()));
   
   sl.registerFactory(() => AlbumsCubit(sl()));


   sl.registerLazySingleton<CreateAlbumRemoteDataSource>(
    () => CreateAlbumRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CreateAlbumRepo>(() => CreateAlbumsRepoImpl(sl()));


sl.registerLazySingleton(() => CreateAlbumUseCase(sl()));
sl.registerFactory(() => CreateAlbumCubit(sl()));


sl.registerLazySingleton<InvitedAlbumsRemoteDataSource>(
    () => InvitedAlbumsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<InvitedAlbumsRepo>(
    () => InvitedAlbumsRepoImpl(sl()),
  );

  sl.registerLazySingleton(() => GetInvitedAlbumsUseCase(sl()));

  sl.registerFactory(() => InvitedAlbumsCubit(sl()));

}
