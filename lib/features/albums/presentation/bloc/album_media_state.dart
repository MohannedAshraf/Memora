import 'package:equatable/equatable.dart';

import '../../domain/entities/album_media_entity.dart';

abstract class AlbumMediaState extends Equatable {
  const AlbumMediaState();

  @override
  List<Object?> get props => [];
}

class AlbumMediaInitial extends AlbumMediaState {}

class AlbumMediaLoading extends AlbumMediaState {}

class AlbumMediaLoaded extends AlbumMediaState {
  final List<AlbumMediaEntity> media;

  const AlbumMediaLoaded(this.media);

  @override
  List<Object?> get props => [media];
}

class AlbumMediaFailure extends AlbumMediaState {
  final String message;

  const AlbumMediaFailure(this.message);

  @override
  List<Object?> get props => [message];
}
