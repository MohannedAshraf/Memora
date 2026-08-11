import 'package:memora/features/albums/data/data_sources/add_album_members_remote_data_source.dart';
import 'package:memora/features/create_album/domain/entities/album_invitation_entity.dart';

import '../../domain/repo/add_album_members_repository.dart';

class AddAlbumMembersRepositoryImpl implements AddAlbumMembersRepository {
  final AddAlbumMembersRemoteDataSource remoteDataSource;

  AddAlbumMembersRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addMembers({
    required String albumId,
    required List<AlbumInvitationEntity> invitations,
  }) {
    return remoteDataSource.addMembers(
      albumId: albumId,
      invitations: invitations,
    );
  }
}
