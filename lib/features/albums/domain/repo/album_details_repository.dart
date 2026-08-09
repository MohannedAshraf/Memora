import '../entities/album_details_entity.dart';

abstract class AlbumDetailsRepository {
  Future<AlbumDetailsEntity> getAlbumDetails(String albumId);

  Future<String> getCoverUrl(String? coverPhotoId);
}
