import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/get_album_members_usecase.dart';
import 'album_members_state.dart';

class AlbumMembersCubit extends Cubit<AlbumMembersState> {
  final GetAlbumMembersUseCase getAlbumMembersUseCase;

  AlbumMembersCubit(this.getAlbumMembersUseCase) : super(AlbumMembersInitial());

  Future<void> getAlbumMembers(String albumId) async {
    emit(AlbumMembersLoading());

    try {
      final members = await getAlbumMembersUseCase(albumId);

      final currentUserRole = await getAlbumMembersUseCase.getCurrentUserRole(
        albumId,
      );

      emit(
        AlbumMembersLoaded(members: members, currentUserRole: currentUserRole),
      );
    } catch (e) {
      emit(AlbumMembersFailure(e.toString()));
    }
  }
}
