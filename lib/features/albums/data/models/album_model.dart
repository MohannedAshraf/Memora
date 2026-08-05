import '../../domain/entities/album_entity.dart';

class AlbumModel extends AlbumEntity {
  const AlbumModel({
    required super.id,
    required super.title,
    required super.description,
    required super.coverPhotoId,
    required super.updatedAt,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] ?? '',
      coverPhotoId: json['cover_photo_id'] as String?,
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  factory AlbumModel.fromEntity(AlbumEntity entity) {
    return AlbumModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      coverPhotoId: entity.coverPhotoId,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'cover_photo_id': coverPhotoId,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
