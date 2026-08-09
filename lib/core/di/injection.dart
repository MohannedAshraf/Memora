import 'package:get_it/get_it.dart';
import 'package:memora/core/services/media_picker_service.dart';
import 'package:memora/features/albums/data/data_sources/album_details_remote_data_source.dart';
import 'package:memora/features/albums/data/data_sources/album_media_remote_data_source.dart';
import 'package:memora/features/albums/data/data_sources/album_members_remote_data_source.dart';
import 'package:memora/features/albums/data/data_sources/albums_remote_data_source.dart';
import 'package:memora/features/albums/data/data_sources/invited_album_remote_data_source.dart';
import 'package:memora/features/albums/domain/repo/album_details_repository.dart';
import 'package:memora/features/albums/domain/repo/album_details_repository_impl.dart';
import 'package:memora/features/albums/domain/repo/album_media_repository.dart';
import 'package:memora/features/albums/domain/repo/album_media_repository_impl.dart';
import 'package:memora/features/albums/domain/repo/album_members_repository.dart';
import 'package:memora/features/albums/domain/repo/album_members_repository_impl.dart';
import 'package:memora/features/albums/domain/repo/albums_repository.dart';
import 'package:memora/features/albums/domain/repo/albums_repository_impl.dart';
import 'package:memora/features/albums/domain/repo/invited_album_repo.dart';
import 'package:memora/features/albums/domain/repo/invited_album_repo_impl.dart';
import 'package:memora/features/albums/domain/usecase/get_album_details_usecase.dart';
import 'package:memora/features/albums/domain/usecase/get_album_media_usecase.dart';
import 'package:memora/features/albums/domain/usecase/get_album_members_usecase.dart';
import 'package:memora/features/albums/domain/usecase/get_album_user_role_usecase.dart';
import 'package:memora/features/albums/domain/usecase/get_invited_album_usecase.dart';
import 'package:memora/features/albums/domain/usecase/get_my_albums_usecase.dart';
import 'package:memora/features/albums/presentation/bloc/album_details_cubit.dart';
import 'package:memora/features/albums/presentation/bloc/album_media_cubit.dart';
import 'package:memora/features/albums/presentation/bloc/album_members_cubit.dart';
import 'package:memora/features/albums/presentation/bloc/album_user_role_cubit.dart';
import 'package:memora/features/albums/presentation/bloc/albums_cubit.dart';
import 'package:memora/features/albums/presentation/bloc/invited_album_cubit.dart';
import 'package:memora/features/create_album/data/data_sources/create_album_remote_data_source.dart';
import 'package:memora/features/create_album/domain/repo/create_album_repo.dart';
import 'package:memora/features/create_album/domain/repo/create_album_repo_impl.dart';
import 'package:memora/features/create_album/domain/usecases/create_album_usecase.dart';
import 'package:memora/features/create_album/presentation/bloc/create_album_cubit.dart';
import 'package:memora/features/invitations/data/data_sources/invitations_remote_data_source.dart';
import 'package:memora/features/invitations/domain/repo/invitations_repository.dart';
import 'package:memora/features/invitations/domain/repo/invitations_repository_impl.dart';
import 'package:memora/features/invitations/domain/usecases/accept_invitation_usecase.dart';
import 'package:memora/features/invitations/domain/usecases/decline_invitation_usecase.dart';
import 'package:memora/features/invitations/domain/usecases/get_pending_invitations_usecase.dart';
import 'package:memora/features/invitations/presentation/bloc/invitations_cubit.dart';
import 'package:memora/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:memora/features/profile/domain/repo/profile_repository.dart';
import 'package:memora/features/profile/domain/repo/profile_repository_impl.dart';
import 'package:memora/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:memora/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:memora/features/profile/domain/usecases/upload_avatar_use_case.dart';
import 'package:memora/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:memora/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:memora/features/search/domain/repo/search_repo.dart';
import 'package:memora/features/search/domain/repo/search_repo_impl.dart';
import 'package:memora/features/search/domain/usecases/search_albums_usecase.dart';
import 'package:memora/features/search/presentation/bloc/search_cubit.dart';
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
  // ==============================
//================ Invitations =================//

  sl.registerLazySingleton<InvitationsRemoteDataSource>(
    () => InvitationsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<InvitationsRepository>(
    () => InvitationsRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetPendingInvitationsUseCase(sl()));

  sl.registerLazySingleton(() => AcceptInvitationUseCase(sl()));

  sl.registerLazySingleton(() => DeclineInvitationUseCase(sl()));

  // Cubit
  sl.registerFactory(() => InvitationsCubit(sl(), sl(), sl()));



  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(sl()));

  sl.registerLazySingleton(() => SearchAlbumsUseCase(sl()));


  sl.registerFactory(() => SearchCubit(sl()));



  // ==============================
  // Album Details
  // ==============================

  sl.registerLazySingleton<AlbumDetailsRemoteDataSource>(
    () => AlbumDetailsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AlbumDetailsRepository>(
    () => AlbumDetailsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetAlbumDetailsUseCase(sl()));

  // ==============================
  // Album Members
  // ==============================

  sl.registerLazySingleton<AlbumMembersRemoteDataSource>(
    () => AlbumMembersRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AlbumMembersRepository>(
    () => AlbumMembersRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetAlbumMembersUseCase(sl()));

  sl.registerLazySingleton(() => GetAlbumUserRoleUseCase(sl()));

  // ==============================
  // Album Media
  // ==============================

  sl.registerLazySingleton<AlbumMediaRemoteDataSource>(
    () => AlbumMediaRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AlbumMediaRepository>(
    () => AlbumMediaRepositoryImpl(sl()),
  );

  // ==============================
  // Album Details Cubit
  // ==============================

  sl.registerFactory(() => AlbumDetailsCubit(sl()));

  // ==============================
  // Album Members Cubit
  // ==============================

  sl.registerFactory(() => AlbumMembersCubit(sl()));

  // ==============================
  // Album Media Cubit
  // ==============================

  sl.registerFactory(() => AlbumMediaCubit(sl())); 
  sl.registerLazySingleton<MediaPickerService>(() => MediaPickerService());
  sl.registerLazySingleton(() => GetAlbumMediaUseCase(sl()));

//sl.registerLazySingleton(() => GetAlbumUserRoleUseCase(sl()));
sl.registerFactory(() => AlbumUserRoleCubit(sl()));




sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );
sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<GetProfileUseCase>(() => GetProfileUseCase(sl()));

  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl()),
  );

  sl.registerLazySingleton<UploadAvatarUseCase>(
    () => UploadAvatarUseCase(sl()),
  );

  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
      uploadAvatarUseCase: sl(),
    ),
  );
}
