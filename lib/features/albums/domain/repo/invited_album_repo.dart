import 'package:memora/features/albums/domain/entities/invited_album_entity.dart';

abstract class InvitedAlbumsRepo {
  Future<List<InvitedAlbumEntity>> getInvitedAlbums();
}
