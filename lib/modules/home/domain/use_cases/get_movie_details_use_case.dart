import 'package:dartz/dartz.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/core/usecase/usecase.dart';
import 'package:movies/modules/home/domain/entities/movie_details.dart';
import 'package:movies/modules/home/domain/repositories/movie_repository.dart';

class GetMovieDetailsUseCase extends UseCase<MovieDetails, int> {
  final MovieRepository repository;

  GetMovieDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, MovieDetails>> call(int movieId) {
    return repository.getMovieDetails(movieId);
  }
}
