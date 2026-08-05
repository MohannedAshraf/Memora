import '../../domain/entities/invited_album_entity.dart';

class InvitedAlbumModel extends InvitedAlbumEntity {
  const InvitedAlbumModel({
    required super.id,
    required super.title,
    super.description,
    super.coverPhotoId,
    required super.updatedAt,
  });

  factory InvitedAlbumModel.fromJson(Map<String, dynamic> json) {
    return InvitedAlbumModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      coverPhotoId: json["cover_photo_id"],
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}
