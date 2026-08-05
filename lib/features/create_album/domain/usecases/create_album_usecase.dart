import 'package:memora/features/create_album/domain/repo/create_album_repo.dart';

import '../entities/create_album_entity.dart';


class CreateAlbumUseCase {
  final CreateAlbumRepo repository;

  CreateAlbumUseCase(this.repository);

  Future<void> call(CreateAlbumEntity entity) {
    return repository.createAlbum(entity);
  }
}
