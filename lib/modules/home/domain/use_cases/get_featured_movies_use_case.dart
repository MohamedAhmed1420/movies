import 'package:dartz/dartz.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/core/usecase/usecase.dart';
import 'package:movies/modules/home/domain/entities/movie.dart';
import 'package:movies/modules/home/domain/repositories/home_repository.dart';

class GetFeaturedMoviesUseCase
    implements UseCase<List<Movie>, NoParams> {
  final HomeRepository repository;

  const GetFeaturedMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) =>
      repository.getFeaturedMovies();
}
