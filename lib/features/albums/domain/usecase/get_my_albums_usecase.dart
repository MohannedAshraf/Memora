import 'package:memora/features/albums/domain/repo/albums_repository.dart';

import '../entities/album_entity.dart';

class GetMyAlbumsUseCase {
  final AlbumsRepository repository;

  GetMyAlbumsUseCase(this.repository);

  Future<List<AlbumEntity>> call() {
    return repository.getMyAlbums();
  }
}
