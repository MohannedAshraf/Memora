import '../../domain/entities/search_album_entity.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SearchAlbumEntity> albums;

  SearchLoaded(this.albums);
}

class SearchFailure extends SearchState {
  final String message;

  SearchFailure(this.message);
}
