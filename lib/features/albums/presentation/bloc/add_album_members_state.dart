import 'package:equatable/equatable.dart';

abstract class AddAlbumMembersState extends Equatable {
  const AddAlbumMembersState();

  @override
  List<Object?> get props => [];
}

class AddAlbumMembersInitial extends AddAlbumMembersState {}

class AddAlbumMembersLoading extends AddAlbumMembersState {}

class AddAlbumMembersSuccess extends AddAlbumMembersState {}

class AddAlbumMembersFailure extends AddAlbumMembersState {
  final String message;

  const AddAlbumMembersFailure(this.message);

  @override
  List<Object?> get props => [message];
}
