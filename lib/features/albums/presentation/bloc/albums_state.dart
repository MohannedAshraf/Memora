import 'package:equatable/equatable.dart';

import '../../domain/entities/album_entity.dart';

abstract class AlbumsState extends Equatable {
  const AlbumsState();

  @override
  List<Object?> get props => [];
}

class AlbumsInitial extends AlbumsState {}

class AlbumsLoading extends AlbumsState {}

class AlbumsLoaded extends AlbumsState {
  final List<AlbumEntity> albums;

  const AlbumsLoaded(this.albums);

  @override
  List<Object?> get props => [albums];
}

class AlbumsFailure extends AlbumsState {
  final String message;

  const AlbumsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
