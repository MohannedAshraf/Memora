import 'package:equatable/equatable.dart';

abstract class CreateAlbumState extends Equatable {
  const CreateAlbumState();

  @override
  List<Object?> get props => [];
}

class CreateAlbumInitial extends CreateAlbumState {}

class CreateAlbumLoading extends CreateAlbumState {}

class CreateAlbumSuccess extends CreateAlbumState {}

class CreateAlbumFailure extends CreateAlbumState {
  final String message;

  const CreateAlbumFailure(this.message);

  @override
  List<Object?> get props => [message];
}
