import 'package:dartz/dartz.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Movie>>> getFeaturedMovies();

  Future<Either<Failure, List<Movie>>> getMoviesByGenre(String genre);
}
