
import '../../domain/entities/album_media_entity.dart';

class AlbumMediaModel extends AlbumMediaEntity {
  const AlbumMediaModel({
    required super.id,
    required super.albumId,
    required super.uploadedBy,
    required super.storagePath,
    required super.caption,
    required super.createdAt,
    required super.url,
    required super.isVideo,
  });

  factory AlbumMediaModel.fromJson({
    required Map<String, dynamic> json,
    required String url,
  }) {
    final storagePath = json['storage_path'] as String;

    return AlbumMediaModel(
      id: json['id'] as String,
      albumId: json['album_id'] as String,
      uploadedBy: json['uploaded_by'] as String,
      storagePath: storagePath,
      caption: json['caption'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      url: url,
      isVideo: _isVideo(storagePath),
    );
  }

  static bool _isVideo(String path) {
    final extension = path.split('.').last.toLowerCase();

    const videoExtensions = {'mp4', 'mov', 'avi', 'mkv', 'webm', 'm4v', '3gp'};

    return videoExtensions.contains(extension);
  }
}
