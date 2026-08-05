import 'package:memora/features/albums/data/data_sources/invited_album_remote_data_source.dart';
import 'package:memora/features/albums/domain/entities/invited_album_entity.dart';
import 'package:memora/features/albums/domain/repo/invited_album_repo.dart';

class InvitedAlbumsRepoImpl implements InvitedAlbumsRepo {
  final InvitedAlbumsRemoteDataSource remote;

  InvitedAlbumsRepoImpl(this.remote);

  @override
  Future<List<InvitedAlbumEntity>> getInvitedAlbums() {
    return remote.getInvitedAlbums();
  }
}
