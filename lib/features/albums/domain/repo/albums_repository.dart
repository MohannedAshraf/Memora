import '../entities/album_entity.dart';

abstract class AlbumsRepository {
  Future<List<AlbumEntity>> getMyAlbums();
}
