import 'package:equatable/equatable.dart';

class InvitationEntity extends Equatable {
  final String id;
  final String albumId;
  final String title;
  final String? description;
  final String invitedBy;
  final String role;
  final DateTime createdAt;

  const InvitationEntity({
    required this.id,
    required this.albumId,
    required this.title,
    this.description,
    required this.invitedBy,
    required this.role,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    albumId,
    title,
    description,
    invitedBy,
    role,
    createdAt,
  ];
}
