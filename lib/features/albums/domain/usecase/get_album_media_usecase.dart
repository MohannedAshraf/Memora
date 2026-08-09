import '../entities/album_media_entity.dart';
import '../repo/album_media_repository.dart';

class GetAlbumMediaUseCase {
  final AlbumMediaRepository repository;

  GetAlbumMediaUseCase(this.repository);

  Future<List<AlbumMediaEntity>> call(String albumId) {
    return repository.getAlbumMedia(albumId);
  }
}
