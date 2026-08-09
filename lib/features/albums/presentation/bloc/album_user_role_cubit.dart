import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/get_album_user_role_usecase.dart';

class AlbumUserRoleCubit extends Cubit<String?> {
  final GetAlbumUserRoleUseCase getAlbumUserRoleUseCase;

  AlbumUserRoleCubit(this.getAlbumUserRoleUseCase) : super(null);

  Future<String?> getUserRole(String albumId) async {
    try {
      final role = await getAlbumUserRoleUseCase(albumId);

      emit(role);

      return role;
    } catch (e) {
      emit(null);
      return null;
    }
  }
}
