import '../../domain/entities/album_details_entity.dart';

class AlbumDetailsModel extends AlbumDetailsEntity {
  const AlbumDetailsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.coverPhotoId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AlbumDetailsModel.fromJson(Map<String, dynamic> json) {
    return AlbumDetailsModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      coverPhotoId: json['cover_photo_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
