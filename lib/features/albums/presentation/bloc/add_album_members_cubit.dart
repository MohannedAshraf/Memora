import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memora/features/albums/domain/usecase/add_album_members_usecase.dart';
import 'package:memora/features/create_album/domain/entities/album_invitation_entity.dart';
import 'add_album_members_state.dart';

class AddAlbumMembersCubit extends Cubit<AddAlbumMembersState> {
  final AddAlbumMembersUseCase addAlbumMembersUseCase;

  AddAlbumMembersCubit(this.addAlbumMembersUseCase)
    : super(AddAlbumMembersInitial());

  Future<void> addMembers({
    required String albumId,
    required List<AlbumInvitationEntity> invitations,
  }) async {
    emit(AddAlbumMembersLoading());

    try {
      await addAlbumMembersUseCase(albumId: albumId, invitations: invitations);

      emit(AddAlbumMembersSuccess());
    } catch (e) {
      emit(AddAlbumMembersFailure(e.toString()));
    }
  }
}
