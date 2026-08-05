import 'package:equatable/equatable.dart';

class AlbumEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? coverPhotoId;
  final DateTime updatedAt;

  const AlbumEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.coverPhotoId,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, description, coverPhotoId, updatedAt];
}
