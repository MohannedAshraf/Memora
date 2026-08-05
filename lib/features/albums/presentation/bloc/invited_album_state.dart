import 'package:memora/features/albums/domain/entities/invited_album_entity.dart';

abstract class InvitedAlbumsState {}

class InvitedAlbumsInitial extends InvitedAlbumsState {}

class InvitedAlbumsLoading extends InvitedAlbumsState {}

class InvitedAlbumsLoaded extends InvitedAlbumsState {
  final List<InvitedAlbumEntity> albums;

  InvitedAlbumsLoaded(this.albums);
}

class InvitedAlbumsFailure extends InvitedAlbumsState {
  final String message;

  InvitedAlbumsFailure(this.message);
}
