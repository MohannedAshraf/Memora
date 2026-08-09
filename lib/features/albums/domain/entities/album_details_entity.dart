import 'package:equatable/equatable.dart';

class AlbumDetailsEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? coverPhotoId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlbumDetailsEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.coverPhotoId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    coverPhotoId,
    createdAt,
    updatedAt,
  ];
}
