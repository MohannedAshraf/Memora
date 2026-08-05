import 'package:memora/features/albums/domain/entities/invited_album_entity.dart';
import 'package:memora/features/albums/domain/repo/invited_album_repo.dart';

class GetInvitedAlbumsUseCase {
  final InvitedAlbumsRepo repo;

  GetInvitedAlbumsUseCase(this.repo);

  Future<List<InvitedAlbumEntity>> call() {
    return repo.getInvitedAlbums();
  }
}
