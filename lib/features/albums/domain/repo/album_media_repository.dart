import '../entities/album_media_entity.dart';

abstract class AlbumMediaRepository {
  Future<List<AlbumMediaEntity>> getAlbumMedia(String albumId);
}
