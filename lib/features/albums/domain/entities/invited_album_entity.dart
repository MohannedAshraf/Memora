class InvitedAlbumEntity {
  final String id;
  final String title;
  final String? description;
  final String? coverPhotoId;
  final DateTime updatedAt;

  const InvitedAlbumEntity({
    required this.id,
    required this.title,
    this.description,
    this.coverPhotoId,
    required this.updatedAt,
  });
}
