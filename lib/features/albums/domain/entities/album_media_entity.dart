import 'package:equatable/equatable.dart';

class AlbumMediaEntity extends Equatable {
  final String id;
  final String albumId;
  final String uploadedBy;
  final String storagePath;
  final String? caption;
  final DateTime createdAt;
  final String url;
  final bool isVideo;

  const AlbumMediaEntity({
    required this.id,
    required this.albumId,
    required this.uploadedBy,
    required this.storagePath,
    required this.caption,
    required this.createdAt,
    required this.url,
    required this.isVideo,
  });

  @override
  List<Object?> get props => [
    id,
    albumId,
    uploadedBy,
    storagePath,
    caption,
    createdAt,
    url,
    isVideo,
  ];
}
