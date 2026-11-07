import 'package:dartz/dartz.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/domain/entities/movie_details.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getMovies({
    required int page,
    String? queryTerm,
    String? genre,
  });

  Future<Either<Failure, MovieDetails>> getMovieDetails(int movieId);

  Future<Either<Failure, List<Movie>>> getMovieSuggestions(int movieId);
}
