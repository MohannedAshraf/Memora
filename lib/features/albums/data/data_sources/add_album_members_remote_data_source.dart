import 'package:memora/features/create_album/domain/entities/album_invitation_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


abstract class AddAlbumMembersRemoteDataSource {
  Future<void> addMembers({
    required String albumId,
    required List<AlbumInvitationEntity> invitations,
  });
}

class AddAlbumMembersRemoteDataSourceImpl
    implements AddAlbumMembersRemoteDataSource {
  final SupabaseClient client;

  AddAlbumMembersRemoteDataSourceImpl(this.client);

  @override
  Future<void> addMembers({
    required String albumId,
    required List<AlbumInvitationEntity> invitations,
  }) async {
    for (final invitation in invitations) {
      await client.rpc(
        'send_album_invitation',
        params: {
          'p_album_id': albumId,
          'p_email': invitation.email,
          'p_role': invitation.role.name,
        },
      );
    }
  }
}
