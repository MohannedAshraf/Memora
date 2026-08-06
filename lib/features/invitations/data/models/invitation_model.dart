import '../../domain/entities/invitation_entity.dart';

class InvitationModel extends InvitationEntity {
  const InvitationModel({
    required super.id,
    required super.albumId,
    required super.title,
    super.description,
    required super.invitedBy,
    required super.role,
    required super.createdAt,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    return InvitationModel(
      id: json["id"],
      albumId: json["album_id"],
      title: json["albums"]["title"],
      description: json["albums"]["description"],
      invitedBy: (json["profiles"] as Map<String, dynamic>?)?["email"] ?? "",
      role: json["role"],
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}
