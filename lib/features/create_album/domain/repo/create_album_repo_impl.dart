// ignore_for_file: strict_top_level_inference

import 'package:memora/features/create_album/data/data_sources/create_album_remote_data_source.dart';
import 'package:memora/features/create_album/data/models/create_album_model.dart';
import 'package:memora/features/create_album/domain/repo/create_album_repo.dart';

import '../../domain/entities/create_album_entity.dart';


class CreateAlbumsRepoImpl implements CreateAlbumRepo {
  final CreateAlbumRemoteDataSource remoteDataSource;

CreateAlbumsRepoImpl(this.remoteDataSource);

  @override
  Future<void> createAlbum(CreateAlbumEntity entity) async {
    final model = CreateAlbumModel.fromEntity(entity);

    await remoteDataSource.createAlbum(model);
  }
}
