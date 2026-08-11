import 'package:memora/features/create_album/domain/entities/album_invitation_entity.dart';


abstract class AddAlbumMembersRepository {
  Future<void> addMembers({
    required String albumId,
    required List<AlbumInvitationEntity> invitations,
  });
}
