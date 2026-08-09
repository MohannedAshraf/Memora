import 'package:equatable/equatable.dart';

import '../../domain/entities/album_details_entity.dart';

abstract class AlbumDetailsState extends Equatable {
  const AlbumDetailsState();

  @override
  List<Object?> get props => [];
}

class AlbumDetailsInitial extends AlbumDetailsState {}

class AlbumDetailsLoading extends AlbumDetailsState {}

class AlbumDetailsLoaded extends AlbumDetailsState {
  final AlbumDetailsEntity album;

  const AlbumDetailsLoaded(this.album);

  @override
  List<Object?> get props => [album];
}

class AlbumDetailsFailure extends AlbumDetailsState {
  final String message;

  const AlbumDetailsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
