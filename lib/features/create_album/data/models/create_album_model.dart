import '../../domain/entities/create_album_entity.dart';

class CreateAlbumModel extends CreateAlbumEntity {
  const CreateAlbumModel({
    required super.title,
    required super.description,
    required super.coverImage,
    required super.invitations,
  });

  factory CreateAlbumModel.fromEntity(CreateAlbumEntity entity) {
    return CreateAlbumModel(
      title: entity.title,
      description: entity.description,
      coverImage: entity.coverImage,
      invitations: entity.invitations,
    );
  }
}
