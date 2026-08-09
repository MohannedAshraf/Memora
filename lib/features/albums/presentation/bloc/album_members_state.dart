import 'package:equatable/equatable.dart';

import '../../domain/entities/album_member_entity.dart';

abstract class AlbumMembersState extends Equatable {
  const AlbumMembersState();

  @override
  List<Object?> get props => [];
}

class AlbumMembersInitial extends AlbumMembersState {}

class AlbumMembersLoading extends AlbumMembersState {}

class AlbumMembersLoaded extends AlbumMembersState {
  final List<AlbumMemberEntity> members;

  const AlbumMembersLoaded(this.members);

  @override
  List<Object?> get props => [members];
}

class AlbumMembersFailure extends AlbumMembersState {
  final String message;

  const AlbumMembersFailure(this.message);

  @override
  List<Object?> get props => [message];
}
