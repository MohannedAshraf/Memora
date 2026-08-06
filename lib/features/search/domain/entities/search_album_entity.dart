import 'package:equatable/equatable.dart';

class SearchAlbumEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime updatedAt;
  final String ownerId;

  const SearchAlbumEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.updatedAt,
    required this.ownerId,
  });

  @override
  List<Object?> get props => [id, title, description, updatedAt, ownerId];
}
