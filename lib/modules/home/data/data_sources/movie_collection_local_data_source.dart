import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies/modules/home/data/models/movie_model.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MovieCollectionLocalDataSource {
  Future<List<MovieModel>> getWatchedMovies();

  Future<List<MovieModel>> getSavedMovies();

  Future<bool> isSaved(int movieId);

  Future<bool> toggleSavedMovie(Movie movie);

  Future<void> markMovieAsWatched(Movie movie);
}

class MovieCollectionLocalDataSourceImpl
    implements MovieCollectionLocalDataSource {
  final SharedPreferencesAsync preferences;
  final FirebaseAuth auth;

  MovieCollectionLocalDataSourceImpl({
    required this.preferences,
    required this.auth,
  });

  String _key(String collection) {
    final userId = auth.currentUser?.uid ?? 'guest';
    return 'movie_collection_${userId}_$collection';
  }

  Future<List<MovieModel>> _read(String collection) async {
    final rows = await preferences.getStringList(_key(collection)) ?? const [];
    final movies = <MovieModel>[];
    for (final row in rows) {
      try {
        final decoded = jsonDecode(row);
        if (decoded is Map<String, dynamic>) {
          movies.add(MovieModel.fromJson(decoded));
        } else if (decoded is Map) {
          movies.add(MovieModel.fromJson(Map<String, dynamic>.from(decoded)));
        }
      } on FormatException {
        // Ignore entries that were corrupted or written by an older format.
      } on TypeError {
        // Ignore entries that do not match the movie model.
      }
    }
    return movies;
  }

  Future<void> _write(String collection, List<MovieModel> movies) {
    return preferences.setStringList(
      _key(collection),
      movies.map((movie) => jsonEncode(movie.toJson())).toList(),
    );
  }

  MovieModel _toModel(Movie movie) => MovieModel(
        id: movie.id,
        title: movie.title,
        summary: movie.summary,
        posterUrl: movie.posterUrl,
        rating: movie.rating,
      );

  @override
  Future<List<MovieModel>> getWatchedMovies() => _read('watched');

  @override
  Future<List<MovieModel>> getSavedMovies() => _read('saved');

  @override
  Future<bool> isSaved(int movieId) async {
    final movies = await getSavedMovies();
    return movies.any((movie) => movie.id == movieId);
  }

  @override
  Future<bool> toggleSavedMovie(Movie movie) async {
    final movies = await getSavedMovies();
    final wasSaved = movies.any((item) => item.id == movie.id);
    movies.removeWhere((item) => item.id == movie.id);
    if (!wasSaved) movies.add(_toModel(movie));
    await _write('saved', movies);
    return !wasSaved;
  }

  @override
  Future<void> markMovieAsWatched(Movie movie) async {
    final movies = await getWatchedMovies();
    movies.removeWhere((item) => item.id == movie.id);
    movies.add(_toModel(movie));
    await _write('watched', movies);
  }
}
