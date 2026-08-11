import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String? actorId;
  final String type;
  final String title;
  final String? body;
  final String? albumId;
  final Map<String, dynamic>? metadata;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    this.actorId,
    required this.type,
    required this.title,
    this.body,
    this.albumId,
    this.metadata,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    actorId,
    type,
    title,
    body,
    albumId,
    metadata,
    isRead,
    createdAt,
  ];
}
