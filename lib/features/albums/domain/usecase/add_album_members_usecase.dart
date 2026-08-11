import 'package:memora/features/create_album/domain/entities/album_invitation_entity.dart';

import '../repo/add_album_members_repository.dart';

class AddAlbumMembersUseCase {
  final AddAlbumMembersRepository repository;

  AddAlbumMembersUseCase(this.repository);

  Future<void> call({
    required String albumId,
    required List<AlbumInvitationEntity> invitations,
  }) {
    return repository.addMembers(albumId: albumId, invitations: invitations);
  }
}
