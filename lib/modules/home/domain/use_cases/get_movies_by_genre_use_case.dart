import 'package:dartz/dartz.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/core/usecase/usecase.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/domain/repositories/home_repository.dart';

class GetMoviesByGenreParams {
  final String genre;

  const GetMoviesByGenreParams(this.genre);
}

class GetMoviesByGenreUseCase
    implements UseCase<List<Movie>, GetMoviesByGenreParams> {
  final HomeRepository repository;

  const GetMoviesByGenreUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(
    GetMoviesByGenreParams params,
  ) =>
      repository.getMoviesByGenre(params.genre);
}
