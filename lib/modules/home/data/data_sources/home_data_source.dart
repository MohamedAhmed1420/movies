import 'package:movies/modules/home/data/models/movie_model.dart';

abstract class HomeDataSource {
  Future<List<MovieModel>> getFeaturedMovies();

  Future<List<MovieModel>> getMoviesByGenre(String genre);
}
