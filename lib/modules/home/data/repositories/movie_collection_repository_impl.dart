import 'dart:async';

import 'package:movies/modules/home/data/data_sources/movie_collection_local_data_source.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/domain/repositories/movie_collection_repository.dart';

class MovieCollectionRepositoryImpl implements MovieCollectionRepository {
  final MovieCollectionLocalDataSource localDataSource;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  MovieCollectionRepositoryImpl({required this.localDataSource});

  @override
  Stream<void> get changes => _changes.stream;

  @override
  Future<List<Movie>> getWatchedMovies() => localDataSource.getWatchedMovies();

  @override
  Future<List<Movie>> getSavedMovies() => localDataSource.getSavedMovies();

  @override
  Future<bool> isSaved(int movieId) => localDataSource.isSaved(movieId);

  @override
  Future<bool> toggleSavedMovie(Movie movie) async {
    final isSaved = await localDataSource.toggleSavedMovie(movie);
    _changes.add(null);
    return isSaved;
  }

  @override
  Future<void> markMovieAsWatched(Movie movie) async {
    await localDataSource.markMovieAsWatched(movie);
    _changes.add(null);
  }
}
