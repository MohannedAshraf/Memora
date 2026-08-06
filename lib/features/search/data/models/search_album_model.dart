import '../../domain/entities/search_album_entity.dart';

class SearchAlbumModel extends SearchAlbumEntity {
  const SearchAlbumModel({
    required super.id,
    required super.title,
    required super.description,
    required super.updatedAt,
    required super.ownerId,
  });

  factory SearchAlbumModel.fromJson(Map<String, dynamic> json) {
    return SearchAlbumModel(
      id: json["id"],
      title: json["title"],
      description: json["description"] ?? "",
      updatedAt: DateTime.parse(json["updated_at"]),
      ownerId: json["owner_id"],
    );
  }
}
