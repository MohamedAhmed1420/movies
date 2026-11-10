import 'package:movies/modules/home/domain/entities/movie.dart';

abstract class MovieCollectionRepository {
  Stream<void> get changes;

  Future<List<Movie>> getWatchedMovies();

  Future<List<Movie>> getSavedMovies();

  Future<bool> isSaved(int movieId);

  Future<bool> toggleSavedMovie(Movie movie);

  Future<void> markMovieAsWatched(Movie movie);
}
