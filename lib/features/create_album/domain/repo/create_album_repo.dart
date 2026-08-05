import '../entities/create_album_entity.dart';

abstract class CreateAlbumRepo {
  Future<void> createAlbum(CreateAlbumEntity entity);
}
