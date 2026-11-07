import 'package:dartz/dartz.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/core/usecase/usecase.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/domain/repositories/movie_repository.dart';

class GetMoviesParams {
  final int page;
  final String? queryTerm;
  final String? genre;

  const GetMoviesParams({
    this.page = 1,
    this.queryTerm,
    this.genre,
  });
}

class GetMoviesUseCase extends UseCase<List<Movie>, GetMoviesParams> {
  final MovieRepository repository;

  GetMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GetMoviesParams params) {
    return repository.getMovies(
      page: params.page,
      queryTerm: params.queryTerm,
      genre: params.genre,
    );
  }
}
