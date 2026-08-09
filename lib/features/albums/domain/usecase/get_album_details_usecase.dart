import '../entities/album_details_entity.dart';
import '../repo/album_details_repository.dart';

class GetAlbumDetailsUseCase {
  final AlbumDetailsRepository repository;

  GetAlbumDetailsUseCase(this.repository);

  Future<AlbumDetailsEntity> call(String albumId) {
    return repository.getAlbumDetails(albumId);
  }
}
